import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/gaming_session_provider.dart';

// Модальное окно с подтверждением удаления (тут и сам процесс удаления)
void buildClearSessionsModal(
  BuildContext context,
  WidgetRef ref,
  bool mounted,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Очистка истории партий'),
      content: Text('Вы уверены, что хотите обнулить историю партий?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () async {
            final dao = ref.read(gamingSessionDaoProvider);
            await dao.delAll();

            final notifier = ref.read(gamingSessionsPaginatedProvider.notifier);
            notifier.refresh();

            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('История партий очищена')));
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Очистить'),
        ),
      ],
    ),
  );
}
