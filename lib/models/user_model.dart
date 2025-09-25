class User {
  final int? id;
  final String? iid;
  final String? name;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? level;
  final DateTime? lastOnline;
  final String? totalScore;
  final bool? isDocumentVerified;

  final bool? isBlocked;
  String? address;
  final Map? coordinates;
  final List<String>? interests;
  final String? gender;
  final String? showGender;
  final bool? showAge;
  final bool? showInterests;
  final DateTime? dob;
  final String? phoneNumber;
  int? maxDistance;
  int? lastmsg;
  Map? meta = {};
  final Map? ageRange;
  final String? about;
  List<String>? imageUrl = [];
  List<String>? images = [];
  List<String>? privates = [];
  List<String>? favorites = [];
  int? distanceBW;

  User({
    this.iid,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.name,
    this.address,
    this.dob,
    this.isBlocked,
    this.coordinates,
    this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.showGender,
    this.showAge,
    this.showInterests,
    this.ageRange,
    this.maxDistance,
    this.about,
    this.interests,
    this.level,
    this.favorites,
    this.images,
    this.privates,
    this.lastOnline,
    this.meta,
    this.totalScore,
    this.isDocumentVerified,
  });
  @override
  String toString() {
    return ''' User: { id: $id, name: $name, email: $email, firstName: $firstName, lastName: $lastName, level: $level, lastOnline: ${lastOnline?.toIso8601String()}, isBlocked: $isBlocked, address: $address, coordinates: ${coordinates != null ? coordinates.toString() : 'null'}, interests: ${interests?.join(', ') ?? 'null'}, gender: $gender, showGender: $showGender, showAge: $showAge, showInterests: $showInterests, dob: ${dob?.toIso8601String()}, phoneNumber: $phoneNumber, maxDistance: $maxDistance, lastmsg: $lastmsg, ageRange: ${ageRange != null ? ageRange.toString() : 'null'}, about: $about, imageUrl: ${imageUrl?.join(', ') ?? 'null'}, images: ${images?.join(', ') ?? 'null'}, favorites: ${favorites?.join(', ') ?? 'null'}, distanceBW: $distanceBW, meta: ${meta != null ? meta.toString() : 'null'},totalScore: $totalScore, isDocumentVerified: $isDocumentVerified } ''';
  }

  factory User.fromJson(Map<String, dynamic> doc) {
    return User(
      iid: doc['_id'] ?? '',
      id: doc['ID'] ?? 0,
      email: doc['email'] ?? '',
      firstName: doc['firstName'] ?? '',
      lastName: doc['lastName'] ?? '',
      level: doc['level'] ?? 'standard', // Default level
      favorites:
          doc['favorites'] != null ? List<String>.from(doc['favorites']) : [],
      images: doc['images'] != null ? List<String>.from(doc['images']) : [],
      privates:
          doc['privates'] != null ? List<String>.from(doc['privates']) : [],
      lastOnline: doc['lastOnline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc['lastOnline'])
          : null, // Convert timestamp to DateTime
      isBlocked: doc['isBlocked'] ?? false,
      phoneNumber: doc['phone'] ?? '',
      name: doc['username'] ?? '',
      about: doc['about'] ?? "",
      ageRange: doc['ageRange'] ?? {},
      meta: doc['meta'] ?? {},
      showInterests: doc['showInterests'] ?? false,
      showGender: doc['showGender'] ?? "woman",
      gender: doc['gender'] ?? "woman",
      showAge: doc['showAge'] ?? false,
      maxDistance: doc['maxDistance'] ?? 0,
      interests:
          doc['interests'] != null ? List<String>.from(doc['interests']) : [],
      dob: doc['user_DOB'] != null ? DateTime.parse(doc['user_DOB']) : null,
      address: doc['location']?['address'] ?? '',
      coordinates: doc['coordinates'] ?? {},
      imageUrl:
          doc['imageUrl'] != null ? List<String>.from(doc['imageUrl']) : [],
      totalScore: doc['totalScore'] ?? '0.0',
      isDocumentVerified: doc['isDocumentVerified'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['ID'] = id;
    if (email != null) data['email'] = email;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (name != null) data['username'] = name;
    if (name != null)
      data['fullName'] = '${firstName ?? ""} ${lastName ?? ""}'.trim();
    if (phoneNumber != null) data['phone'] = phoneNumber;
    if (isBlocked != null) data['isBlocked'] = isBlocked;
    if (lastOnline != null) {
      data['lastOnline'] = lastOnline!.millisecondsSinceEpoch;
    }
    if (dob != null) data['user_DOB'] = dob!.toIso8601String();
    if (favorites != null) data['favorites'] = favorites;
    if (images != null) data['images'] = images;
    if (privates != null) data['privates'] = privates;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (interests != null) data['interests'] = interests;
    if (address != null) data['address'] = address;
    if (coordinates != null) data['coordinates'] = coordinates;
    if (gender != null) data['gender'] = gender;
    if (showGender != null) data['showGender'] = showGender;
    if (meta != null) data['meta'] = meta;
    if (showAge != null) data['showAge'] = showAge;
    if (showInterests != null) data['showInterests'] = showInterests;
    if (ageRange != null) data['ageRange'] = ageRange;
    if (maxDistance != null) data['maxDistance'] = maxDistance;
    if (distanceBW != null) data['distanceBW'] = distanceBW;
    if (about != null) data['about'] = about;
    if (totalScore != null) data['totalScore'] = totalScore;
    if (isDocumentVerified != null) data['isDocumentVerified'] = isDocumentVerified;

    return data;
  }
}
