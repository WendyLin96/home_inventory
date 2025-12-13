import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      print('user: $user');
      print('userid: $user.id');
      // 檢查 profiles 表中的 allowed 欄位
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (response != null && response['allowed'] == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/unauthorized');
      }
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
