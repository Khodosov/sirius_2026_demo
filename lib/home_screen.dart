import 'package:flutter/material.dart';

import 'features/local_storage/screen/local_storage_screen.dart';
import 'features/shared_preferences/screen/shared_preferences_screen.dart';
import 'features/hive/screen/hive_screen.dart';
import 'features/isar/screen/isar_screen.dart';
import 'features/sqflite/screen/sqflite_screen.dart';
import 'features/secure_storage/screen/secure_storage_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Persistence Demo'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _DemoTile(
              icon: Icons.folder_outlined,
              title: 'Local Storage',
              subtitle:
                  'getApplicationDocumentsDirectory vs getTemporaryDirectory',
              destination: LocalStorageScreen(),
            ),
            _DemoTile(
              icon: Icons.settings_outlined,
              title: 'Shared Preferences',
              subtitle: 'Key-value хранилище для простых данных',
              destination: SharedPreferencesScreen(),
            ),
            _DemoTile(
              icon: Icons.inventory_2_outlined,
              title: 'Hive',
              subtitle: 'Быстрая NoSQL база данных',
              destination: HiveScreen(),
            ),
            _DemoTile(
              icon: Icons.storage_outlined,
              title: 'Isar',
              subtitle: 'NoSQL база данных с поддержкой запросов',
              destination: IsarScreen(),
            ),
            _DemoTile(
              icon: Icons.table_chart_outlined,
              title: 'sqflite',
              subtitle: 'SQLite для Flutter',
              destination: SqfliteScreen(),
            ),
            _DemoTile(
              icon: Icons.lock_outlined,
              title: 'Secure Storage',
              subtitle: 'Безопасное хранение (Keychain / Keystore)',
              destination: SecureStorageScreen(),
            ),
          ],
        ),
      );
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.destination,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => destination),
        ),
      ),
    );
  }
}
