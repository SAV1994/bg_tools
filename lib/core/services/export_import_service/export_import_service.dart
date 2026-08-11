import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:bg_tools/core/services/export_import_service/base_mover.dart';
import 'package:bg_tools/core/services/permissions_service.dart';

// Сервис импорта/экспорта
class BackupService {
  final BaseMover mover;

  BackupService(this.mover);

  // ЭКСПОРТ (Экспорт всех данных в ZIP файл)
  Future<String?> exportData() async {
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
      await mover.exportDatabase(exportDir);

      // 2. Экспортируем изображения
      await mover.exportImages(exportDir);

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

  /// Создание ZIP архива
  Future<String> _createZipArchive(
    Directory tempDir,
    Directory exportDir,
  ) async {
    final encoder = ZipFileEncoder();
    final tempZipPath = path.join(
      tempDir.path,
      '${mover.getZipFileNamePrefix()}${DateTime.now().millisecondsSinceEpoch}.zip',
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
          '${mover.getZipFileNamePrefix()}${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}.zip',
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
      await mover.importData(extractDir);

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
}
