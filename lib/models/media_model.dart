class ImageModel {
  final String? shield;
  final String? name;
  final String? description;
  final String? title;
  final List<String>? tags;
  final String? location;
  final String? author;
  final String? id;
  final int? size;
  final String? shieldedId;
  final List<String>? likedBy;
  final List<String>? superlikes;
  final List<String>? dislikedBy;
  final Map<String, double>? ratings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Constructor
  ImageModel({
    this.shield,
    this.name,
    this.description,
    this.title,
    this.tags,
    this.location,
    this.author,
    this.id,
    this.size,
    this.shieldedId,
    this.likedBy,
    this.superlikes,
    this.dislikedBy,
    this.ratings,
    this.createdAt,
    this.updatedAt,
  });

  // Convert the Mongoose model into the Dart model from a JSON object
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      shield: json['shield'],
      name: json['name'],
      description: json['description'],
      title: json['title'],
      tags: List<String>.from(json['tags'] ?? []),
      location: json['location'],
      author: json['author'], // This could be a User object, or User ID
      id: json['_id'],
      size: json['size'],
      shieldedId: json['shieldedID'],
      likedBy: List<String>.from(json['likedBy'] ?? []),
      superlikes: List<String>.from(json['superlikes'] ?? []),
      dislikedBy: List<String>.from(json['dislikedBy'] ?? []),
      ratings: json['ratings'] != null
          ? Map<String, double>.from(json['ratings'] ?? {})
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert the Dart model into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'shield': shield,
      'name': name,
      'description': description,
      'title': title,
      'tags': tags,
      'location': location,
      'author': author,
      'ID': id,
      'size': size,
      'shieldedID': shieldedId,
      'likedBy': likedBy,
      'superlikes': superlikes,
      'dislikedBy': dislikedBy,
      'ratings': ratings,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class VideoModel {
  final String? shield;
  final String? name;
  final String? title;
  final String? description;
  final List<String>? tags;
  final int? id;
  final String? location;
  final String? author; // Reference to User (could be User ID or User object)
  final int? size;
  final String? shieldedId;
  final List<String>? likedBy; // List of User IDs
  final List<String>? superlikes; // List of User IDs
  final List<String>? dislikedBy; // List of User IDs
  final Map<String, double>?
      ratings; // Map with String keys (user IDs) and double values (ratings)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Constructor
  VideoModel({
    this.shield,
    this.name,
    this.title,
    this.description,
    this.tags,
    this.id,
    this.location,
    this.author,
    this.size,
    this.shieldedId,
    this.likedBy,
    this.superlikes,
    this.dislikedBy,
    this.ratings,
    this.createdAt,
    this.updatedAt,
  });

  // Convert the Mongoose model into the Dart model from a JSON object
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      shield: json['shield'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      tags: List<String>.from(json['tags'] ?? []),
      location: json['location'],
      author: json['author'], // This could be a User object, or User ID
      id: json['ID'],
      size: json['size'],
      shieldedId: json['shieldedID'],
      likedBy: List<String>.from(json['likedBy'] ?? []),
      superlikes: List<String>.from(json['superlikes'] ?? []),
      dislikedBy: List<String>.from(json['dislikedBy'] ?? []),
      ratings: json['ratings'] != null
          ? Map<String, double>.from(json['ratings'] ?? {})
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert the Dart model into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'shield': shield,
      'name': name,
      'title': title,
      'description': description,
      'tags': tags,
      'location': location,
      'author': author,
      'ID': id,
      'size': size,
      'shieldedID': shieldedId,
      'likedBy': likedBy,
      'superlikes': superlikes,
      'dislikedBy': dislikedBy,
      'ratings': ratings,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
