import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';

class ChatService {
  final SupabaseClient _supabase;

  ChatService(this._supabase);

  Future<List<Message>> getMessages(int matchId) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('match_id', matchId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => Message.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Message> sendMessage({
    required int matchId,
    required String body,
  }) async {
    final senderId = _supabase.auth.currentUser?.id;
    if (senderId == null) throw Exception('Not authenticated');

    final response = await _supabase
        .from('messages')
        .insert({
          'match_id': matchId,
          'sender_id': senderId,
          'body': body,
        })
        .select()
        .single();

    return Message.fromJson(response);
  }

  Stream<List<Message>> watchMessages(int matchId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId)
        .order('created_at', ascending: true)
        .map((data) => data
            .map((json) => Message.fromJson(json as Map<String, dynamic>))
            .toList());
  }

  Future<void> markAsRead(int messageId) async {
    await _supabase
        .from('messages')
        .update({'read_at': DateTime.now().toIso8601String()})
        .eq('id', messageId);
  }
}

