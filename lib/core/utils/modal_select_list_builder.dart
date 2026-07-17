import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class SelectItem {
  int id;
  String name;

  SelectItem(this.id, this.name);
}

void buildSelectListModal(
  BuildContext context,
  List<SelectItem> notSelectedItems,
  Function onSelect,
) {
  showDialog(
    context: context,
    builder: (context) {
      String searchQuery = '';
      List<SelectItem> localFiltered = List.from(notSelectedItems);
      return StatefulBuilder(
        builder: (context, setDialogState) {
          // Функция обновления поиска
          void updateSearch(String query) {
            setDialogState(() {
              searchQuery = query;
              if (query.isEmpty) {
                localFiltered = List.from(notSelectedItems);
              } else {
                final searchLower = query.toLowerCase();
                localFiltered = notSelectedItems.where((item) {
                  return item.name.toLowerCase().contains(searchLower);
                }).toList();
              }
            });
          }

          return AlertDialog(
            title: const Text('Выберите одно'),
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
                                final item = localFiltered[index];

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(item.name[0].toUpperCase()),
                                  ),
                                  title: Text(item.name),
                                  onTap: () {
                                    Navigator.pop(context);
                                    onSelect(item);
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
