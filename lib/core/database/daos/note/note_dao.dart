import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/note.dart';

part 'note_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NoteDao extends DatabaseAccessor<AppDatabase> with _$NoteDaoMixin {
  NoteDao(super.db);

  // Создать заметку
  Future<int> create({
    required int gameId,
    required String title,
    required String? content,
  }) async {
    return await into(notes).insert(
      NotesCompanion(
        gameId: Value(gameId),
        title: Value(title),
        content: Value(content),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Обновить заметку
  Future<bool> updInstance({
    required int noteId,
    required String title,
    required String? content,
  }) async {
    final result = await (update(notes)..where((n) => n.id.equals(noteId)))
        .write(
          NotesCompanion(
            title: Value(title),
            content: Value(content),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return result > 0;
  }

  // Удалить заметку
  Future<void> delInstance(int noteId) async {
    await (delete(notes)..where((gn) => gn.id.equals(noteId))).go();
  }

  // Заметки с пагинацией
  Future<List<Note>> getPaginated({
    required int page,
    required int pageSize,
    required bool reverseOrdering,
    required int gameId,
    String? searchQuery,
  }) async {
    final offset = page * pageSize;

    SimpleSelectStatement<$NotesTable, Note> query = _getBaseQuery(
      gameId: gameId,
      reverse: reverseOrdering,
    )..limit(pageSize, offset: offset);
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get();
  }

  // Общее количество заметок, соответствующих условию
  Future<int> getTotalCount({required int gameId, String? searchQuery}) async {
    SimpleSelectStatement<$NotesTable, Note> query = _getBaseQuery(
      gameId: gameId,
    );
    query = _getFilteredQuery(query: query, searchQuery: searchQuery);

    return await query.get().then((list) => list.length);
  }

  // Заметка
  Future<Note?> getSingle(int noteId) async {
    return await (select(
      notes,
    )..where((n) => n.id.equals(noteId))).getSingleOrNull();
  }

  SimpleSelectStatement<$NotesTable, Note> _getBaseQuery({
    required int gameId,
    bool reverse = false,
  }) {
    return select(notes)
      ..where((n) => n.gameId.equals(gameId))
      ..orderBy([
        (n) => OrderingTerm(
          expression: n.title.collate(const Collate('UNICODE_CI')),
          mode: reverse ? OrderingMode.desc : OrderingMode.asc,
        ),
      ]);
  }

  SimpleSelectStatement<$NotesTable, Note> _getFilteredQuery({
    required SimpleSelectStatement<$NotesTable, Note> query,
    String? searchQuery,
  }) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
        ..where((n) {
          final lowerNameExpression = CustomExpression<String>(
            'lower_unicode(title)',
            watchedTables: [notes],
          );
          final searchQueryLower = searchQuery.toLowerCase();

          return lowerNameExpression.like('%$searchQueryLower%');
        });
    }

    return query;
  }
}
