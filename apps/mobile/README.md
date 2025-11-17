# Pwani Love Mobile App

Flutter mobile application for iOS and Android.

## Setup

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure Supabase:**
   - Update `lib/main.dart` with your Supabase URL and anon key
   - Or use environment variables with `flutter_dotenv`

3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
├── services/             # Supabase service layer
├── screens/              # UI screens
│   ├── auth/            # Login, signup
│   ├── discovery/       # Swipe cards
│   ├── matches/         # Matches list
│   ├── chat/            # Chat screen
│   └── profile/          # Profile management
├── widgets/              # Reusable widgets
├── providers/            # Riverpod providers
├── router/               # Navigation (go_router)
└── theme/                # App theme & colors
```

## Features

- ✅ User authentication (sign up, sign in)
- ✅ Profile creation and editing
- ✅ Discovery/swipe interface
- ✅ Matching system
- ✅ Real-time messaging
- ✅ Image uploads

## Building

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Environment Variables

Create a `.env` file (or update `main.dart` directly):

```env
SUPABASE_URL=your_url
SUPABASE_ANON_KEY=your_key
```

