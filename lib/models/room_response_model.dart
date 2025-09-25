import 'package:tharkyApp/models/message_model.dart';

class RoomResponseModel {
  String? message;
  Room? room;

  RoomResponseModel({this.message, this.room});

  factory RoomResponseModel.fromJson(Map<String, dynamic> json) {
    return RoomResponseModel(
      message: json['message'],
      room: Room.fromJson(json['room']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
