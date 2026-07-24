import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fleather/fleather.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final int gameId;
  final int noteId;

  const NoteDetailScreen({
    super.key,
    required this.gameId,
    required this.noteId,
  });

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  late FleatherController _controller;
  late Note? note;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final noteDao = ref.read(noteDaoProvider);
    note = await noteDao.getSingle(widget.noteId);

    // Инициализация контроллера для просмотра
    try {
      final jsonMap = jsonDecode(note!.content!);
      final document = ParchmentDocument.fromJson(jsonMap);
      _controller = FleatherController(document: document);
    } catch (e) {
      _controller = FleatherController();
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openUpdateForm() async {
    final result = await context.pushNamed(
      'notes-update',
      pathParameters: {
        'gameId': widget.gameId.toString(),
        'noteId': widget.noteId.toString(),
      },
    );

    if (result == true && mounted) {
      _loadData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(appName)),
        body: LoadingScreen(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note!.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _openUpdateForm(),
            tooltip: 'Редактировать',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              buildDelModal(context, ref, noteDaoProvider, mounted, note);
            },
            tooltip: 'Удалить',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // Информация о создании и обновлении
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    InfoRow(
                      label: 'Создана',
                      value: DateFormats.formatDateTime(note!.createdAt),
                      isFirst: true,
                    ),

                    InfoRow(
                      label: 'Обновлена',
                      value: DateFormats.formatDateTime(note!.updatedAt),
                    ),
                  ],
                ),
              ),
            ),
            // Содержимое заметки
            const Text(
              'Содержание',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FleatherEditor(
                  controller: _controller,
                  readOnly: true,
                  focusNode: FocusNode(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
