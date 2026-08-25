import 'package:flutter/material.dart';

import 'package:bg_tools/core/widgets/loading_screen.dart';
import 'package:bg_tools/features/export_import_service/services/base_mover.dart';
import 'package:bg_tools/features/export_import_service/services/export.dart';

Future<void> importData({
  required BuildContext context,
  required BaseMover mover,
  required Function onSuccess,
  required String warnStr,
}) async {
  // Подтверждение импорта
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Импорт данных'),
      content: Text(warnStr),
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
  if (context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingScreen(),
    );
  }

  final backupService = BackupService(mover);
  final success = await backupService.importData();

  mover.container.dispose();

  if (context.mounted) {
    // Закрываем диалог
    Navigator.pop(context);
  }

  if (success) {
    onSuccess();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Импорт завершен успешно!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка импорта'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
