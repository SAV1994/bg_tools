// database/daos/game_note_dao.dart
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/note.dart';
import 'package:drift/drift.dart';

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

  // Cписок заметок
  Future<List<Note>> getAll(int gameId) async {
    return await (select(notes)
          ..where((n) => n.gameId.equals(gameId))
          ..orderBy([
            (n) =>
                OrderingTerm(expression: n.updatedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Cписок заметок (поток)
  Stream<List<Note>> watchAll(int gameId) {
    return (select(notes)
          ..where((n) => n.gameId.equals(gameId))
          ..orderBy([
            (gn) =>
                OrderingTerm(expression: gn.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  // Заметка
  Future<Note?> getSingle(int noteId) async {
    return await (select(
      notes,
    )..where((n) => n.id.equals(noteId))).getSingleOrNull();
  }
}
