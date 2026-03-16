import 'package:flutter/material.dart';

import '../manager/local_storage_manager.dart';

class LocalStorageScreen extends StatefulWidget {
  const LocalStorageScreen({super.key});

  @override
  State<LocalStorageScreen> createState() => _LocalStorageScreenState();
}

class _LocalStorageScreenState extends State<LocalStorageScreen> {
  final _manager = LocalStorageManager();
  final _controller = TextEditingController();

  String _docsPath = '';
  String _tempPath = '';

  @override
  void initState() {
    super.initState();
    _loadPaths();
  }

  Future<void> _loadPaths() async {
    final docs = await _manager.getDocumentsFilePath();
    final temp = await _manager.getTempFilePath();
    setState(() {
      _docsPath = docs;
      _tempPath = temp;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveToDocuments() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await _manager.saveToDocuments(text);
    _controller.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сохранено в Documents')),
      );
    }
  }

  Future<void> _saveToTemp() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await _manager.saveToTemp(text);
    _controller.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сохранено в Temp')),
      );
    }
  }

  Future<void> _showSavedData() async {
    final docsContent = await _manager.readFromDocuments();
    final tempContent = await _manager.readFromTemp();
    final docsPath = await _manager.getDocumentsFilePath();
    final tempPath = await _manager.getTempFilePath();

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
              'Сохранённые данные',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _DataRow(
              label: 'Documents',
              value: docsContent ?? '—',
            ),
            SelectableText(
              docsPath,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 12),
            _DataRow(
              label: 'Temp',
              value: tempContent ?? '—',
            ),
            SelectableText(
              tempPath,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.outline,
                  ),
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
        title: const Text('Local Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PathCard(label: 'Documents', path: _docsPath),
            const SizedBox(height: 8),
            _PathCard(label: 'Temp', path: _tempPath),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Текст для сохранения',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saveToDocuments,
              child: const Text('Сохранить в Documents'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _saveToTemp,
              child: const Text('Сохранить в Temp'),
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

class _PathCard extends StatelessWidget {
  const _PathCard({required this.label, required this.path});

  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              path.isEmpty ? '...' : path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
