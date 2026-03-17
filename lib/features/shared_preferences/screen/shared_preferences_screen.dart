import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../manager/shared_preferences_manager.dart';

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  State<SharedPreferencesScreen> createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  final _manager = SharedPreferencesManager();
  final _stringController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _manager.init().then((_) => setState(() {}));
  }

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
        const SnackBar(content: Text('Сохранено')),
      );
    }
  }

  Future<void> _deleteAll() async {
    await _manager.deleteAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные удалены')),
      );
    }
  }

  void _showSavedData() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сохранённые данные',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _DataRow(
              label: 'Строка',
              value: _manager.getString() ?? '—',
            ),
            const SizedBox(height: 8),
            _DataRow(
              label: 'Число',
              value: _manager.getNumber()?.toString() ?? '—',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteAll,
            tooltip: 'Удалить данные',
          ),
        ],
      ),
      body: !_manager.isReady
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _stringController,
                    decoration: const InputDecoration(
                      labelText: 'Строка',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      labelText: 'Число',
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
