import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';

void buildAddGameModal(
  BuildContext context,
  List<Game> notSelectedGames,
  Function onSelect,
) {
  showDialog(
    context: context,
    builder: (context) {
      String searchQuery = '';
      List<Game> localFiltered = List.from(notSelectedGames);
      return StatefulBuilder(
        builder: (context, setDialogState) {
          // Функция обновления поиска
          void updateSearch(String query) {
            setDialogState(() {
              searchQuery = query;
              if (query.isEmpty) {
                localFiltered = List.from(notSelectedGames);
              } else {
                localFiltered = notSelectedGames.where((game) {
                  final name = game.name.toLowerCase();
                  final searchLower = query.toLowerCase();
                  return name.contains(searchLower);
                }).toList();
              }
            });
          }

          return AlertDialog(
            title: const Text('Выберите игру'),
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
                                final game = localFiltered[index];

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(game.name[0].toUpperCase()),
                                  ),
                                  title: Text(game.name),
                                  onTap: () {
                                    Navigator.pop(context);
                                    onSelect(game);
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
