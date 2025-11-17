import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/match.dart';
import '../models/profile.dart';

class MatchService {
  final SupabaseClient _supabase;

  MatchService(this._supabase);

  Future<void> likeUser(String toUserId) async {
    final fromUserId = _supabase.auth.currentUser?.id;
    if (fromUserId == null) throw Exception('Not authenticated');

    await _supabase.from('likes').insert({
      'from_user': fromUserId,
      'to_user': toUserId,
    });
  }

  Future<void> passUser(String toUserId) async {
    // Passing is just not liking - no action needed
    // Could add a "passes" table if you want to track this
  }

  Future<List<Match>> getMatches() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _supabase
        .from('matches')
        .select()
        .or('user_a.eq.$userId,user_b.eq.$userId')
        .order('last_activity_at', ascending: false);

    return (response as List)
        .map((json) => Match.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Profile?> getMatchProfile(String matchUserId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', matchUserId)
        .single();

    return Profile.fromJson(response);
  }

  Stream<List<Match>> watchMatches() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.value([]);
    }

    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('user_a', userId)
        .or('user_b.eq.$userId')
        .order('last_activity_at', ascending: false)
        .map((data) => data
            .map((json) => Match.fromJson(json as Map<String, dynamic>))
            .toList());
  }
}

