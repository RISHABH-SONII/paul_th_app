import 'package:tharkyApp/models/user_model.dart';

class Room {
  final String? id;
  final List<User>? people;
  final String? title;
  final String? pictureId;
  final bool? isGroup;
  final DateTime? lastUpdate;
  final String? lastAuthorId;
  final String? lastMessageId;

  Room({
    this.id,
    this.people,
    this.title,
    this.pictureId,
    this.isGroup,
    this.lastUpdate,
    this.lastAuthorId,
    this.lastMessageId,
  });

  // Factory method for converting JSON into a Room instance
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'] ?? '',
      people: json['people'] != null
          ? List<User>.from(
              json['people'].map((person) => User.fromJson(person)))
          : [],
      title: json['title'] ?? '',
      pictureId: json['picture'] ?? '',
      isGroup: json['isGroup'] ?? false,
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.parse(json['lastUpdate'])
          : null,
      lastAuthorId: json['lastAuthor'] ?? '',
      lastMessageId: json['lastMessage'] ?? '',
    );
  }

  // Method to convert Room instance into JSON format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (people != null) data['people'] = people;
    if (title != null) data['title'] = title;
    if (pictureId != null) data['picture'] = pictureId;
    if (isGroup != null) data['isGroup'] = isGroup;
    if (lastUpdate != null) data['lastUpdate'] = lastUpdate?.toIso8601String();
    if (lastAuthorId != null) data['lastAuthor'] = lastAuthorId;
    if (lastMessageId != null) data['lastMessage'] = lastMessageId;

    return data;
  }

  @override
  String toString() {
    return '''Room: {
      id: $id,
      people: $people,
      title: $title,
      pictureId: $pictureId,
      isGroup: $isGroup,
      lastUpdate: ${lastUpdate?.toIso8601String()},
      lastAuthorId: $lastAuthorId,
      lastMessageId: $lastMessageId
    }''';
  }
}

class Message {
  final String? senderId;
  final String? receiverId;
  final String? text;
  final String? imageUrl;
  final DateTime? time;
  final bool? isRead;
  final String? type; // 'Text' ou 'Call'
  final String? callType; // 'Audio' ou 'Video' pour les appels
  final Map? metadata; // Metadata supplémentaires, comme l'état de l'appel
  final String? messageId;

  Message({
    this.senderId,
    this.receiverId,
    this.text,
    this.imageUrl,
    this.time,
    this.isRead,
    this.type,
    this.callType,
    this.metadata,
    this.messageId,
  });

  @override
  String toString() {
    return ''' Message: { 
      senderId: $senderId, 
      receiverId: $receiverId, 
      text: $text, 
      imageUrl: $imageUrl, 
      time: ${time?.toIso8601String()}, 
      isRead: $isRead, 
      type: $type, 
      callType: $callType, 
      messageId: $messageId, 
      metadata: ${metadata != null ? metadata.toString() : 'null'} 
    }''';
  }

  factory Message.fromJson(Map<String, dynamic> doc) {
    return Message(
      senderId: doc['sender_id'] ?? '',
      receiverId: doc['receiver_id'] ?? '',
      text: doc['text'] ?? '',
      imageUrl: doc['image_url'] ?? '',
      // time: doc['time'] != null ? (doc['time'] as int).toDate() : null,
      isRead: doc['isRead'] ?? false,
      type: doc['type'] ?? 'Text', // Default to 'Text' if not provided
      callType: doc['callType'] ?? '', // Optional, only set for calls
      metadata: doc['metadata'] ?? {},
      messageId: doc['message_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (senderId != null) data['sender_id'] = senderId;
    if (receiverId != null) data['receiver_id'] = receiverId;
    if (text != null) data['text'] = text;
    if (imageUrl != null) data['image_url'] = imageUrl;
    // if (time != null) data['time'] = Timestamp.fromDate(time!);
    if (isRead != null) data['isRead'] = isRead;
    if (type != null) data['type'] = type;
    if (callType != null) data['callType'] = callType;
    if (messageId != null) data['message_id'] = messageId;
    if (metadata != null) data['metadata'] = metadata;

    return data;
  }
}
