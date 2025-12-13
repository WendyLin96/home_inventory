import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _loginWithGoogle() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'https://home-inventory-one.vercel.app', // 這裡用你的 Vercel 網址
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登入測試')),
      body: Center(
        child: ElevatedButton(
          onPressed: _loginWithGoogle,
          child: const Text('使用 Google 登入'),
        ),
      ),
    );
  }
}
