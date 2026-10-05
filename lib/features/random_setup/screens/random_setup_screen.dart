import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';

// МОДЕЛИ ДАННЫХ
class Setup {
  final int id;
  final String name;
  final List<RandomList> lists;

  Setup({required this.id, required this.name, required this.lists});
}

class RandomList {
  final int id;
  final String name;
  final int itemsNum;
  final bool isUnique;
  final List<GameComponent> components;

  RandomList({
    required this.id,
    required this.name,
    required this.itemsNum,
    required this.isUnique,
    required this.components,
  });
}

class GameComponent {
  final int id;
  final String name;
  final int copies;
  final String? imagePath;

  GameComponent({
    required this.id,
    required this.name,
    required this.copies,
    this.imagePath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameComponent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ResultItem {
  final int id;
  final String name;
  final String? imagePath;
  int position;

  ResultItem({
    required this.id,
    required this.name,
    this.imagePath,
    required this.position,
  });
}

class ListResult {
  final int id;
  final String name;
  final List<ResultItem> items;

  ListResult({required this.id, required this.name, required this.items});
}

class SavedResult {
  final int id;
  final String name;
  final String description;
  final List<ListResult> lists;

  SavedResult({
    required this.id,
    required this.name,
    required this.description,
    required this.lists,
  });
}

// ОСНОВНОЙ ЭКРАН
class RandomSetupScreen extends ConsumerStatefulWidget {
  final int gameId;

  const RandomSetupScreen({super.key, required this.gameId});

  @override
  ConsumerState<RandomSetupScreen> createState() => _RandomSetupScreenState();
}

class _RandomSetupScreenState extends ConsumerState<RandomSetupScreen> {
  Setup? _selectedSetup;
  List<ListResult>? _result;
  bool _isGenerating = false;

  final List<Setup> _setups = [];
  final List<SavedResult> _savedResults = [];
  // Контроллеры
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final RandomSetupDao randomSetupDao = ref.read(randomSetupDaoProvider);
    List<RandomSetup> setups = await randomSetupDao.getAll(widget.gameId);
    for (final RandomSetup setup in setups) {
      _setups.add(Setup(id: setup.id, name: setup.name, lists: []));
    }

    if (_setups.isNotEmpty) {
      _selectedSetup = _setups.first;

      final RandomSetupData setupData = await randomSetupDao.get(
        randomSetupId: _selectedSetup!.id,
      );
      _fillSetupData(_selectedSetup!, setupData);

      await _loadSavedResults();
    }

    setState(() => _isLoading = false);
  }

  void _fillSetupData(Setup setup, RandomSetupData data) {
    if (setup.lists.isEmpty) {
      for (final RandomListData listData in data.randomLists) {
        setup.lists.add(
          RandomList(
            id: listData.randomList.id,
            name: listData.randomList.name,
            itemsNum: listData.randomList.itemsNum,
            isUnique: listData.randomList.isUnique,
            components: listData.items
                .map(
                  (ListItemData itemData) => GameComponent(
                    id: itemData.listItem.id,
                    name: itemData.listItem.name,
                    copies: itemData.listItem.copiesNum,
                    imagePath: itemData.component!.imagePath,
                  ),
                )
                .toList(),
          ),
        );
      }
    }
  }

  Future<void> _loadSavedResults() async {
    _savedResults.clear();

    if (_selectedSetup != null) {
      final SavedSetupDao savedSetupDao = ref.read(savedSetupDaoProvider);
      final List<SavedSetup> savedResults = await savedSetupDao.getAll(
        _selectedSetup!.id,
      );

      for (final SavedSetup savedResult in savedResults) {
        _savedResults.add(
          SavedResult(
            id: savedResult.id,
            name: savedResult.name,
            description: savedResult.description ?? '',
            lists: [],
          ),
        );
      }
    }
  }

  Future<void> _onSetupSelect(Setup setup) async {
    setState(() => _isLoading = true);

    final RandomSetupDao randomSetupDao = ref.read(randomSetupDaoProvider);
    final RandomSetupData setupData = await randomSetupDao.get(
      randomSetupId: setup.id,
    );
    _fillSetupData(setup, setupData);

    await _loadSavedResults();

    setState(() {
      _selectedSetup = setup;
      _result = null;
      _isLoading = false;
    });
  }

  Future<void> _saveResult({SavedResult? savedSetup}) async {
    setState(() => _isLoading = true);

    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();

    final List<SavedListItemInputData> items = [];
    for (final ListResult listResultData in _result!) {
      for (final ResultItem itemData in listResultData.items) {
        items.add(
          SavedListItemInputData(
            listId: listResultData.id,
            listItemId: itemData.id,
            position: itemData.position,
          ),
        );
      }
    }

    final SavedSetupDao savedSetupDao = ref.read(savedSetupDaoProvider);
    if (savedSetup != null) {
      await savedSetupDao.updInstance(
        savedSetupId: savedSetup.id,
        savedSetup: SavedSetupsCompanion(
          name: Value(name),
          description: Value(description),
          randomSetupId: Value(_selectedSetup!.id),
        ),
        items: items,
      );
    } else {
      await savedSetupDao.create(
        savedSetup: SavedSetupsCompanion(
          name: Value(name),
          description: Value(description),
          randomSetupId: Value(_selectedSetup!.id),
        ),
        items: items,
      );
    }

    await _loadSavedResults();

    setState(() => _isLoading = false);
  }

  Future<void> _delSavedSetup(SavedResult savedSetup) async {
    setState(() => _isLoading = true);

    final SavedSetupDao savedSetupDao = ref.read(savedSetupDaoProvider);
    await savedSetupDao.delInstance(savedSetup.id);

    await _loadSavedResults();

    setState(() => _isLoading = false);
  }

  Future<void> _editSavedSetup(SavedResult savedSetup) async {
    await _onSavedSetupSelect(savedSetup);

    _showManualCreateDialog(savedSetup: savedSetup);
  }

  Future<void> _onSavedSetupSelect(SavedResult savedResult) async {
    setState(() => _isLoading = true);

    if (savedResult.lists.isEmpty) {
      final SavedSetupDao savedSetupDao = ref.read(savedSetupDaoProvider);
      final SavedSetupData? setupData = await savedSetupDao.get(savedResult.id);
      final Map<int, dynamic> resultListsMap = {};
      for (final SavedListItemData itemData in setupData!.items) {
        final ResultItem item = ResultItem(
          id: itemData.listItem.id,
          name: itemData.listItem.name,
          imagePath: itemData.component.imagePath,
          position: itemData.position,
        );

        if (resultListsMap[itemData.list.id] == null) {
          resultListsMap[itemData.list.id] = {
            'list': itemData.list,
            'items': [item],
          };
        } else {
          resultListsMap[itemData.list.id]['items'].add(item);
        }
      }

      for (final listData in resultListsMap.values) {
        savedResult.lists.add(
          ListResult(
            id: listData['list'].id,
            name: listData['list'].name,
            items: listData['items'],
          ),
        );
      }
    }

    setState(() {
      _result = savedResult.lists;
      _isLoading = false;
    });
  }

  // ============================================
  // ГЕНЕРАЦИЯ
  // ============================================

  void _generate() {
    if (_selectedSetup == null) return;

    setState(() => _isGenerating = true);

    // Имитация задержки
    Future.delayed(const Duration(milliseconds: 500), () {
      final random = Random();
      final List<ListResult> result = [];

      for (var list in _selectedSetup!.lists) {
        // Собираем пул
        final pool = <GameComponent>[];
        for (var sc in list.components.where((c) => c.copies > 0)) {
          for (int i = 0; i < sc.copies; i++) {
            pool.add(sc);
          }
        }

        if (pool.isEmpty) {
          result.add(ListResult(id: list.id, name: list.name, items: []));
          continue;
        }

        // Перемешиваем
        pool.shuffle(random);

        // Выбираем
        final selected = <GameComponent>[];
        if (list.isUnique) {
          final seen = <int>{};
          for (var sc in pool) {
            if (!seen.contains(sc.id)) {
              seen.add(sc.id);
              selected.add(sc);
              if (selected.length >= list.itemsNum) break;
            }
          }
        } else {
          selected.addAll(pool.take(list.itemsNum));
        }

        // Формируем результат
        final items = selected.asMap().entries.map((e) {
          return ResultItem(
            id: e.value.id,
            name: e.value.name,
            imagePath: e.value.imagePath,
            position: e.key,
          );
        }).toList();

        result.add(ListResult(id: list.id, name: list.name, items: items));
      }

      setState(() {
        _result = result;
        _isGenerating = false;
      });
    });
  }

  // ============================================
  // СОХРАНЕНИЕ РЕЗУЛЬТАТА
  // ============================================

  void _showSaveDialog() {
    if (_result == null) return;

    _nameController.clear();
    _descriptionController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сохранить результат'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) {
                _showError('Введите название');
                return;
              }

              _saveResult();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Результат сохранён'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: firstColor,
            ),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  // ============================================
  // ВЫБОР СОХРАНЁННОГО РЕЗУЛЬТАТА
  // ============================================

  void _showSavedResultsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: secondColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: firstColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Сохранённые результаты',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Список
              Flexible(
                child: _savedResults.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Нет сохранённых результатов'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: _savedResults.length,
                        itemBuilder: (context, index) {
                          final saved = _savedResults[index];
                          return Dismissible(
                            key: Key(saved.id.toString()),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                _delSavedSetup(saved);
                              } else {
                                Navigator.pop(context);
                                _editSavedSetup(saved);
                              }
                            },

                            // Фон при свайпе вправо
                            background: Container(
                              color: redColor,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Icon(delIcon, color: textColor),
                                  SizedBox(width: 8),
                                  Text(
                                    'Удалить',
                                    style: TextStyle(color: textColor),
                                  ),
                                ],
                              ),
                            ),

                            // Фон при свайпе влево
                            secondaryBackground: Container(
                              color: goldColor,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Редактировать',
                                    style: TextStyle(color: textColor),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(editIcon, color: textColor),
                                ],
                              ),
                            ),

                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: firstColor,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: secondColor,
                                  child: Icon(
                                    Icons.save,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  saved.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      saved.description.isEmpty
                                          ? emptyVal
                                          : saved.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pop(context);
                                  _onSavedSetupSelect(saved);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // РУЧНОЕ СОЗДАНИЕ
  // ============================================

  void _showManualCreateDialog({SavedResult? savedSetup}) {
    if (_selectedSetup == null) return;

    final Map<int, List<dynamic>> manualResult = {};

    // Инициализируем пустые списки
    for (var list in _selectedSetup!.lists) {
      manualResult[list.id] = [];
    }
    // Заполняем данными
    if (savedSetup != null) {
      _nameController.text = savedSetup.name;
      _descriptionController.text = savedSetup.description;

      final Map<int, int> itemCountMap = {};
      for (final ListResult listResult in savedSetup.lists) {
        listResult.items.sort((a, b) => a.position.compareTo(b.position));
        for (final ResultItem item in listResult.items) {
          if (itemCountMap[item.id] == null) {
            itemCountMap[item.id] = 0;
          } else {
            itemCountMap[item.id] = itemCountMap[item.id]! + 1;
          }

          manualResult[listResult.id]!.add([itemCountMap[item.id], item]);
        }
      }
    } else {
      _nameController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: firstColor,
              child: Column(
                children: [
                  // Заголовок
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: secondColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ручное '
                            '${savedSetup == null ? 'создание' : 'редактирование'}'
                            ' результата',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Форма
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Название',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Описание',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  // Списки
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _selectedSetup!.lists.length,
                      itemBuilder: (context, index) {
                        final list = _selectedSetup!.lists[index];
                        final selected = manualResult[list.id] ?? [];

                        final List<List> components = [];
                        for (final GameComponent item in list.components) {
                          for (int i = 0; i < item.copies; i++) {
                            components.add([i, item]);
                          }
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок списка
                                Row(
                                  children: [
                                    Text(
                                      list.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${selected.length}/${list.itemsNum}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (selected.isNotEmpty)
                                      TextButton(
                                        onPressed: () {
                                          setStateDialog(() {
                                            manualResult[list.id] = [];
                                          });
                                        },
                                        child: const Text(
                                          'Очистить',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Пул компонентов
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: components.map((gcData) {
                                    final isSelected = selected.any(
                                      (item) =>
                                          item[0] == gcData[0] &&
                                          item[1].id == gcData[1].id,
                                    );
                                    final position = isSelected
                                        ? selected.indexWhere(
                                                (item) =>
                                                    item[0] == gcData[0] &&
                                                    item[1].id == gcData[1].id,
                                              ) +
                                              1
                                        : null;

                                    return GestureDetector(
                                      onTap: () {
                                        setStateDialog(() {
                                          if (isSelected) {
                                            manualResult[list.id]!.removeWhere(
                                              (item) =>
                                                  item[0] == gcData[0] &&
                                                  item[1].id == gcData[1].id,
                                            );
                                            _renumber(manualResult[list.id]!);
                                          } else {
                                            if (list.itemsNum >
                                                selected.length) {
                                              manualResult[list.id]!.add([
                                                gcData[0],
                                                ResultItem(
                                                  id: gcData[1].id,
                                                  name: gcData[1].name,
                                                  imagePath:
                                                      gcData[1].imagePath,
                                                  position:
                                                      manualResult[list.id]!
                                                          .length,
                                                ),
                                              ]);
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? goldColor
                                                : Colors.grey.shade300,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          color: firstColor,
                                        ),
                                        child: Column(
                                          children: [
                                            // Картинка с номером
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                7,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                7,
                                                              ),
                                                        ),
                                                    color: firstColor,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                7,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                7,
                                                              ),
                                                        ),
                                                    child:
                                                        gcData[1].imagePath !=
                                                            null
                                                        ? Image.file(
                                                            File(
                                                              gcData[1]
                                                                  .imagePath!,
                                                            ),
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (_, _, _) =>
                                                                    _buildMiniPlaceholder(),
                                                          )
                                                        : _buildMiniPlaceholder(),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Positioned(
                                                    top: 2,
                                                    left: 2,
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors
                                                                .deepPurple,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      child: Center(
                                                        child: Text(
                                                          '$position',
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            // Название
                                            Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Text(
                                                gcData[1].name,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: isSelected
                                                      ? goldColor
                                                      : textColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Кнопки
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: secondColor,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Отмена'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final name = _nameController.text.trim();
                            if (name.isEmpty) {
                              _showErrorInDialog(context, 'Введите название');
                              return;
                            }

                            // Проверка: все списки заполнены
                            for (var list in _selectedSetup!.lists) {
                              final selected = manualResult[list.id] ?? [];
                              if (selected.isEmpty) {
                                _showErrorInDialog(
                                  context,
                                  'Заполните список "${list.name}"',
                                );
                                return;
                              }
                            }

                            // Формируем результат
                            final result = _selectedSetup!.lists.map((list) {
                              final List<ResultItem> items = [];
                              for (List result in manualResult[list.id] ?? []) {
                                items.add(result[1]);
                              }

                              return ListResult(
                                id: list.id,
                                name: list.name,
                                items: items,
                              );
                            }).toList();

                            _result = result;

                            if (savedSetup != null) {
                              _saveResult(savedSetup: savedSetup);
                            } else {
                              _saveResult();
                            }

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Результат сохранён'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldColor,
                            foregroundColor: firstColor,
                          ),
                          child: const Text('Сохранить'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _renumber(List<dynamic> items) {
    for (int i = 0; i < items.length; i++) {
      items[i][1].position = i;
    }
  }

  // ============================================
  // ВСПОМОГАТЕЛЬНЫЕ
  // ============================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorInDialog(BuildContext dialogContext, String message) {
    final overlay = Overlay.of(dialogContext);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: redColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(color: textColor, fontSize: 20),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  Widget _buildMiniPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 20,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.casino_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Нажмите "Запустить"',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Результат появится здесь',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ============================================
  // РЕЗУЛЬТАТ СПИСКА С DRAG & DROP
  // ============================================

  Widget _buildListResult(ListResult listResult) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: firstColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    listResult.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${listResult.items.length} элементов',
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Элементы с Drag & Drop
            if (listResult.items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Нет элементов',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: listResult.items.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = listResult.items.removeAt(oldIndex);
                    listResult.items.insert(newIndex, item);
                    _renumber(listResult.items);
                  });
                },
                itemBuilder: (context, index) {
                  final item = listResult.items[index];
                  return _buildResultItem(item, index, listResult);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(ResultItem item, int index, ListResult listResult) {
    return ReorderableDelayedDragStartListener(
      key: ValueKey(item.id.toString() + index.toString()),
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: firstColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Номер
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: secondColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Миниатюра
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: item.imagePath != null
                  ? Image.file(
                      File(item.imagePath!),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildMiniPlaceholder(),
                    )
                  : SizedBox(
                      width: 40,
                      height: 40,
                      child: _buildMiniPlaceholder(),
                    ),
            ),
            const SizedBox(width: 10),

            // Название
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Иконка перетаскивания
            Icon(Icons.drag_handle, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Генерация сетапа'),
        actions: [
          if (_result != null)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Сохранить результат',
              onPressed: _showSaveDialog,
            ),
          if (_savedResults.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.folder_open),
              tooltip: 'Сохранённые результаты',
              onPressed: _showSavedResultsDialog,
            ),
          if (_selectedSetup != null)
            IconButton(
              icon: const Icon(Icons.edit_note),
              tooltip: 'Создать вручную',
              onPressed: _showManualCreateDialog,
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.deepPurple.shade100),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Setup>(
                        value: _selectedSetup,
                        isExpanded: true,
                        hint: const Text('Выберите сетап'),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.deepPurple,
                        ),
                        items: _setups.map((setup) {
                          return DropdownMenuItem<Setup>(
                            value: setup,
                            child: Text(setup.name),
                          );
                        }).toList(),
                        onChanged: (value) => _onSetupSelect(value!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _selectedSetup != null && !_isGenerating
                      ? _generate
                      : null,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.casino),
                  label: Text(_isGenerating ? 'Генерация...' : 'Запустить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: firstColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== РЕЗУЛЬТАТ =====
          Expanded(
            child: _result == null
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _result!.length,
                    itemBuilder: (context, index) {
                      return _buildListResult(_result![index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
