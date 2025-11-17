import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';

class ProfileService {
  final SupabaseClient _supabase;

  ProfileService(this._supabase);

  Future<Profile?> getCurrentProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return Profile.fromJson(response);
  }

  Future<void> createProfile(Profile profile) async {
    await _supabase.from('profiles').insert(profile.toJson());
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId);
  }

  Future<List<Profile>> getDiscoverableProfiles({int limit = 20}) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .neq('id', _supabase.auth.currentUser!.id)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => Profile.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<String?> uploadAvatar(String filePath) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final file = File(filePath);
    final fileName = 'avatars/$userId/${DateTime.now().millisecondsSinceEpoch}';
    await _supabase.storage.from('avatars').upload(fileName, file);

    return _supabase.storage.from('avatars').getPublicUrl(fileName);
  }

  Future<String?> uploadPhoto(String filePath) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final file = File(filePath);
    final fileName = 'photos/$userId/${DateTime.now().millisecondsSinceEpoch}';
    await _supabase.storage.from('photos').upload(fileName, file);

    return _supabase.storage.from('photos').getPublicUrl(fileName);
  }
}

