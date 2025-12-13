import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _updateLastLogin();
  }

  /// 讀取使用者的物品列表
  Future<void> _loadItems() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('items')
        .select()
        .eq('user_id', user.id)
        .order('expire_date', ascending: true);

    if (response != null) {
      setState(() {
        items = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    }
  }

  /// 更新登入時間
  Future<void> _updateLastLogin() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('profiles')
        .update({'last_login': DateTime.now().toIso8601String()})
        .eq('id', user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('家中物品庫存'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text('目前沒有物品'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final expireDate = item['expire_date'] != null
                    ? DateTime.parse(item['expire_date'])
                    : null;
                return ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text(
                    '分類: ${item['category'] ?? ''} 位置: ${item['location'] ?? ''}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('數量: ${item['quanitity'] ?? 0}'),
                      if (expireDate != null)
                        Text(
                          '到期: ${expireDate.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            color: expireDate.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 加入新增物品功能
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
