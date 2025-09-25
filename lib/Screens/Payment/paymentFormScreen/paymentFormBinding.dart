import 'package:get/get.dart';
import 'package:tharkyApp/Screens/Payment/paymentFormScreen/paymentFormController.dart';


class Paymentformbinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>PaymentFormController());
  }
}