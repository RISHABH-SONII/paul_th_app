import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class PaymentFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  RxString cardType = ''.obs;
  RxBool isLoading = false.obs;

  final cardFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final expiryFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void onInit() {
    super.onInit();
    cardNumberController.addListener(_updateCardType);
  }

  String detectCardType(String input) {
    final number = input.replaceAll(RegExp(r'\D'), '');

    if (RegExp(r'^4').hasMatch(number)) return 'visa';
    if (RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)').hasMatch(number)) return 'mastercard';
    if (RegExp(r'^3[47]').hasMatch(number)) return 'amex';
    if (RegExp(r'^(6011|65|64[4-9])').hasMatch(number)) return 'discover';
    if (RegExp(r'^(60|6521|6522)').hasMatch(number)) return 'rupay';
    if (RegExp(r'^(50|5[6-9]|6[0-9])').hasMatch(number)) return 'maestro';
    if (RegExp(r'^3[689]').hasMatch(number)) return 'diners';
    if (RegExp(r'^35(2[89]|[3-8][0-9])').hasMatch(number)) return 'jcb';

    return 'unknown';
  }

  void _updateCardType() {
    final detected = detectCardType(cardNumberController.text);
    if (cardType.value != detected) {
      cardType.value = detected;
    }
  }

  Future<void> confirmAndPay({
    required BuildContext context,
    required double amount,
    required String productName,
    required Map transaction,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text(
            "You're about to pay \$${amount.toStringAsFixed(2)} for $productName. Continue?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Pay")),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoading.value = true;

    try {
      Future.delayed(
        const Duration(seconds: 2),
            () => print("Payment under process"),
      );
      // Uncomment this for real backend logic
      // final response = await http.post(
      //   Uri.parse("https://your-backend.com/api/paymentwall/charge"),
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode({
      //     "card_number": cardNumberController.text,
      //     "expiry": expiryController.text,
      //     "cvv": cvvController.text,
      //     "name": nameController.text,
      //     "amount": amount,
      //     "transaction": transaction,
      //   }),
      // );
      //
      // if (response.statusCode == 200) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Payment Successful")),
      //   );
      //   Navigator.pop(context, true);
      // } else {
      //   throw Exception("Payment failed");
      // }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}
