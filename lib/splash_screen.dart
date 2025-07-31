import 'package:flutter/material.dart';
import 'package:med_document/page/dashboard/dashboard.dart';
import 'package:med_document/page/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Auth();
    });
    super.initState();
  }

  final supabase = Supabase.instance.client;
  Auth() async {
    final session = await supabase.auth.currentSession;
    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(child: Icon(Icons.document_scanner_outlined)),
      ),
    );
  }
}
