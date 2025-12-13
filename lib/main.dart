import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/unauthorized_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  // 取得目前登入使用者（如果有）
  final user = Supabase.instance.client.auth.currentUser;

  // debug 用
  print('supabaseUrl: $supabaseUrl');
  // 啟動 App，根據使用者是否登入決定初始頁面
  runApp(MyApp(initialUser: user));
}

class MyApp extends StatelessWidget {
  final User? initialUser;
  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase OAuth 範例',
      // 根據使用者登入狀態決定初始頁面
      initialRoute: initialUser != null ? '/checkAuth' : '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/checkAuth': (_) => const AuthCheckPage(), // 登入後檢查授權狀態
        '/home': (_) => const HomePage(),
        '/unauthorized': (_) => const UnauthorizedPage(),
      },
    );
  }
}

/// 用來檢查使用者是否有授權的 Widget
class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // 如果沒有登入，導回登入頁
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 查詢 profiles 表，檢查 allowed 欄位
    return FutureBuilder(
      future: Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          // 查不到資料或發生錯誤 → 導向非授權頁面
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/unauthorized');
          });
          return const SizedBox.shrink();
        } else {
          final response = snapshot.data as Map<String, dynamic>;
          if (response['allowed'] == true) {
            // 授權使用者 → 導向 home
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
          } else {
            // 非授權 → 導向 unauthorized
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/unauthorized');
            });
          }
          return const SizedBox.shrink();
        }
      },
    );
  }
}
