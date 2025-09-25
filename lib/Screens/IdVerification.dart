import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tharkyApp/Screens/UserDOB.dart';
import 'package:tharkyApp/utils/colors.dart';

class IdVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const IdVerificationScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends State<IdVerificationScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _idImage;

  Future<void> _pickFromCamera() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (file != null) setState(() => _idImage = File(file.path));
  }

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _idImage = File(file.path));
  }

  void _submit() {
    if (_idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please attach a clear photo of your official ID.")),
      );
      return;
    }

    // TODO: upload to your backend & store URL; here we just stash local path.
    widget.userData.addAll({
      'idProofLocalPath': _idImage!.path,
      'ageVerified': true,          // mark verified after collecting ID
      'requiresIdProof': false,
    });

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => UserDOB(widget.userData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final est = widget.userData['estimatedAge'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Age',style: TextStyle(color: Colors.black),),
        // backgroundColor: Colors.blue,
        // foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              (est is int)
                  ? "Estimated age: $est (under 21). Please upload an official ID to continue."
                  : "We couldn’t confidently estimate your age. Please upload an official ID to continue.",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            if (_idImage != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(_idImage!, fit: BoxFit.cover),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("No ID image selected"),
              ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickFromGallery,
                    child: const Text("Choose from Gallery"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickFromCamera,
                    child: const Text("Capture with Camera"),
                  ),
                ),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _submit,
                child: const Text("Submit & Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
