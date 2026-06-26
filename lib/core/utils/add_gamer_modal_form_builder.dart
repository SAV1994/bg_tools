import 'package:flutter/material.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/utils/gamer_fio_builder.dart';

void buildAddGamerModal(
  BuildContext context,
  List<Gamer> notSelectedGamers,
  Function onSelect,
) {
  showDialog(
    context: context,
    builder: (context) {
      String searchQuery = '';
      List<Gamer> localFiltered = List.from(notSelectedGamers);
      return StatefulBuilder(
        builder: (context, setDialogState) {
          // Функция обновления поиска
          void updateSearch(String query) {
            setDialogState(() {
              searchQuery = query;
              if (query.isEmpty) {
                localFiltered = List.from(notSelectedGamers);
              } else {
                localFiltered = notSelectedGamers.where((gamer) {
                  final username = gamer.username.toLowerCase();
                  final firstName = gamer.firstName.toLowerCase();
                  final lastName = gamer.lastName?.toLowerCase() ?? '';
                  final searchLower = query.toLowerCase();
                  return username.contains(searchLower) ||
                      firstName.contains(searchLower) ||
                      lastName.contains(searchLower);
                }).toList();
              }
            });
          }

          return AlertDialog(
            title: const Text('Выберите игрока'),
            content: SizedBox(
              width: 400,
              height: 500,
              child: Column(
                children: [
                  // Поле поиска в диалоге
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => updateSearch(''),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: updateSearch,
                  ),
                  const SizedBox(height: 12),

                  // Результаты поиска
                  Expanded(
                    child: localFiltered.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text('Ничего не найдено'),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: localFiltered.length,
                            itemBuilder: (context, index) {
                              final gamer = localFiltered[index];

                              String fio = getGamerFio(gamer);

                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(gamer.username[0].toUpperCase()),
                                ),
                                title: Text(gamer.username),
                                subtitle: Text(fio),
                                onTap: () {
                                  Navigator.pop(context);
                                  onSelect(gamer);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
            ],
          );
        },
      );
    },
  );
}
