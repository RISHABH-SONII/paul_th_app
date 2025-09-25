import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tharkyApp/Screens/Payment/paymentFormScreen/paymentFormController.dart';


class PaymentFormScreen extends StatelessWidget {
  final Map transaction;

  final PaymentFormController controller = Get.put(PaymentFormController());

  PaymentFormScreen({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final amount = transaction["amount"]["total"];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          title: const Text(
        "Enter Payment Details",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),

      )),
      body: SingleChildScrollView(
        child: Obx(
          () {
            return controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            _buildCardWidget(),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transaction Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),

                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Payment Reason",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        transaction["description"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Sub Total",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        amount.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Amount",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        amount.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.confirmAndPay(
                                  context: context,
                                  amount: amount,
                                  productName: transaction["description"],
                                  transaction: transaction,
                                );
                              }
                            },
                            child: Text("Pay \£{amount}"),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildCardWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        key: controller.formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Card Holder Name",
              style: TextStyle(color: Colors.white70),
            ),
            _buildTextField(
              assignedController: controller.nameController,
              hintText: "XYZ",
              keyboardType: TextInputType.text,
              validator: (v) => v!.isEmpty ? "Enter card holders name" : null,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Card Number",
              style: TextStyle(color: Colors.white70),
            ),
            _buildTextField(
              assignedController: controller.cardNumberController,
              padding: EdgeInsets.symmetric(vertical: 12.0),
              hintText: "#### #### #### ####",
              keyboardType: TextInputType.number,
              validator: (v) {
                final unmasked = controller.cardFormatter.getUnmaskedText();
                if (unmasked.length != 16) {
                  return "Enter valid 16-digit card number";
                }
                return null;
              },
              isSuffix: true,
              isInputFormatter: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expiry Date",
                        style: TextStyle(color: Colors.white70),
                      ),
                      _buildTextField(
                        assignedController: controller.expiryController,
                        hintText: "(MM/YY)",
                        keyboardType: TextInputType.datetime,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return "Enter expiry date";
                          final parts = v.split('/');
                          if (parts.length != 2) return "Invalid format";
                          final month = int.tryParse(parts[0]);
                          final year = int.tryParse(parts[1]);
                          if (month == null || month < 1 || month > 12)
                            return "Invalid month";
                          if (year == null || year < 0) return "Invalid year";
                          return null;
                        },
                        isInputFormatter: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "CVV",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Obx(() {
                        final isAmex = controller.cardType.value == 'amex';
                        return _buildTextField(
                          assignedController: controller.cvvController,
                          hintText: isAmex ? "e.g-1234" : "e.g-123",
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Enter CVV";
                            if (!RegExp(r'^\d+$').hasMatch(v))
                              return "CVV must be numeric";
                            if (isAmex && v.length != 4)
                              return "AMEX CVV must be 4 digits";
                            if (!isAmex && v.length != 3)
                              return "CVV must be 3 digits";
                            return null;
                          },
                          isObscureText: true,
                          customMaxLength: isAmex ? 4 : 3,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget? getCardIcon(String type) {
    switch (type) {
      case 'visa':
        return Image.asset('asset/icons/visa_icon.png', width: 32);
      case 'mastercard':
        return Image.asset('asset/icons/mastercard_icon.png', width: 32);
      case 'amex':
        return Image.asset('asset/icons/american_express_icon.png', width: 32);
      case 'discover':
        return Image.asset('asset/icons/discover_icon.png', width: 32);
      case 'rupay':
        return Image.asset('asset/icons/rupay_icon.png', width: 32);
      case 'maestro':
        return Image.asset('asset/icons/maestro_icon.png', width: 32);
      case 'diners':
        return Image.asset('asset/icons/diners_icon.png', width: 32);
      case 'jcb':
        return Image.asset('asset/icons/jcb_icon.png', width: 32);
      default:
        return null;
    }
  }

  Widget _buildTextField({
    TextEditingController? assignedController,
    String? hintText,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    bool? isSuffix,
    bool? isInputFormatter,
    bool? isObscureText,
    bool? isReadonly,
    int? customMaxLength,
    EdgeInsets? padding,
  }) {
    return TextFormField(
      cursorColor: Colors.white,
      maxLines: 1,
      cursorWidth: 0.5,
      maxLength: customMaxLength != null ? customMaxLength : null,
      readOnly: isReadonly == true ? true : false,
      controller: assignedController,
      inputFormatters: isInputFormatter == true
          ? [
              assignedController == controller.cardNumberController
                  ? controller.cardFormatter
                  : controller.expiryFormatter
            ]
          : null,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding:
            padding != null ? padding : EdgeInsets.symmetric(vertical: 8),
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: isSuffix == true
            ? Obx(() {
                final icon = getCardIcon(controller.cardType.value);
                return icon ??
                    const SizedBox.shrink(); // fallback to empty widget if null
              })
            : null,
        disabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      obscureText: isObscureText == true ? true : false,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
