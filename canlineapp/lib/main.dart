// import './screen/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nukchdunwjzmktftgqvp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51a2NoZHVud2p6bWt0ZnRncXZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgwMzI1MTksImV4cCI6MjA0MzYwODUxOX0.0Yps_Ah424w6EnT8ZiYN2uysLCo7bMY7joTz__L6HYM',
  );

  runApp(const App());
}

final supabase = Supabase.instance.client;
