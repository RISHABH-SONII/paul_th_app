import 'package:tharkyApp/models/user_model.dart';

class OtpResponse {
  User? data;
  bool? isUserExist;
  bool? status;
  String? message;

  OtpResponse({this.data, this.isUserExist, this.status, this.message});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      data: json['data'] != null ? User.fromJson(json['data']) : null,
      isUserExist: json['is_user_exist'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['is_user_exist'] = this.isUserExist;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
