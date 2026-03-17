import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../manager/secure_storage_manager.dart';

class SecureStorageScreen extends StatefulWidget {
  const SecureStorageScreen({super.key});

  @override
  State<SecureStorageScreen> createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  final _manager = SecureStorageManager();
  final _stringController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _manager.dispose();
    _stringController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final stringValue = _stringController.text.trim();
    final numberText = _numberController.text.trim();

    if (stringValue.isNotEmpty) {
      await _manager.saveString(stringValue);
    }

    if (numberText.isNotEmpty) {
      final number = int.tryParse(numberText);
      if (number != null) {
        await _manager.saveNumber(number);
      }
    }

    _stringController.clear();
    _numberController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сохранено в Keychain / Keystore')),
      );
    }
  }

  Future<void> _showSavedData() async {
    final savedString = await _manager.getString();
    final savedNumber = await _manager.getNumber();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Secure Storage (Keychain / Keystore)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _DataRow(
              label: 'Строка',
              value: savedString ?? '—',
            ),
            const SizedBox(height: 8),
            _DataRow(
              label: 'Число',
              value: savedNumber?.toString() ?? '—',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAll() async {
    await _manager.deleteAll();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Все ключи удалены')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteAll,
            tooltip: 'Удалить все ключи',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Данные шифруются через Keychain (iOS) / Keystore (Android)',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stringController,
              decoration: const InputDecoration(
                labelText: 'Строка (например, токен)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: 'Число (например, PIN)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: const Text('Сохранить'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _showSavedData,
              child: const Text('Показать сохранённые данные'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
