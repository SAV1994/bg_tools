import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  final int gameId;

  const NotesListScreen({super.key, required this.gameId});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreentate();
}

class _NotesListScreentate extends ConsumerState<NotesListScreen> {
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesPaginatedProvider);
    final notifier = ref.read(notesPaginatedProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        notifier.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isSearchOpen
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Поиск игроков...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textColor),
                      contentPadding: const EdgeInsets.symmetric(),
                    ),
                    style: const TextStyle(color: textColor),
                    onChanged: (value) => notifier.search(value),
                  )
                : const Icon(notesIcon),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : textColor,
              ),
              onPressed: () {
                setState(() {
                  if (_isSearchOpen) {
                    _searchController.clear();
                    notifier.search('');
                  }
                  _isSearchOpen = !_isSearchOpen;
                });
              },
            ),
            if (!_isSearchOpen) ...[
              IconButton(
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),
              IconButton(
                icon: const Icon(addBtnIcon),
                onPressed: () => context.pushNamed(
                  'notes-add',
                  pathParameters: {'gameId': widget.gameId.toString()},
                ),
                tooltip: 'Новая заметка',
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            // Список
            Expanded(
              child: notesAsync.when(
                data: (notes) {
                  // Если данных нет
                  if (notes.isEmpty) {
                    return EmptyListScreen();
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return _buildNoteCard(note);
                      },
                    ),
                  );
                },
                loading: () => LoadingScreen(),
                error: (err, _) => ErrorNotification(),
              ),
            ),
            // Панель пагинации (всегда внизу)
            if (notesAsync.hasValue && notesAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
