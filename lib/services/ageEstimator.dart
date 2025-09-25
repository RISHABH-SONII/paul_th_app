import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class AgeEstimator {
  Interpreter? _interpreter;
  List<int>? _inputShape;
  List<int>? _outputShape;

  /// Load the TFLite age estimation model
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('asset/ml/age_model.tflite');

      var inputTensor = _interpreter!.getInputTensor(0);
      var outputTensor = _interpreter!.getOutputTensor(0);

      _inputShape = inputTensor.shape;
      _outputShape = outputTensor.shape;

      print("✅ Model loaded");
      print("   Input shape: $_inputShape");
      print("   Output shape: $_outputShape");
      print("   Output type: ${outputTensor.type}");
      print("   Number of age classes: ${_outputShape![1]}");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  String predictAgeRange(img.Image faceImage) {
    if (_interpreter == null || _inputShape == null || _outputShape == null) {
      throw Exception("Model not loaded. Call loadModel() first.");
    }

    final inputSize = _inputShape![1];
    final resized = img.copyResize(
      faceImage,
      width: inputSize,
      height: inputSize,
    );

    // Prepare input with BGR order and ImageNet normalization
    var input = List.generate(
      inputSize,
      (y) => List.generate(
        inputSize,
        (x) {
          final pixel = resized.getPixel(x, y);
          return [
            (pixel.b - 103.939) / 57.375, // Blue
            (pixel.g - 116.779) / 57.12, // Green
            (pixel.r - 123.68) / 58.393, // Red
          ];
        },
      ),
    ).reshape([1, inputSize, inputSize, 3]);

    // Output buffer
    var output =
        List.filled(_outputShape![1], 0.0).reshape([1, _outputShape![1]]);

    // Run inference
    _interpreter!.run(input, output);

    final outputLength = output[0].length;
    print("Output length: $outputLength");

    // Define age ranges in 5-year intervals (0-100 years = 20 classes)
    // final List<String> ageRanges = [
    //   "0-4 years",    // Class 0
    //   "5-9 years",    // Class 1
    //   "10-14 years",  // Class 2
    //   "15-19 years",  // Class 3
    //   "20-24 years",  // Class 4
    //   "25-29 years",  // Class 5
    //   "30-34 years",  // Class 6
    //   "35-39 years",  // Class 7
    //   "40-44 years",  // Class 8
    //   "45-49 years",  // Class 9
    //   "50-54 years",  // Class 10
    //   "55-59 years",  // Class 11
    //   "60-64 years",  // Class 12
    //   "65-69 years",  // Class 13
    //   "70-74 years",  // Class 14
    //   "75-79 years",  // Class 15
    //   "80-84 years",  // Class 16
    //   "85-89 years",  // Class 17
    //   "90-94 years",  // Class 18
    //   "95-100 years"  // Class 19
    // ];

    // If your model still has only 9 outputs, use this instead:

    final List<String> ageRanges = [
      // "0-12 years",     // Class 0 - Children
      // "13-19 years",    // Class 1 - Teens
      // "20-29 years",    // Class 2 - Young Adults
      // "30-39 years",    // Class 3 - Adults
      // "40-49 years",    // Class 4 - Middle-aged
      // "50-59 years",    // Class 5 - Senior Adults
      // "60-69 years",    // Class 6 - Seniors
      // "70-79 years",    // Class 7 - Elderly
      // "80+ years"       // Class 8 - Very Elderly
      "0-6 years", // Class 0
      "7-13 years", // Class 1
      "14-20 years", // Class 2
      "21-27 years", // Class 3
      "28-34 years", // Class 4
      "35-41 years", // Class 5
      "42-48 years", // Class 6
      "49-55 years", // Class 7
      "56+ years" // Class 8
    ];

    // Find the class with highest probability
    double maxProb = 0;
    int predictedClass = 0;
    for (int i = 0; i < outputLength; i++) {
      if (output[0][i] > maxProb) {
        maxProb = output[0][i];
        predictedClass = i;
      }
    }
    if (maxProb < 0.3) {
      print(
          "Low confidence prediction: ${(maxProb * 100).toStringAsFixed(1)}%");
      return "Unable to determine";
    }
    // Safe debugging - show first few probabilities
    final endIndex = outputLength < 5 ? outputLength : 5;
    final firstFew = output[0].sublist(0, endIndex);
    print("Top probabilities: $firstFew");
    print(
        "Predicted age class: $predictedClass (${ageRanges[predictedClass]})");
    print("Confidence: ${(maxProb * 100).toStringAsFixed(1)}%");

    return ageRanges[predictedClass];
  }

  // Optional: Get approximate age from class (midpoint)
  int predictApproximateAge(img.Image faceImage) {
    final ageRange = predictAgeRange(faceImage);
    return _getAgeFromRange(ageRange);
  }

  int _getAgeFromRange(String ageRange) {
    // For 5-year intervals
    // switch (ageRange) {
    //   case "0-4 years": return 2;
    //   case "5-9 years": return 7;
    //   case "10-14 years": return 12;
    //   case "15-19 years": return 17;
    //   case "20-24 years": return 22;
    //   case "25-29 years": return 27;
    //   case "30-34 years": return 32;
    //   case "35-39 years": return 37;
    //   case "40-44 years": return 42;
    //   case "45-49 years": return 47;
    //   case "50-54 years": return 52;
    //   case "55-59 years": return 57;
    //   case "60-64 years": return 62;
    //   case "65-69 years": return 67;
    //   case "70-74 years": return 72;
    //   case "75-79 years": return 77;
    //   case "80-84 years": return 82;
    //   case "85-89 years": return 87;
    //   case "90-94 years": return 92;
    //   case "95-100 years": return 97;
    //   default: return 25;
    // }

    // If using the 9-class system, use this instead:

    // switch (ageRange) {
    //   case "0-6 years": return 5;
    //   case "7-13 years": return 15;
    //   case "14-20 years": return 25;
    //   case "21-27 years": return 35;
    //   case "28-34 years": return 45;
    //   case "35-41 years": return 55;
    //   case "42-48 years": return 65;
    //   case "49-55 years": return 75;
    //   case "56+ years": return 85;
    //   default: return 25;
    // }

    switch (ageRange) {
      case "0-6 years":
        return 3; // Midpoint of 0-6
      case "7-13 years":
        return 10; // Midpoint of 7-13
      case "14-20 years":
        return 17; // Midpoint of 14-20
      case "21-27 years":
        return 24; // Midpoint of 21-27
      case "28-34 years":
        return 31; // Midpoint of 28-34
      case "35-41 years":
        return 38; // Midpoint of 35-41
      case "42-48 years":
        return 45; // Midpoint of 42-48
      case "49-55 years":
        return 52; // Midpoint of 49-55
      case "56+ years":
        return 60; // Approximate for 56+
      case "Unable to determine":
        return -1;
      default:
        return 25;
    }
  }
}
