import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Google OAuth 登入
  void _loginWithGoogle(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo:
            'https://home-inventory-eight.vercel.app', // 這裡用你的 Vercel 網址
      );
    } catch (e, st) {
      print('OAuth Error: $e');
      print('StackTrace: $st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登入')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _loginWithGoogle(context),
          child: const Text('使用 Google 登入'),
        ),
      ),
    );
  }
}
