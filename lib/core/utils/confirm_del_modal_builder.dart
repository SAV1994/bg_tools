import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/universal_attr_getter.dart';

// Модальное окно с подтверждением удаления (тут и сам процесс удаления)
void buildDelModal(
  BuildContext context,
  WidgetRef ref,
  Provider daoProvider,
  bool mounted,
  instance, [
  Function? afterDel,
]) {
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
            ref.invalidate(
              gameFullDataProvider,
            ); // Обновляем провайдер с данными для игр
            if (mounted) {
              if (afterDel != null) {
                afterDel();
              }
              Navigator.pop(context); // Закрыть диалог
              Navigator.pop(context, true); // Вернуться назад
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Запись "$instName" удалена'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Удалить'),
        ),
      ],
    ),
  );
}
