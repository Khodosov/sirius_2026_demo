import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../manager/sqflite_manager.dart';

class SqfliteScreen extends StatefulWidget {
  const SqfliteScreen({super.key});

  @override
  State<SqfliteScreen> createState() => _SqfliteScreenState();
}

class _SqfliteScreenState extends State<SqfliteScreen> {
  final _manager = SqfliteManager();
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

  Future<void> _insert() async {
    final stringValue = _stringController.text.trim();
    final numberText = _numberController.text.trim();

    if (stringValue.isEmpty || numberText.isEmpty) return;

    final number = int.tryParse(numberText);
    if (number == null) return;

    await _manager.insert(stringValue: stringValue, numberValue: number);

    _stringController.clear();
    _numberController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавлено')),
      );
    }
  }

  Future<void> _showQueryResult(
    String title,
    Future<List<Map<String, dynamic>>> query,
  ) async {
    final results = await query;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(
                '${results.length} записей',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? const Center(child: Text('Пусто'))
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final row = results[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              row.entries
                                  .map((e) => '${e.key}: ${e.value}')
                                  .join(', '),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontFamily: 'monospace'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showStats() async {
    final stats = await _manager.getSum();

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
              'SUM / COUNT',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Количество записей: ${stats?['count'] ?? 0}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 1),
            // const SizedBox(height: 8),
            Text(
              'Сумма чисел: ${stats?['total'] ?? 0}',
              style: Theme.of(context).textTheme.bodyLarge,
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
        const SnackBar(content: Text('Все записи удалены')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteAll,
            tooltip: 'Очистить таблицу',
          ),
        ],
      ),
      body: !_manager.isReady
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
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
                  onPressed: _insert,
                  child: const Text('INSERT'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Запросы',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _showQueryResult(
                    'SELECT * FROM entries',
                    _manager.getAll(),
                  ),
                  child: const Text('SELECT * (все данные)'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _showQueryResult(
                    'SELECT id, string_value FROM entries',
                    _manager.getStringsOnly(),
                  ),
                  child: const Text('SELECT только строки'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _showQueryResult(
                    'SELECT id, number_value FROM entries',
                    _manager.getNumbersOnly(),
                  ),
                  child: const Text('SELECT только числа'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _showQueryResult(
                    'SELECT * WHERE number_value > 10',
                    _manager.getWhereNumberGreaterThan(10),
                  ),
                  child: const Text('SELECT WHERE число > 10'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _showStats,
                  child: const Text('SUM / COUNT'),
                ),
              ],
            ),
    );
  }
}
