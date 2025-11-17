class Profile {
  final String id;
  final String displayName;
  final int? age;
  final String? gender;
  final String? lookingFor;
  final String? bio;
  final List<String>? interests;
  final String? avatarUrl;
  final List<String>? photos;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.displayName,
    this.age,
    this.gender,
    this.lookingFor,
    this.bio,
    this.interests,
    this.avatarUrl,
    this.photos,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      lookingFor: json['looking_for'] as String?,
      bio: json['bio'] as String?,
      interests: json['interests'] != null
          ? List<String>.from(json['interests'] as List)
          : null,
      avatarUrl: json['avatar_url'] as String?,
      photos: json['photos'] != null
          ? List<String>.from(json['photos'] as List)
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'age': age,
      'gender': gender,
      'looking_for': lookingFor,
      'bio': bio,
      'interests': interests,
      'avatar_url': avatarUrl,
      'photos': photos,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

