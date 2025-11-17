import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/profile_service.dart';
import '../../models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService(Supabase.instance.client);
  
  final _displayNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _interestController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedLookingFor;
  List<String> _interests = [];
  bool _isLoading = false;
  bool _isInitialLoading = true;
  Profile? _existingProfile;

  final List<String> _genderOptions = ['male', 'female', 'nonbinary'];
  final List<String> _lookingForOptions = ['male', 'female', 'everyone'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getCurrentProfile();
      if (profile != null) {
        setState(() {
          _existingProfile = profile;
          _displayNameController.text = profile.displayName;
          _ageController.text = profile.age?.toString() ?? '';
          _bioController.text = profile.bio ?? '';
          _selectedGender = profile.gender;
          _selectedLookingFor = profile.lookingFor;
          _interests = profile.interests ?? [];
        });
      }
    } finally {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  void _addInterest() {
    final interest = _interestController.text.trim();
    if (interest.isNotEmpty && !_interests.contains(interest)) {
      setState(() {
        _interests.add(interest);
        _interestController.clear();
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updates = {
        'display_name': _displayNameController.text.trim(),
        'age': int.tryParse(_ageController.text),
        'bio': _bioController.text.trim(),
        'gender': _selectedGender,
        'looking_for': _selectedLookingFor,
        'interests': _interests,
      };

      if (_existingProfile == null) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId == null) throw Exception('Not authenticated');

        final profile = Profile(
          id: userId,
          displayName: _displayNameController.text.trim(),
          age: int.tryParse(_ageController.text),
          bio: _bioController.text.trim(),
          gender: _selectedGender,
          lookingFor: _selectedLookingFor,
          interests: _interests,
          createdAt: DateTime.now(),
        );
        await _profileService.createProfile(profile);
      } else {
        await _profileService.updateProfile(updates);
      }

      if (mounted) {
        context.go('/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_existingProfile == null ? 'Create Profile' : 'Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final age = int.tryParse(value);
                    if (age == null || age < 18) {
                      return 'Must be 18 or older';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: _genderOptions.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender[0].toUpperCase() + gender.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLookingFor,
                decoration: const InputDecoration(
                  labelText: 'Looking For',
                  prefixIcon: Icon(Icons.favorite),
                ),
                items: _lookingForOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option[0].toUpperCase() + option.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLookingFor = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Interests',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _interestController,
                      decoration: const InputDecoration(
                        hintText: 'Add an interest',
                      ),
                      onFieldSubmitted: (_) => _addInterest(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addInterest,
                  ),
                ],
              ),
              if (_interests.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interests.map((interest) {
                    return Chip(
                      label: Text(interest),
                      onDeleted: () => _removeInterest(interest),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

