class Match {
  final int id;
  final String userA;
  final String userB;
  final DateTime createdAt;
  final DateTime lastActivityAt;

  Match({
    required this.id,
    required this.userA,
    required this.userB,
    required this.createdAt,
    required this.lastActivityAt,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as int,
      userA: json['user_a'] as String,
      userB: json['user_b'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivityAt: DateTime.parse(json['last_activity_at'] as String),
    );
  }

  String getOtherUserId(String currentUserId) {
    return userA == currentUserId ? userB : userA;
  }
}

