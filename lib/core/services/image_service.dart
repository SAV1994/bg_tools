// services/image_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

// Сервис работы с изображениями
class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static const String _imageFolder = 'game_images';

  // Выбор изображения из галереи
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Обрезаем изображение
      final croppedFile = await cropImage(File(image.path));
      if (croppedFile == null) return null;

      // Сжимаем и сохраняем
      return await compressAndSaveImage(croppedFile);
    } catch (e) {
      print('Ошибка выбора изображения: $e');
      return null;
    }
  }

  // Выбор изображения из камеры
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) return null;

      final croppedFile = await cropImage(File(image.path));
      if (croppedFile == null) return null;

      return await compressAndSaveImage(croppedFile);
    } catch (e) {
      print('Ошибка выбора изображения: $e');
      return null;
    }
  }

  // Обрезка изображения
  static Future<File?> cropImage(File imageFile) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 600, ratioY: 600),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Обрезка изображения',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Обрезка изображения'),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      print('Ошибка обрезки: $e');
      return null;
    }
  }

  // Сжатие и сохранение изображения
  static Future<File?> compressAndSaveImage(File imageFile) async {
    try {
      // Получаем директорию для приложения
      final appDir = await getExternalStorageDirectory();
      final gameImagesDir = Directory(path.join(appDir!.path, _imageFolder));

      // Создаем папку если не существует
      if (!await gameImagesDir.exists()) {
        await gameImagesDir.create(recursive: true);
      }

      // Генерируем уникальное имя файла
      final fileName = '${const Uuid().v4()}.jpg';
      final savePath = path.join(gameImagesDir.path, fileName);

      // Сжимаем изображение
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        savePath,
        quality: 80,
        format: CompressFormat.jpeg,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print('Ошибка сжатия/сохранения: $e');
      return null;
    }
  }

  // Получение изображения по пути
  static Future<File?> getImageFile(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return null;

    final file = File(imagePath);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  // Удаление изображения
  static Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Ошибка удаления: $e');
    }
  }
}
