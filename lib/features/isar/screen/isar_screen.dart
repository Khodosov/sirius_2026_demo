import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../manager/isar_manager.dart';

class IsarScreen extends StatefulWidget {
  const IsarScreen({super.key});

  @override
  State<IsarScreen> createState() => _IsarScreenState();
}

class _IsarScreenState extends State<IsarScreen> {
  final _manager = IsarManager();
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

    if (stringValue.isEmpty || numberText.isEmpty) return;

    final number = int.tryParse(numberText);
    if (number == null) return;

    await _manager.save(stringValue: stringValue, numberValue: number);

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
    final entry = _manager.getEntry();

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сохранённые данные (Isar)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _DataRow(
              label: 'Строка',
              value: entry?.stringValue ?? '—',
            ),
            const SizedBox(height: 8),
            _DataRow(
              label: 'Число',
              value: entry?.numberValue.toString() ?? '—',
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
        title: const Text('Isar'),
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
