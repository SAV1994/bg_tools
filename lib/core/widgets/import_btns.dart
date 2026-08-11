import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/services/export_import_service/export.dart';
import 'package:bg_tools/core/utils/export.dart';

// Кнопки для импорта/экспорта
class BackupButtons extends ConsumerWidget {
  const BackupButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => exportData(context: context, mover: AllDataMover()),
          icon: const Icon(exportIcon),
          label: const Text('Экспорт'),
          style: ElevatedButton.styleFrom(backgroundColor: greenColor),
        ),
        ElevatedButton.icon(
          onPressed: () => importData(
            context: context,
            mover: AllDataMover(),
            onSuccess: () {
              // Обновляем провайдеры
              ref.invalidate(countingTemplateDataProvider);
              ref.invalidate(gameFullDataProvider);
              ref.invalidate(ownerDataProvider);
              ref.invalidate(gamingSessionFullDataProvider);
              // AppDataManager
              ref.invalidate(sessionDataProvider);
              // AsyncNotifierProvider
              final artistsNotifier = ref.read(
                artistsPaginatedProvider.notifier,
              );
              artistsNotifier.refresh();
              final countingTemplatesNotifier = ref.read(
                countingTemplatesPaginatedProvider.notifier,
              );
              countingTemplatesNotifier.refresh();
              final designersNotifier = ref.read(
                designersPaginatedProvider.notifier,
              );
              designersNotifier.refresh();
              final gamesNotifier = ref.read(gamesPaginatedProvider.notifier);
              gamesNotifier.refresh();
              final gamersNotifier = ref.read(gamersPaginatedProvider.notifier);
              gamersNotifier.refresh();
              final gamesCountingTemplatesNotifier = ref.read(
                gamesCountingTemplatesPaginatedProvider.notifier,
              );
              gamesCountingTemplatesNotifier.refresh();
              final gamingSessionsNotifier = ref.read(
                gamingSessionsPaginatedProvider.notifier,
              );
              gamingSessionsNotifier.refresh();
              final notesNotifier = ref.read(notesPaginatedProvider.notifier);
              notesNotifier.refresh();
              final tagsNotifier = ref.read(tagsPaginatedProvider.notifier);
              tagsNotifier.refresh();
            },
            warnStr:
                'Импорт заменит все текущие данные!\n'
                'Вы уверены, что хотите продолжить?',
          ),
          icon: const Icon(Icons.restore),
          label: const Text('Импорт'),
          style: ElevatedButton.styleFrom(backgroundColor: titleColor),
        ),
      ],
    );
  }
}
