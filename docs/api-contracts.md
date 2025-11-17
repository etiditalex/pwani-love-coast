# API Contracts

## Supabase Client API

All API interactions go through the Supabase client. This document outlines the expected contracts.

## Authentication

### Sign Up
```dart
// Flutter
AuthResponse signUp({
  required String email,
  required String password,
})
```

### Sign In
```dart
// Flutter
AuthResponse signIn({
  required String email,
  required String password,
})
```

### Sign Out
```dart
// Flutter
Future<void> signOut()
```

## Profiles

### Get Current Profile
```dart
// Flutter
Future<Profile?> getCurrentProfile()
```

**Response:**
```json
{
  "id": "uuid",
  "display_name": "string",
  "age": 25,
  "gender": "male|female|nonbinary",
  "looking_for": "male|female|everyone",
  "bio": "string",
  "interests": ["string"],
  "avatar_url": "string",
  "photos": ["string"],
  "latitude": 0.0,
  "longitude": 0.0,
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Create Profile
```dart
// Flutter
Future<void> createProfile(Profile profile)
```

### Update Profile
```dart
// Flutter
Future<void> updateProfile(Map<String, dynamic> updates)
```

### Get Discoverable Profiles
```dart
// Flutter
Future<List<Profile>> getDiscoverableProfiles({int limit = 20})
```

**Filters Applied:**
- Excludes current user
- Filters by `looking_for` preference
- Excludes already liked users
- Ordered by `created_at` DESC

## Matching

### Like User
```dart
// Flutter
Future<void> likeUser(String toUserId)
```

**Side Effects:**
- Creates entry in `likes` table
- If mutual like exists, creates match automatically

### Pass User
```dart
// Flutter
Future<void> passUser(String toUserId)
```

**Note:** Currently a no-op. Could be extended to track passes.

### Get Matches
```dart
// Flutter
Future<List<Match>> getMatches()
```

**Response:**
```json
[
  {
    "id": 1,
    "user_a": "uuid",
    "user_b": "uuid",
    "created_at": "timestamp",
    "last_activity_at": "timestamp"
  }
]
```

### Watch Matches (Realtime)
```dart
// Flutter
Stream<List<Match>> watchMatches()
```

## Messaging

### Get Messages
```dart
// Flutter
Future<List<Message>> getMessages(int matchId)
```

**Response:**
```json
[
  {
    "id": 1,
    "match_id": 1,
    "sender_id": "uuid",
    "body": "string",
    "read_at": "timestamp|null",
    "created_at": "timestamp"
  }
]
```

### Send Message
```dart
// Flutter
Future<Message> sendMessage({
  required int matchId,
  required String body,
})
```

**Side Effects:**
- Updates match `last_activity_at` timestamp

### Watch Messages (Realtime)
```dart
// Flutter
Stream<List<Message>> watchMessages(int matchId)
```

## Storage

### Upload Avatar
```dart
// Flutter
Future<String?> uploadAvatar(String filePath)
```

**Returns:** Public URL of uploaded avatar

### Upload Photo
```dart
// Flutter
Future<String?> uploadPhoto(String filePath)
```

**Returns:** Public URL of uploaded photo

## Error Handling

All methods throw exceptions on error. Common errors:

- `Exception('Not authenticated')` - User not logged in
- `Exception('Profile not found')` - Profile doesn't exist
- `Exception('Invalid match')` - Match doesn't exist or user not part of it

## Rate Limiting

Supabase has built-in rate limiting. Consider implementing:

- Like rate limiting (e.g., max 100 likes per day)
- Message rate limiting (e.g., max 50 messages per minute)
- Profile update rate limiting

## Future API Extensions

### Matching Algorithm API
```
POST /api/matching/recommendations
Body: { user_id, preferences, location }
Response: { recommendations: [Profile] }
```

### Analytics API
```
GET /api/analytics/user-stats
Response: { total_likes, total_matches, response_rate }
```

