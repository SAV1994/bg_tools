// services/backup_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/services/image_service.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/services/permissions_service.dart';

// Сервис импорта/экспорта
class BackupService {
  final AppDatabase database;

  BackupService(this.database);

  // ЭКСПОРТ (Экспорт всех данных в ZIP файл)
  Future<String?> exportAllData() async {
    // Создаем временную папку
    final Directory? rootDir = await getExternalStorageDirectory();
    final Directory tempDir = Directory(path.join(rootDir!.path, 'export'));
    final Directory exportDir = Directory(
      path.join(
        tempDir.path,
        'export_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );

    try {
      // Проверяем разрешение
      final hasPermission = await PermissionService.hasWritePermission();

      if (!hasPermission) {
        // Запрашиваем
        final granted = await PermissionService.requestWritePermission();
        if (!granted) {
          throw Exception('Нет разрешения на запись');
        }
      }

      await exportDir.create(recursive: true);

      // 1. Экспортируем данные из БД
      await _exportDatabase(exportDir);

      // 2. Экспортируем изображения
      await _exportImages(exportDir);

      // 3. Создаем ZIP архив
      final tempZipPath = await _createZipArchive(tempDir, exportDir);

      // 4. Сохраняем ZIP в выбранное место
      final savedPath = await _saveZipFile(tempZipPath);

      return savedPath;
    } catch (e) {
      print('Ошибка экспорта: $e');
      return null;
    } finally {
      // Безопасно удаляем временную папку
      await _safeDelete(tempDir);
    }
  }

  /// Экспорт данных из БД в JSON
  Future<void> _exportDatabase(Directory exportDir) async {
    // Получаем все данные из таблиц
    final artists = await database.select(database.artists).get();
    final countingTemplates = await database
        .select(database.countingTemplates)
        .get();
    final designers = await database.select(database.designers).get();
    final tags = await database.select(database.tags).get();
    final gamers = await database.select(database.gamers).get();
    final games = await database.select(database.games).get();
    final expansionsGames = await database
        .select(database.expansionsGames)
        .get();
    final gamesArtists = await database.select(database.gamesArtists).get();
    final gamesCountingTemplates = await database
        .select(database.gamesCountingTemplates)
        .get();
    final gamesCountingTemplateExpansions = await database
        .select(database.gamesCountingTemplatesExpansions)
        .get();
    final gamesDesigners = await database.select(database.gamesDesigners).get();
    final gamesTags = await database.select(database.gamesTags).get();
    final notes = await database.select(database.notes).get();
    final gamingSessions = await database.select(database.gamingSessions).get();
    final gamingSessionsExpansions = await database
        .select(database.gamingSessionsExpansions)
        .get();
    final gamingSessionsGamers = await database
        .select(database.gamingSessionsGamers)
        .get();

    // Формируем JSON
    final exportData = {
      'version': 1,
      'exportDate': DateTime.now().toIso8601String(),
      'artists': artists
          .map((artist) => {'id': artist.id, 'name': artist.name})
          .toList(),
      'countingTemplates': countingTemplates
          .map(
            (countingTemplate) => {
              'id': countingTemplate.id,
              'name': countingTemplate.name,
              'description': countingTemplate.description,
              'data': countingTemplate.data,
            },
          )
          .toList(),
      'designers': designers
          .map((disigner) => {'id': disigner.id, 'name': disigner.name})
          .toList(),
      'tags': tags.map((tag) => {'id': tag.id, 'name': tag.name}).toList(),
      'gamers': gamers
          .map(
            (gamer) => {
              'id': gamer.id,
              'username': gamer.username,
              'firstName': gamer.firstName,
              'lastName': gamer.lastName,
              'middleName': gamer.middleName,
              'isOwner': gamer.isOwner,
            },
          )
          .toList(),
      'games': games
          .map(
            (game) => {
              'id': game.id,
              'name': game.name,
              'description': game.description,
              'year': game.year,
              'minPlayers': game.minPlayers,
              'maxPlayers': game.maxPlayers,
              'isInCollection': game.isInCollection,
              'isFavorite': game.isFavorite,
              'rating': game.rating,
              'isStandalone': game.isStandalone,
              'imagePath': game.imagePath,
            },
          )
          .toList(),
      'expansionsGames': expansionsGames
          .map((eg) => {'gameId': eg.gameId, 'expansionId': eg.expansionId})
          .toList(),
      'gamesArtists': gamesArtists
          .map((ga) => {'gameId': ga.gameId, 'artistId': ga.artistId})
          .toList(),
      'gamesCountingTemplates': gamesCountingTemplates
          .map(
            (gct) => {
              'id': gct.id,
              'name': gct.name,
              'data': gct.data,
              'gameId': gct.gameId,
              'countingTemplateId': gct.countingTemplateId,
            },
          )
          .toList(),
      'gamesCountingTemplateExpansions': gamesCountingTemplateExpansions
          .map(
            (gcte) => {
              'gamesCountingTemplateId': gcte.gamesCountingTemplateId,
              'gameId': gcte.gameId,
            },
          )
          .toList(),
      'gameDesigners': gamesDesigners
          .map((gd) => {'gameId': gd.gameId, 'designerId': gd.designerId})
          .toList(),
      'gamesTags': gamesTags
          .map((gt) => {'gameId': gt.gameId, 'tagId': gt.tagId})
          .toList(),
      'notes': notes
          .map(
            (note) => {
              'id': note.id,
              'gameId': note.gameId,
              'title': note.title,
              'content': note.content,
              'createdAt': note.createdAt.toIso8601String(),
              'updatedAt': note.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'gamingSessions': gamingSessions
          .map(
            (gamingSession) => {
              'id': gamingSession.id,
              'gameId': gamingSession.gameId,
              'startedAt': gamingSession.startedAt.toIso8601String(),
              'finishedAt': gamingSession.finishedAt?.toIso8601String(),
              'comment': gamingSession.comment,
              'gameType': gamingSession.gameType,
              'data': gamingSession.data,
              'rootSessionId': gamingSession.rootSessionId,
            },
          )
          .toList(),
      'gamingSessionsExpansions': gamingSessionsExpansions
          .map(
            (ge) => {
              'gamingSessionId': ge.gamingSessionId,
              'gameId': ge.gameId,
            },
          )
          .toList(),
      'gamingSessionsGamers': gamingSessionsGamers
          .map(
            (gg) => {
              'gamingSessionId': gg.gamingSessionId,
              'gamerId': gg.gamerId,
              'score': gg.score,
              'place': gg.place,
              'turnOrder': gg.turnOrder,
              'team': gg.team,
              'data': gg.data,
            },
          )
          .toList(),
    };

    // Сохраняем JSON файл
    final jsonFile = File(path.join(exportDir.path, 'data.json'));
    await jsonFile.writeAsString(jsonEncode(exportData));
  }

  /// Экспорт изображений
  Future<void> _exportImages(Directory exportDir) async {
    final games = await database.select(database.games).get();
    final imagesDir = Directory(path.join(exportDir.path, 'images'));
    await imagesDir.create();

    for (final game in games) {
      if (game.imagePath != null && game.imagePath!.isNotEmpty) {
        final sourceFile = await ImageService.getImageFile(game.imagePath!);
        await sourceFile!.copy(
          path.join(imagesDir.path, path.basename(game.imagePath!)),
        );
      }
    }
  }

  /// Создание ZIP архива
  Future<String> _createZipArchive(
    Directory tempDir,
    Directory exportDir,
  ) async {
    final encoder = ZipFileEncoder();
    final tempZipPath = path.join(
      tempDir.path,
      'backup_${DateTime.now().millisecondsSinceEpoch}.zip',
    );
    await encoder.zipDirectory(exportDir, filename: tempZipPath);

    return tempZipPath;
  }

  /// Сохранение ZIP файла (показываем диалог выбора места)
  Future<String?> _saveZipFile(String tempZipPath) async {
    // Читаем данные из файла
    final bytes = await File(tempZipPath).readAsBytes();

    final result = await FilePicker.saveFile(
      dialogTitle: 'Сохранить резервную копию',
      fileName:
          'games_backup_${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}.zip',
      bytes: bytes,
    );

    return result;
  }

  // Безопасное удаление
  Future<void> _safeDelete(Directory dir) async {
    try {
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      print('⚠️ Не удалось удалить папку: $e');
    }
  }

  // ИМПОРТ (Импорт данных из ZIP файла)
  Future<bool> importData() async {
    try {
      // Проверяем разрешение
      final hasPermission = await PermissionService.hasWritePermission();

      if (!hasPermission) {
        // Запрашиваем
        final granted = await PermissionService.requestWritePermission();
        if (!granted) {
          throw Exception('Нет разрешения на запись');
        }
      }

      // Выбираем ZIP файл
      final result = await FilePicker.pickFiles(
        dialogTitle: 'Выберите файл резервной копии',
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null) return false;

      final zipPath = result.files.single.path!;

      // Создаем временную папку для распаковки
      final tempDir = await getExternalStorageDirectory();
      final extractDir = Directory(
        path.join(
          tempDir!.path,
          'import_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      await extractDir.create(recursive: true);

      // Распаковываем ZIP
      await _extractZip(zipPath, extractDir.path);

      // Импортируем данные
      await _importData(extractDir);

      // Очищаем временную папку
      await extractDir.delete(recursive: true);

      return true;
    } catch (e) {
      print('Ошибка импорта: $e');
      return false;
    }
  }

  /// Распаковка ZIP
  Future<void> _extractZip(String zipPath, String destPath) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      if (file.isFile) {
        final filePath = path.join(destPath, file.name);
        final outFile = File(filePath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      }
    }
  }

  /// Импорт данных из распакованной папки
  Future<void> _importData(Directory importDir) async {
    // 1. Читаем JSON
    final jsonFile = File(path.join(importDir.path, 'data.json'));
    final jsonContent = await jsonFile.readAsString();
    final data = json.decode(jsonContent);

    // 2. Копируем изображения
    final imagesDir = Directory(path.join(importDir.path, 'images'));
    final Map<String, String> newImagePaths = {};

    if (await imagesDir.exists()) {
      final imageFiles = await imagesDir.list().toList();
      for (final imageFile in imageFiles) {
        if (imageFile is File) {
          final newPath = await _saveImportedImage(imageFile);
          newImagePaths[path.basename(imageFile.path)] = newPath;
        }
      }
    }

    // 3. Импортируем в БД в транзакции
    await database.transaction(() async {
      // Очищаем существующие данные
      await database.delete(database.artists).go();
      await database.delete(database.countingTemplates).go();
      await database.delete(database.designers).go();
      await database.delete(database.tags).go();
      await database.delete(database.gamers).go();
      await database.delete(database.games).go();
      await database.delete(database.expansionsGames).go();
      await database.delete(database.gamesArtists).go();
      await database.delete(database.gamesCountingTemplates).go();
      await database.delete(database.gamesCountingTemplatesExpansions).go();
      await database.delete(database.gamesDesigners).go();
      await database.delete(database.gamesTags).go();
      await database.delete(database.gamingSessions).go();
      await database.delete(database.gamingSessionsExpansions).go();
      await database.delete(database.gamingSessionsGamers).go();

      // в AppDataManager тоже
      await AppDataManager.clearLastSessionGamers();
      await AppDataManager.clearActiveSession();
      await AppDataManager.clearLastSessionTeams();

      final artistsIds = <int, int>{};
      for (final artistJson in data['artists']) {
        final id = await database
            .into(database.artists)
            .insert(ArtistsCompanion(name: Value(artistJson['name'])));
        artistsIds[artistJson['id']] = id;
      }

      final countingTemplatesIds = <int, int>{};
      for (final countingTemplateJson in data['countingTemplates']) {
        final id = await database
            .into(database.countingTemplates)
            .insert(
              CountingTemplatesCompanion(
                name: Value(countingTemplateJson['name']),
                description: Value(countingTemplateJson['description']),
                data: Value(countingTemplateJson['data']),
              ),
            );
        countingTemplatesIds[countingTemplateJson['id']] = id;
      }

      final designersIds = <int, int>{};
      for (final designerJson in data['designers']) {
        final id = await database
            .into(database.designers)
            .insert(DesignersCompanion(name: Value(designerJson['name'])));
        designersIds[designerJson['id']] = id;
      }

      final tagsIds = <int, int>{};
      for (final tagJson in data['tags']) {
        final id = await database
            .into(database.tags)
            .insert(TagsCompanion(name: Value(tagJson['name'])));
        tagsIds[tagJson['id']] = id;
      }

      final gamersIds = <int, int>{};
      for (final gamerJson in data['gamers']) {
        final id = await database
            .into(database.gamers)
            .insert(
              GamersCompanion(
                username: Value(gamerJson['username']),
                firstName: Value(gamerJson['firstName']),
                lastName: Value(gamerJson['lastName']),
                middleName: Value(gamerJson['middleName']),
                isOwner: Value(gamerJson['isOwner']),
              ),
            );
        gamersIds[gamerJson['id']] = id;
      }

      final gamesIds = <int, int>{};
      for (final gameJson in data['games']) {
        final String? imagePath = gameJson['imagePath'] != null
            ? newImagePaths[path.basename(gameJson['imagePath'])]
            : null;

        final id = await database
            .into(database.games)
            .insert(
              GamesCompanion(
                name: Value(gameJson['name']),
                description: Value(gameJson['description']),
                year: Value(gameJson['year']),
                minPlayers: Value(gameJson['minPlayers']),
                maxPlayers: Value(gameJson['maxPlayers']),
                isInCollection: Value(gameJson['isInCollection']),
                isFavorite: Value(gameJson['isFavorite']),
                rating: Value(gameJson['rating']),
                isStandalone: Value(gameJson['isStandalone'] ?? true),
                imagePath: Value(imagePath),
              ),
            );
        gamesIds[gameJson['id']] = id;
      }

      final gamesCountingTemplatesIds = <int, int>{};
      for (final gamesCountingTemplatesJson in data['gamesCountingTemplates']) {
        final id = await database
            .into(database.gamesCountingTemplates)
            .insert(
              GamesCountingTemplatesCompanion(
                name: Value(gamesCountingTemplatesJson['name']),
                data: Value(gamesCountingTemplatesJson['data']),
                gameId: Value(gamesIds[gamesCountingTemplatesJson['gameId']]!),
                countingTemplateId: Value(
                  countingTemplatesIds[gamesCountingTemplatesJson['countingTemplateId']]!,
                ),
              ),
            );
        gamesCountingTemplatesIds[gamesCountingTemplatesJson['id']] = id;
      }

      for (final gamesCountingTemplateExpansionsJson
          in data['gamesCountingTemplateExpansions']) {
        await database
            .into(database.gamesCountingTemplatesExpansions)
            .insert(
              GamesCountingTemplatesExpansionsCompanion(
                gamesCountingTemplateId: Value(
                  gamesCountingTemplatesIds[gamesCountingTemplateExpansionsJson['gamesCountingTemplateId']]!,
                ),
                gameId: Value(
                  gamesIds[gamesCountingTemplateExpansionsJson['gameId']]!,
                ),
              ),
            );
      }

      final gamingSessionsIds = <int, int>{};
      for (final gamingSessionJson in data['gamingSessions']) {
        final id = await database
            .into(database.gamingSessions)
            .insert(
              GamingSessionsCompanion(
                gameId: Value(gamesIds[gamingSessionJson['gameId']]!),
                startedAt: Value(
                  DateTime.parse(gamingSessionJson['startedAt']),
                ),
                finishedAt: gamingSessionJson['finishedAt'] != null
                    ? Value(DateTime.parse(gamingSessionJson['finishedAt']))
                    : const Value(null),
                comment: Value(gamingSessionJson['comment']),
                gameType: Value(gamingSessionJson['gameType']),
                data: Value(gamingSessionJson['data']),
                rootSessionId: gamingSessionJson['rootSessionId'] != null
                    ? Value(
                        gamingSessionsIds[gamingSessionJson['rootSessionId']]!,
                      )
                    : const Value(null),
              ),
            );
        gamingSessionsIds[gamingSessionJson['id']] = id;
      }

      for (final noteJson in data['notes']) {
        await database
            .into(database.notes)
            .insert(
              NotesCompanion(
                gameId: Value(gamesIds[noteJson['gameId']]!),
                title: Value(noteJson['title']),
                content: Value(noteJson['content']),
                createdAt: Value(DateTime.parse(noteJson['createdAt'])),
                updatedAt: Value(DateTime.parse(noteJson['updatedAt'])),
              ),
            );
      }

      // Импортируем связи
      for (final egJson in data['expansionsGames']) {
        await database
            .into(database.expansionsGames)
            .insert(
              ExpansionsGamesCompanion(
                gameId: Value(gamesIds[egJson['gameId']]!),
                expansionId: Value(gamesIds[egJson['expansionId']]!),
              ),
            );
      }
      for (final gdJson in data['gameDesigners']) {
        await database
            .into(database.gamesDesigners)
            .insert(
              GamesDesignersCompanion(
                gameId: Value(gamesIds[gdJson['gameId']]!),
                designerId: Value(designersIds[gdJson['designerId']]!),
              ),
            );
      }

      for (final gaJson in data['gamesArtists']) {
        await database
            .into(database.gamesArtists)
            .insert(
              GamesArtistsCompanion(
                gameId: Value(gamesIds[gaJson['gameId']]!),
                artistId: Value(artistsIds[gaJson['artistId']]!),
              ),
            );
      }

      for (final gtJson in data['gamesTags']) {
        await database
            .into(database.gamesTags)
            .insert(
              GamesTagsCompanion(
                gameId: Value(gamesIds[gtJson['gameId']]!),
                tagId: Value(tagsIds[gtJson['tagId']]!),
              ),
            );
      }

      for (final gseJson in data['gamingSessionsExpansions']) {
        await database
            .into(database.gamingSessionsExpansions)
            .insert(
              GamingSessionsExpansionsCompanion(
                gamingSessionId: Value(
                  gamingSessionsIds[gseJson['gamingSessionId']]!,
                ),
                gameId: Value(gamesIds[gseJson['gameId']]!),
              ),
            );
      }

      for (final gsgJson in data['gamingSessionsGamers']) {
        await database
            .into(database.gamingSessionsGamers)
            .insert(
              GamingSessionsGamersCompanion(
                gamingSessionId: Value(
                  gamingSessionsIds[gsgJson['gamingSessionId']]!,
                ),
                gamerId: Value(gamersIds[gsgJson['gamerId']]!),
                score: Value(gsgJson['score']),
                place: Value(gsgJson['place']),
                turnOrder: Value(gsgJson['turnOrder']),
                team: Value(gsgJson['team']),
                data: Value(gsgJson['data']),
              ),
            );
      }
    });
  }

  /// Сохранение импортированного изображения
  Future<String> _saveImportedImage(File imageFile) async {
    final appDir = await getExternalStorageDirectory();
    final imagesDir = Directory(path.join(appDir!.path, 'game_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final fileName = path.basename(imageFile.path);
    final destPath = path.join(imagesDir.path, fileName);
    await imageFile.copy(destPath);
    return destPath;
  }
}
