import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/utils/export.dart';

void buildAddPlayerModal(
  BuildContext context,
  List<Gamer> notSelectedPlayers,
  Function onSelect,
) {
  showDialog(
    context: context,
    builder: (context) {
      String searchQuery = '';
      List<Gamer> localFiltered = List.from(notSelectedPlayers);
      return StatefulBuilder(
        builder: (context, setDialogState) {
          // Функция обновления поиска
          void updateSearch(String query) {
            setDialogState(() {
              searchQuery = query;
              if (query.isEmpty) {
                localFiltered = List.from(notSelectedPlayers);
              } else {
                localFiltered = notSelectedPlayers.where((player) {
                  final username = player.username.toLowerCase();
                  final firstName = player.firstName.toLowerCase();
                  final lastName = player.lastName?.toLowerCase() ?? '';
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
                      prefixIcon: const Icon(Icons.search, color: greenColor),
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
                                Icon(Icons.search_off, size: 48),
                                SizedBox(height: 8),
                                Text('Ничего не найдено'),
                              ],
                            ),
                          )
                        : Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount: localFiltered.length,
                              itemBuilder: (context, index) {
                                final player = localFiltered[index];

                                String fio = getGamerFio(player);

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      player.username[0].toUpperCase(),
                                    ),
                                  ),
                                  title: Text(player.username),
                                  subtitle: Text(fio),
                                  onTap: () {
                                    Navigator.pop(context);
                                    onSelect(player);
                                  },
                                );
                              },
                            ),
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
