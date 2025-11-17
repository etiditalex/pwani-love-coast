class Message {
  final int id;
  final int matchId;
  final String senderId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.body,
    this.readAt,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      matchId: json['match_id'] as int,
      senderId: json['sender_id'] as String,
      body: json['body'] as String,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'sender_id': senderId,
      'body': body,
    };
  }
}

