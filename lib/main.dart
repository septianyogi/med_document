import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:med_document/page/dashboard/dashboard.dart';
import 'package:med_document/page/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseAnonKey = dotenv.env['SUPABASE_API_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Document',
      debugShowCheckedModeBanner: false,

      // ✅ Konfigurasi lokal
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id'), // Bahasa Indonesia
        Locale('en'), // Bahasa Inggris (opsional)
      ],
      locale: const Locale('id'), // Set default ke Indonesia

      home: const DashboardPage(),
    );
  }
}
