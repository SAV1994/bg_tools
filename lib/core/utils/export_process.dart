import 'package:flutter/material.dart';

import 'package:bg_tools/core/services/export_import_service/base_mover.dart';
import 'package:bg_tools/core/services/export_import_service/export.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';

Future<void> exportData({
  required BuildContext context,
  required BaseMover mover,
}) async {
  final backupService = BackupService(mover);

  // Показываем индикатор загрузки
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LoadingScreen(),
  );

  final savedPath = await backupService.exportData();

  mover.container.dispose();

  if (context.mounted) {
    // Закрываем диалог
    Navigator.pop(context);

    if (savedPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Экспорт завершен!\nФайл сохранен.'),
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
}
