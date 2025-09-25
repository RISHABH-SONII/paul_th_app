import 'package:flutter/material.dart';
import 'package:tharkyApp/models/message_model.dart';

class NotificationModel {
  final String id;
  final String recipientId;
  final String? senderId;
  final String? meetingId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final bool isRead;
  final NotificationPriority priority;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Meeting? meeting;

  NotificationModel({
    required this.id,
    required this.recipientId,
    this.senderId,
    this.meetingId,
    required this.type,
    required this.title,
    required this.meeting,
    required this.body,
    this.data = const {},
    this.isRead = false,
    this.priority = NotificationPriority.medium,
    DateTime? createdAt,
    this.expiresAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      recipientId: json['recipient'],
      meeting:
          json['meeting'] != null ? Meeting.fromJson(json['meeting']) : null,
      senderId: json['sender'],
      meetingId: json['meetingId'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.system,
      ),
      title: json['title'],
      body: json['body'],
      data: json['data'] ?? {},
      isRead: json['isRead'] ?? false,
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientId': recipientId,
      'senderId': senderId,
      'meetingId': meetingId,
      'type': type.toString().split('.').last,
      'title': title,
      'body': body,
      'data': data,
      'isRead': isRead,
      'priority': priority.toString().split('.').last,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? recipientId,
    String? senderId,
    String? meetingId,
    Meeting? meeting,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    NotificationPriority? priority,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      meetingId: meetingId ?? this.meetingId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      meeting: meeting ?? this.meeting,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

enum NotificationType {
  callIncoming,
  callMissed,
  callRejected,
  message,
  groupActivity,
  system,
  friendRequest,
  meetingStarted,
  meetingEnded,
  like,
  match,
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

// Helper extension for notification type labels
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.callIncoming:
        return 'Incoming Call';
      case NotificationType.callMissed:
        return 'Missed Call';
      case NotificationType.callRejected:
        return 'Call Rejected';
      case NotificationType.message:
        return 'New Message';
      case NotificationType.groupActivity:
        return 'Group Activity';
      case NotificationType.system:
        return 'System Notification';
      case NotificationType.friendRequest:
        return 'Friend Request';
      case NotificationType.meetingStarted:
        return 'Meeting Started';
      case NotificationType.meetingEnded:
        return 'Meeting Ended';
      default:
        return 'Like';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.callIncoming:
        return Icons.call_received;
      case NotificationType.callMissed:
        return Icons.call_missed;
      case NotificationType.callRejected:
        return Icons.call_missed_outgoing;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.groupActivity:
        return Icons.group;
      case NotificationType.system:
        return Icons.notifications;
      case NotificationType.friendRequest:
        return Icons.person_add;
      case NotificationType.meetingStarted:
        return Icons.videocam;
      case NotificationType.meetingEnded:
        return Icons.call_end;
      case NotificationType.like:
        return Icons.thumb_up_alt_rounded;
      case NotificationType.match:
        return Icons.group;
    }
  }
}
