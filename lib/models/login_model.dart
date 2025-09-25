import 'package:tharkyApp/models/user_model.dart';

class LoginResponse {
  User? data;
  bool? isUserExist;
  bool? status;
  String? token;

  LoginResponse({this.data, this.isUserExist, this.status, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['data'] != null ? User.fromJson(json['data']) : null,
      isUserExist: json['is_user_exist'],
      status: json['status'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['is_user_exist'] = this.isUserExist;
    data['status'] = this.status;
    data['message'] = this.token;
    return data;
  }
}
