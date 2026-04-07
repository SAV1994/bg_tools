import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/universal_attr_getter.dart';

void buildDelModal(BuildContext context, WidgetRef ref, Provider daoProvider, bool mounted, instance) {
  final String instName = UniversalAttrGetter.getTitle(instance);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Удаление'),
      content: Text('Вы уверены, что хотите удалить "$instName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () async {
            final dao = ref.read(daoProvider);
            await dao.delInstance(instance.id);
            if (mounted) {
              Navigator.pop(context); // Закрыть диалог
              Navigator.pop(context, true); // Вернуться назад
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Игра "$instName" удалена'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Удалить'),
        ),
      ],
    )
  );
}
