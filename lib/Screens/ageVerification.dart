import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'dart:math' as math;

import 'package:screenshot/screenshot.dart';
import 'package:tharkyApp/components/mail_opener.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/services/ageEstimator.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/constant.dart';

class AgeVerificationScreen extends StatefulWidget {
  final CameraDescription camera;

  AgeVerificationScreen(this.camera);

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final AgeEstimator _ageEstimator = AgeEstimator();
  final faceDetector = FaceDetector(options: FaceDetectorOptions());

  String? predictedAgeRange;
  int? _estimatedAge;
  bool _modelLoaded = false;
  bool _isProcessing = false;
  List<Face> _faces = [];
  bool _isDetectingFaces = false;
  Timer? _faceDetectionTimer;
  bool _isCapturing = false; // any takePicture in-flight
  bool _faceDetectionPaused = false;
  double? _lastConf;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize().then((_) {
      _startFaceDetection();
    });

    // Load model safely
    _ageEstimator.loadModel().then((_) {
      setState(() => _modelLoaded = true);
    });
  }

  void _startFaceDetection() {
    _faceDetectionTimer?.cancel();
    _faceDetectionTimer =
        Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_controller.value.isInitialized &&
          !_faceDetectionPaused &&
          !_isDetectingFaces &&
          !_isCapturing &&
          !_isProcessing &&
          !_controller.value.isTakingPicture) {
        // extra guard (available on camera >=0.10)
        _detectFacesInFrame();
      }
    });
  }

  Future<void> _detectFacesInFrame() async {
    if (!_controller.value.isInitialized ||
        _isDetectingFaces ||
        _isCapturing ||
        _isProcessing) return;

    setState(() => _isDetectingFaces = true);

    try {
      _isCapturing = true; // serialize takePicture
      final image = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await faceDetector.processImage(inputImage);

      if (!mounted) return;
      setState(() => _faces = faces);

      try {
        await File(image.path).delete();
      } catch (_) {}
    } catch (e) {
      print("Face detection error: $e");
    } finally {
      _isCapturing = false;
      if (mounted) setState(() => _isDetectingFaces = false);
    }
  }

  @override
  void dispose() {
    _faceDetectionTimer?.cancel();
    faceDetector.close(); // <- release ML Kit
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndEstimate() async {
    if (!_modelLoaded || _isProcessing || _faces.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _faceDetectionPaused = true; // stop timer from firing
    });

    // ensure no face-detect capture is mid-flight
    while (_isDetectingFaces ||
        _isCapturing ||
        _controller.value.isTakingPicture) {
      await Future.delayed(const Duration(milliseconds: 20));
    }

    try {
      await _initializeControllerFuture;
      _isCapturing = true;
      final image = await _controller.takePicture();
      final rawFile = File(image.path);
      // ✅ Decode raw file
      final fileBytes = await rawFile.readAsBytes();
      final decoded = img.decodeImage(fileBytes)!;
      // ✅ Flip horizontally to mirror front camera
      final flipped = img.flipHorizontal(decoded);

      // ✅ Save flipped file so UI preview shows same as model input
      final tempDir = await getTemporaryDirectory();
      final flippedPath =
          '${tempDir.path}/captured_flipped_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final flippedFile = File(flippedPath)
        ..writeAsBytesSync(img.encodeJpg(flipped));

      _capturedImage = flippedFile; // ✅ Changed (was rawFile before)

      // _capturedImage = File(image.path); // 🔥 NEW: save picture

      // Load image
      final inputImage = InputImage.fromFilePath(flippedFile.path);
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        if (!mounted) return;
        setState(() {
          predictedAgeRange = null;
          _estimatedAge = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No face detected. Try again.")),
        );
        return;
      }

      final face = faces.first;
      final bb = faces.first.boundingBox;

      // Mirror bbox for flipped image
      final mirrored = Rect.fromLTRB(
        flipped.width - bb.right,
        bb.top,
        flipped.width - bb.left,
        bb.bottom,
      );

      const pad = 0.35;
      final cx = (mirrored.left + mirrored.right) / 2.0;
      final cy = (mirrored.top + mirrored.bottom) / 2.0;
      final side =
          (math.max(mirrored.width, mirrored.height) * (1 + 2 * pad)).toInt();

      final half = (side / 2).floor();
      int x0 = (cx - half).floor();
      int y0 = (cy - half).floor();
      x0 = x0.clamp(0, flipped.width - side);
      y0 = y0.clamp(0, flipped.height - side);

      final cropped =
          img.copyCrop(flipped, x: x0, y: y0, width: side, height: side);

      final ageRange = _ageEstimator.predictAgeRange(cropped);
      final approxAge =
          _ageEstimator.predictApproximateAge(cropped); // <-- add this

      if (!mounted) return;
      setState(() {
        predictedAgeRange = ageRange;
        _estimatedAge =
            approxAge >= 0 ? approxAge : null; // -1 means "Unable to determine"
      });
    } catch (e) {
      print("Error during age estimation: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      _isCapturing = false;
      if (mounted) {
        setState(() {
          _isProcessing = false;
          // _faceDetectionPaused = false;
        });
      }
    }
  }

  Widget _cameraOrImage() {
    if (_capturedImage != null) {
      // 🔥 NEW: Show still image instead of live preview
      return Image.file(_capturedImage!, fit: BoxFit.cover);
    }
    return _cameraWithOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Age Verification',
              style: TextStyle(color: Colors.black)),
          // backgroundColor: Colors.blue,
          // foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            SizedBox(height: 8),
            Text(
              "You may need to try a few times",
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return _cameraOrImage();
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_capturedImage == null) ...[
                    if (_faces.isEmpty)
                      Text(
                        "Please position your face in the frame",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (_faces.isNotEmpty)
                      Text(
                        "Face detected! Ready to estimate age",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                  const SizedBox(height: 16),
                  _capturedImage == null
                      ? ElevatedButton(
                          onPressed: _modelLoaded &&
                                  !_isProcessing &&
                                  _faces.isNotEmpty
                              ? _captureAndEstimate
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _capturedImage == null && _faces.isNotEmpty
                                    ? Colors.blue
                                    : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            minimumSize: Size(200, 50),
                          ),
                          child: _isProcessing
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Estimate Age',
                                  style: TextStyle(fontSize: 18)),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: _capturedImage == null ? 16 : 0),
                  if (predictedAgeRange != null) ...[
                    Text(
                      'Predicted Age Range:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      predictedAgeRange!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    if (_estimatedAge != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Estimated: $_estimatedAge',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              (_estimatedAge! < 21) ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Screenshot, continue, email it to us',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      // Text(
                      //   (_estimatedAge! < 21)
                      //       ? 'Under 21 estimated — official ID required.'
                      //       : '21+ estimated — you can continue.',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color:
                      //     (_estimatedAge! < 21) ? Colors.red : Colors.green,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _capturedImage = null;
                              predictedAgeRange = null;
                              _estimatedAge = null;
                              _faces.clear();
                              _faceDetectionPaused = false;
                              _startFaceDetection(); // restart camera
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Try Again'),
                        ),
                        InkWell(
                          onTap: () async {
                            final imageFile =
                                await screenshotController.capture();
                            if (imageFile != null) {
                              final directory =
                                  await getApplicationDocumentsDirectory();
                              final imagePath =
                                  '${directory.path}/age_verification.png';
                              final file = File(imagePath);
                              await file.writeAsBytes(imageFile);
                              print('Screenshot saved at $imagePath');
                              _showAlertDialogue(file, imageFile);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Failed to capture screenshot.")),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: predictedAgeRange != null
                                    ? [
                                        primaryColor.withOpacity(.5),
                                        primaryColor.withOpacity(.8),
                                        primaryColor,
                                        primaryColor,
                                      ]
                                    : [white, white],
                              ), // No gradient if username is empty
                              color: predictedAgeRange == null
                                  ? secondryColor
                                  : primaryColor, // Fallback color for empty username
                            ),
                            height: MediaQuery.of(context).size.height * .052,
                            width: MediaQuery.of(context).size.width * .35,
                            child: Center(
                              child: Text(
                                "Email It To Us".tr().toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: predictedAgeRange != null
                                      ? white
                                      : secondryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (!_modelLoaded)
                    const Text(
                      "Loading age model...",
                      style: TextStyle(color: Colors.orange),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ...

  Future<void> _showAlertDialogue(File file, Uint8List imageFile) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      // user cannot dismiss by tapping outside
      builder: (BuildContext context) {
        String? selectedEmail; // Track which email is selected
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          titlePadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2196F3), // Blue
                  Color(0xFF21CBF3), // Cyan
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              "Age Verification Required",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins-Regular"),
            ),
            width: double.infinity,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "To use this app you must verify your age.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 8.0),
              Text(
                // "Please send us a selfie holding your government-issued ID to one of the following email addresses:",
                "Email your screenshot of your AI age estimator and the app you are joining to:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),
              ),
              SizedBox(height: 8.0),
              InkWell(
                onTap: () {
                  selectedEmail = "nextgendates@gmail.com";
                  if (file.path != null) {
                    MailOpener.openGmailCompose(
                      email: selectedEmail!, // Pass the selected email
                      subject: "Age Verification",
                      body:
                          "Please find my age verification screenshot attached with other documents",
                      attachmentPath: file.path,
                    );
                  }
                },
                child: Text(
                  "nextgendates@gmail.com",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins-Regular"),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "If we determine that you may not be above the age of 18, we may ask you for a selfie with your photo ID included. We will then verify you manually and you will be able go to the login and enter the app.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),
              ),
            ],
          ),
          actionsPadding: EdgeInsets.zero,
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Back To Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins-Regular"),
                          ),
                        ),
                        onTap: () async {
                          await logout(context).whenComplete(() {
                            void resetInterestList() {
                              for (var interest in interestList) {
                                interest["ontap"] = false;
                              }
                            }
                            resetInterestList();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins-Regular"),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _cameraWithOverlay() {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Camera plugin’s previewSize is landscape (width > height).
    final Size p = _controller.value.previewSize!;
    final double previewW = p.height; // swap due to sensor orientation
    final double previewH = p.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Make a square window
        final double box = constraints.maxWidth; // parent already sized square

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FittedBox(
            fit: BoxFit.cover, // <-- makes camera fill the square
            child: SizedBox(
              width: previewW,
              height: previewH,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // mirror front camera to match your UI
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: CameraPreview(_controller),
                  ),

                  // Draw face box in the SAME coordinate space (previewW x previewH)
                  if (_faces.isNotEmpty)
                    ..._faces.map((f) {
                      final Rect r = f.boundingBox;

                      return Positioned(
                        left: previewW - r.right,
                        // because we mirrored
                        top: r.top,
                        width: r.width,
                        height: r.height,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
