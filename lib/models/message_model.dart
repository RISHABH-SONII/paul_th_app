import 'package:tharkyApp/models/user_model.dart';

class Meeting {
  String id;
  String? title;
  DateTime createdAt;
  DateTime startedAt;
  DateTime lastEnter;
  DateTime lastLeave;
  bool startedAsCall;
  String? caller;
  String? callType;
  String? callee;
  bool callToGroup;
  String? group;
  List<dynamic> peers;
  List<User> users;

  Meeting({
    required this.id,
    this.title,
    required this.createdAt,
    required this.startedAt,
    required this.lastEnter,
    required this.lastLeave,
    required this.startedAsCall,
    this.caller,
    this.callType,
    this.callee,
    required this.callToGroup,
    this.group,
    required this.peers,
    required this.users,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['_id'] ?? '',
      title: json['title'],
      callType: json['callType'],
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: DateTime.parse(json['startedAt']),
      lastEnter: DateTime.parse(json['lastEnter']),
      lastLeave: DateTime.parse(json['lastLeave']),
      startedAsCall: json['startedAsCall'] ?? false,
      caller: json['caller'] != null ? (json['caller']) : null,
      callee: json['callee'] != null ? (json['callee']) : null,
      callToGroup: json['callToGroup'] ?? false,
      group: json['group'] != null ? (json['group']) : null,
      peers: List<dynamic>.from(json['peers'] ?? []),
      users: (json['users'] as List?)
              ?.map((userJson) => User.fromJson(userJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt.toIso8601String(),
      'lastEnter': lastEnter.toIso8601String(),
      'lastLeave': lastLeave.toIso8601String(),
      'startedAsCall': startedAsCall,
      'caller': caller,
      'callee': callee,
      'callToGroup': callToGroup,
      'peers': peers,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Meeting{id: $id, title: $title, createdAt: $createdAt, startedAt: $startedAt, lastEnter: $lastEnter, lastLeave: $lastLeave, startedAsCall: $startedAsCall, callToGroup: $callToGroup, peers: $peers, users: ${users.length}}';
  }
}

class Room {
  String id;
  List<User> people;
  String? title;
  bool? isGroup;
  String? lastUpdate;
  String? lastAuthor;
  Message? lastMessage;
  List<Message> messages;
  List<String> images;

  Room({
    required this.id,
    required this.people,
    required this.title,
    required this.isGroup,
    required this.lastUpdate,
    required this.lastAuthor,
    required this.lastMessage,
    required this.messages,
    required this.images,
  });

  // Factory method to create a Room from JSON
  factory Room.fromJson(Map<String, dynamic> json) {
    var peopleFromJson = (json['people'] as List)
        .map((personJson) => User.fromJson(personJson))
        .toList();

    var messagesFromJson = ((json['messages'] ?? []) as List)
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();

    return Room(
      id: json['_id'],
      people: peopleFromJson,
      title: json['title'],
      isGroup: json['isGroup'],
      lastUpdate: json['lastUpdate'],
      lastAuthor: json['lastAuthor'],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      messages: messagesFromJson,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class Message {
  String? id;
  User? author;
  String? content;
  String? room;
  String? date;
  String? type;
  String? file;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  Message({
    this.id,
    this.author,
    required this.type,
    this.isRead,
    this.file,
    this.content,
    this.room,
    this.date,
    this.createdAt,
    this.updatedAt,
  });
  @override
  String toString() {
    return 'Message{id: $id,  content: $content, room: $room, type: $type, isRead: $isRead, file: $file, date: $date, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  // Factory method to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? '',
      author: User.fromJson(json['author']),
      content: json['content'],
      room: json['room'],
      type: json['type'],
      isRead: json['isRead'] ?? false,
      file: json['file'] ?? '',
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
