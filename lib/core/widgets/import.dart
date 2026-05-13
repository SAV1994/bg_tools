import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/services/export_service.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

// Кнопки для импорта/экспорта
class BackupButtons extends ConsumerWidget {
  const BackupButtons({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final database = ref.read(databaseProvider);
    final backupService = BackupService(database);

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => buildLoadingScreen(),
    );

    final savedPath = await backupService.exportAllData();

    // Закрываем диалог
    Navigator.pop(context);

    if (savedPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Экспорт завершен!\nФайл сохранен: ${savedPath.split('/').last}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка экспорта'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    // Подтверждение импорта
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Импорт данных'),
        content: const Text(
          'Импорт заменит все текущие данные!\n'
          'Вы уверены, что хотите продолжить?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Импорт', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => buildLoadingScreen(),
    );

    final database = ref.read(databaseProvider);
    final backupService = BackupService(database);
    final success = await backupService.importData();

    // Закрываем диалог
    Navigator.pop(context);

    if (success) {
      // Обновляем провайдеры
      ref.invalidate(artistsDataProvider);
      ref.invalidate(designersDataProvider);
      ref.invalidate(gamesDataProvider);
      ref.invalidate(gameFullDataProvider);
      ref.invalidate(ownerDataProvider);
      ref.invalidate(gamingSessionDataProvider);
      ref.invalidate(gamingSessionFullDataProvider);
      ref.invalidate(notesForGameDataProvider);
      ref.invalidate(tagsDataProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Импорт завершен успешно!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка импорта'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _exportData(context, ref),
          icon: const Icon(Icons.save_alt),
          label: const Text('Экспорт'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _importData(context, ref),
          icon: const Icon(Icons.restore),
          label: const Text('Импорт'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
