import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  final int gameId;

  const NotesListScreen({super.key, required this.gameId});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreentate();
}

class _NotesListScreentate extends ConsumerState<NotesListScreen> {
  Widget _buildNoteCard(Note note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'notes-detail',
            pathParameters: {
              'gameId': widget.gameId.toString(),
              'noteId': note.id.toString(),
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и дата
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormats.formatDateTime(note.updatedAt),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNote() async {
    final result = await context.pushNamed(
      'notes-add',
      pathParameters: {'gameId': widget.gameId.toString()},
    );

    if (result == true) {
      ref.invalidate(notesForGameDataProvider); // Обновляем провайдер
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteDao = ref.watch(noteDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createNote(),
            tooltip: 'Новая заметка',
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: noteDao.getAll(widget.gameId),
        builder: (context, snapshot) {
          // Показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingScreen();
          }

          // Обрабатываем ошибки
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          // Если данных нет
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return buildEmptyListScreen();
          }

          // Получаем данные
          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return _buildNoteCard(note);
            },
          );
        },
      ),
    );
  }
}
