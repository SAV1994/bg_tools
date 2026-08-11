import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/custom_exceptions.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/services/image_service.dart';

abstract class BaseMover {
  final int type = 0;
  final ProviderContainer container = ProviderContainer();

  // Экспорт данных из БД в JSON
  Future<void> exportDatabase(Directory exportDir) async {
    final Map<String, dynamic> exportData = await extractToJson();

    final jsonFile = File(path.join(exportDir.path, 'data.json'));
    await jsonFile.writeAsString(jsonEncode(exportData));
  }

  Future<Map<String, dynamic>> extractToJson();

  // Экспорт изображений
  Future<void> exportImages(Directory exportDir) async {
    final List<Game> games = await getExportGames();

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

  Future<List<Game>> getExportGames();

  // Название импортируемого файла
  String getZipFileNamePrefix();

  // Импорт данных из распакованной папки
  Future<void> importData(Directory importDir) async {
    // 1. Читаем JSON
    final jsonFile = File(path.join(importDir.path, 'data.json'));
    final jsonContent = await jsonFile.readAsString();
    final data = json.decode(jsonContent);

    if (data[importDataVersionCodeKey] != '${importDataVersionCode}_$type') {
      throw ValidationException('Попытка импорта неверных данных.');
    }

    // 2. Копируем изображения
    final imagesDir = Directory(path.join(importDir.path, 'images'));
    final Map<String, String> newImagePaths = {};

    if (await imagesDir.exists()) {
      final imageFiles = await imagesDir.list().toList();
      for (final imageFile in imageFiles) {
        if (imageFile is File) {
          final newPath = await saveImportedImage(imageFile);
          newImagePaths[path.basename(imageFile.path)] = newPath;
        }
      }
    }

    // 3. Импортируем в БД в транзакции
    final database = container.read(databaseProvider);
    await insertDataToDb(database, newImagePaths, data);
  }

  Future<void> insertDataToDb(
    AppDatabase database,
    Map<String, String> newImagePaths,
    Map data,
  );

  // Сохранение импортированного изображения
  Future<String> saveImportedImage(File imageFile) async {
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
