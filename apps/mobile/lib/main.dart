import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with provided project credentials
  await Supabase.initialize(
    url: 'https://rtmxrgbqdfeucqfsgepx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0bXhyZ2JxZGZldWNxZnNnZXB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjM1MjMsImV4cCI6MjA3ODkzOTUyM30.jNCwkVrP9NYCOHA60HbWzWb7xpeN4a1cnZkr5-IIwsI',
  );

  runApp(
    const ProviderScope(
      child: PwaniLoveApp(),
    ),
  );
}

class PwaniLoveApp extends StatelessWidget {
  const PwaniLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pwani Love',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

