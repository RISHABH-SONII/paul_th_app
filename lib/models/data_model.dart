import 'package:tharkyApp/models/user_model.dart';

class Notify {
  final User? sender;
  final int? time;
  final bool? isRead;

  Notify({
    this.sender,
    this.time,
    this.isRead,
  });
}
