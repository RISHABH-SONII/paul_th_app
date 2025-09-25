import 'package:tharkyApp/models/message_model.dart';
import 'package:tharkyApp/utils/common.dart';

class BaseResponseModel {
  String? message;
  var data;

  BaseResponseModel({this.message, this.data});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class MeetingResponse {
  String? id;
  bool? status;

  Message? message;
  Room? room;
  var data;

  MeetingResponse({this.id, this.status});

  factory MeetingResponse.fromJson(Map<String, dynamic> json) {
    return MeetingResponse();
  }
}

class SendMessageResponse {
  Message? message;
  Room? room;
  var data;

  SendMessageResponse({this.message, this.room, this.data});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message:
          json['message'] != null ? Message.fromJson(json['message']) : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message?.toString();
    data['room'] = this.room?.toString();
    data['data'] = this.data;
    return data;
  }
}

class OnlineUser {
  String? id;
  String? status;

  Message? message;
  Room? room;
  var data;

  OnlineUser({this.id, this.status});

  factory OnlineUser.fromJson(Map<String, dynamic> json) {
    return OnlineUser(
      id: "${json['id']}",
      status: json['status'],
    );
  }
}

class TypingRoom {
  String? id;
  bool? status;

  Message? message;
  Room? room;
  var data;

  TypingRoom({this.id, this.status});

  factory TypingRoom.fromJson(Map<String, dynamic> json) {
    return TypingRoom(
      id: "${json['id']}",
      status: json['status'],
    );
  }
}
