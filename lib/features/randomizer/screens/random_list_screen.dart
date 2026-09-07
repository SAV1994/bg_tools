import 'dart:math';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/randomizer/list_item_dataclasses.dart';
import 'package:bg_tools/core/dataclasses/randomizer/random_list_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/widgets/export.dart';

class RandomizerItem {
  final int? id;
  final String name;
  int copiesNum;

  RandomizerItem({this.id, required this.name, this.copiesNum = 1});
}

class RandomListScreen extends ConsumerStatefulWidget {
  const RandomListScreen({super.key});

  @override
  ConsumerState<RandomListScreen> createState() => _RandomListScreenState();
}

class _RandomListScreenState extends ConsumerState<RandomListScreen> {
  // Список элементов
  final List<RandomizerItem> _items = [];
  late List<RandomList> _randomLists;
  List<String> _pool = [];
  RandomList? _selectedRandomList;
  // Настройки
  bool _isUnique = false;
  int _resultCount = 1;
  // Результат
  List<String> _result = [];
  bool _showResult = false;
  // Контроллеры
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  // Загрузка
  bool _isLoading = false;

  // ID для редактирования
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _randomLists = await getItemsForRandomListSelect();

    setState(() => _isLoading = false);
  }

  // Получить общее количество элементов (с учётом копий)
  int get _totalItems {
    return _items.fold(0, (sum, item) => sum + item.copiesNum);
  }

  // Получить общее количество элементов (с учётом копий)
  int get _totalPoolItems {
    return _pool.length;
  }

  // Проверить, можно ли выбрать указанное количество
  bool get _canSelect {
    if (_items.isEmpty) return false;
    final maxSelectable = _isUnique ? _items.length : _totalItems;
    return _resultCount > 0 && _resultCount <= maxSelectable;
  }

  Future<List<RandomList>> getItemsForRandomListSelect() async {
    final randomListDao = ref.read(randomListDaoProvider);
    return await randomListDao.getAll();
  }

  Future<void> _onRandomListSelected(RandomList? randomList) async {
    setState(() {
      _selectedRandomList = randomList;
      _items.clear();
      _isLoading = true;
    });

    final List<RandomizerItem> items = [];

    if (randomList != null) {
      final randomListDao = ref.read(randomListDaoProvider);
      RandomListData? randomListData = await randomListDao.get(randomList.id);
      for (ListItemData item in randomListData!.items) {
        items.add(
          RandomizerItem(
            id: item.id!,
            name: item.name,
            copiesNum: item.copiesNum,
          ),
        );
      }
    }

    setState(() {
      _items.addAll(items);
      _isLoading = false;
    });
  }

  List<String> _getPool() {
    List<String> pool = [];
    for (var item in _items) {
      for (int i = 0; i < item.copiesNum; i++) {
        pool.add(item.name);
      }
    }

    return pool;
  }

  // Рандомизация
  void _randomize({bool fromPool = false}) {
    if (!_canSelect) return;

    late List<String> pool;
    if (fromPool) {
      pool = _pool;
    } else if (_isUnique) {
      // Уникальные элементы
      pool = _items.map((e) => e.name).toList();
    } else {
      pool = _getPool();
    }

    pool.shuffle();

    // Выбираем результат
    late final List<String> newPool;
    late final List<String> selected;
    if (_resultCount > pool.length) {
      selected = pool;
      newPool = [];
    } else {
      selected = pool.sublist(0, _resultCount);
      newPool = pool.sublist(_resultCount);
    }

    setState(() {
      _result = selected;
      _pool = newPool;
      _showResult = true;
    });
  }

  // Добавить элемент
  void _addItem() {
    _editingId = null;
    _textController.clear();
    _countController.text = '1';
    _showModalDialog();
  }

  // Сохранить список
  Future<void> _saveList() async {
    final randomListDao = ref.read(randomListDaoProvider);

    RandomListsCompanion randomListsCompanion = RandomListsCompanion(
      name: Value(_textController.text),
      type: Value(RandomListTypeEnum.list.id),
      isUnique: Value(_isUnique),
      itemsNum: Value(int.tryParse(_countController.text) ?? 1),
    );
    List<ListItemData> items = [];
    for (final RandomizerItem item in _items) {
      items.add(ListItemData(name: item.name, copiesNum: item.copiesNum));
    }

    late RandomListData? randomListData;
    if (_selectedRandomList != null) {
      await randomListDao.updInstance(
        randomListId: _selectedRandomList!.id,
        randomList: randomListsCompanion,
        items: items,
      );
      randomListData = await randomListDao.get(_selectedRandomList!.id);
    } else {
      int randomListId = await randomListDao.create(
        randomList: randomListsCompanion,
        items: items,
      );
      randomListData = await randomListDao.get(randomListId);
    }

    setState(() => _selectedRandomList = randomListData!.randomList);
  }

  // Удалить список
  Future<void> _deleteList() async {
    final randomListDao = ref.read(randomListDaoProvider);

    await randomListDao.delInstance(_selectedRandomList!.id);

    setState(() => _selectedRandomList = null);
  }

  // Редактировать элемент
  void _editItem(RandomizerItem item) {
    _editingId = item.id;
    _textController.text = item.name;
    _countController.text = item.copiesNum.toString();
    _showModalDialog();
  }

  // Показать диалог добавления/редактирования
  void _showModalDialog({bool saveForm = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          saveForm
              ? 'Сохранить список'
              : _editingId == null
              ? 'Добавить элемент'
              : 'Редактировать элемент',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            if (!saveForm) ...[
              SizedBox(height: 12),
              TextField(
                controller: _countController,
                decoration: InputDecoration(
                  labelText: 'Количество копий',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _textController.text.trim();
              final copiesNum = int.tryParse(_countController.text) ?? 1;

              if (name.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Введите название')));
                return;
              }

              if (!saveForm) {
                Set<String> uniqueItems = _items
                    .map((item) => item.name.toLowerCase())
                    .toSet();
                if (uniqueItems.contains(name.toLowerCase())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Объект уже существует')),
                  );
                  return;
                }
              }

              if (copiesNum < 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Количество копий должно быть ≥ 1')),
                );
                return;
              }

              if (saveForm) {
                _saveList();
              } else {
                setState(() {
                  if (_editingId == null) {
                    // Добавление
                    _items.add(
                      RandomizerItem(name: name, copiesNum: copiesNum),
                    );
                  } else {
                    // Редактирование
                    final index = _items.indexWhere((e) => e.id == _editingId);
                    if (index != -1) {
                      _items[index] = RandomizerItem(
                        id: _items[index].id,
                        name: name,
                        copiesNum: copiesNum,
                      );
                    }
                  }
                  _updateResultCount();
                });
              }

              Navigator.pop(context);
            },
            child: Text(
              _editingId == null && !saveForm ? 'Добавить' : 'Сохранить',
            ),
          ),
        ],
      ),
    );
  }

  // Удалить элемент
  void _deleteItem(String name) {
    setState(() {
      _items.removeWhere((e) => e.name == name);
      _updateResultCount();
      _showResult = false;
    });
  }

  // Изменить количество копий
  void _changeCopies(String name, int delta) {
    setState(() {
      final index = _items.indexWhere((e) => e.name == name);
      if (index != -1) {
        final newCopies = _items[index].copiesNum + delta;
        if (newCopies >= 1) {
          _items[index].copiesNum = newCopies;
          _updateResultCount();
        }
      }
    });
  }

  // Обновить количество выбираемых элементов
  void _updateResultCount() {
    final maxSelectable = _isUnique ? _items.length : _totalItems;
    if (_resultCount > maxSelectable) {
      _resultCount = maxSelectable;
    }
    if (_resultCount < 1 && maxSelectable > 0) {
      _resultCount = 1;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _totalItems;
    final maxSelectable = _isUnique ? _items.length : totalItems;

    if (_isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(randomIcon, color: silverColor),
            Icon(randomListIcon),
          ],
        ),
        actions: [
          if (_selectedRandomList != null)
            IconButton(icon: Icon(delIcon), onPressed: () => _deleteList()),

          if (_items.isNotEmpty) ...[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => setState(() {
                _items.clear();
                _selectedRandomList = null;
              }),
            ),

            IconButton(
              icon: Icon(saveIcon),
              onPressed: () {
                if (_selectedRandomList != null) {
                  _textController.text = _selectedRandomList!.name;
                } else {
                  _textController.clear();
                }

                _showModalDialog(saveForm: true);
              },
            ),
          ],

          IconButton(icon: Icon(addBtnIcon), onPressed: () => _addItem()),
        ],
      ),
      body: Column(
        children: [
          // Настройки
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (_items.isEmpty && _randomLists.isNotEmpty ||
                    _selectedRandomList != null)
                  SelectWithSearch<RandomList>(
                    label: 'Список',
                    getItems: () => getItemsForRandomListSelect(),
                    selectedItem: _selectedRandomList,
                    onSelectionChanged: (randomList) {
                      _onRandomListSelected(randomList);
                    },
                    displayName: (randomList) => randomList.name,
                    getId: (randomList) => randomList.id,
                    searchHint: 'Поиск игры...',
                    placeholder: 'Не выбрана',
                    customItemBuilder: (randomList) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          randomList.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                if (_items.isNotEmpty) ...[
                  // Уникальность
                  Row(
                    children: [
                      Checkbox(
                        value: _isUnique,
                        onChanged: (value) {
                          setState(() {
                            if (value != null && value) {
                              Set<String> pool = _getPool().toSet();
                              _pool = pool.toList();
                            } else {
                              _pool = _getPool();
                            }
                            _isUnique = value ?? false;
                            _updateResultCount();
                            _showResult = false;
                          });
                        },
                        activeColor: secondColor,
                      ),
                      Text('Уникальные элементы'),
                      Spacer(),
                      Text(
                        'Всего: $totalItems (💾 $_totalPoolItems)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Количество элементов
                  Row(
                    children: [
                      Text('Выбрать: '),
                      Expanded(
                        child: Slider(
                          value: _resultCount.toDouble(),
                          min: 1,
                          max: maxSelectable.toDouble(),
                          divisions: maxSelectable > 1
                              ? maxSelectable - 1
                              : null,
                          label: '$_resultCount',
                          onChanged: (value) {
                            setState(() {
                              _resultCount = value.toInt();
                              _showResult = false;
                            });
                          },
                          activeColor: secondColor,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$_resultCount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: goldColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  if (!_canSelect && _items.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Максимальное количество: $maxSelectable',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                ],
              ],
            ),
          ),

          // Список элементов
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Нет элементов',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          'Нажмите + чтобы добавить',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Dismissible(
                          key: Key(item.name),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            _deleteItem(item.name);
                          },
                          background: Container(
                            color: redColor,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Icon(delIcon, color: textColor),
                                SizedBox(width: 8),
                                Text('Удалить'),
                              ],
                            ),
                          ),
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: GestureDetector(
                                onTap: () => _editItem(item),
                                child: Text(
                                  item.name,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              subtitle: GestureDetector(
                                onTap: () => _editItem(item),
                                child: Text('Копий: ${item.copiesNum}'),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: item.copiesNum > 1
                                        ? () => _changeCopies(item.name, -1)
                                        : null,
                                    color: Colors.red.shade400,
                                    iconSize: 20,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () =>
                                        _changeCopies(item.name, 1),
                                    color: Colors.green.shade400,
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),

          // Результат
          if (_showResult && _result.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondColor,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🎯 Результат:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _showResult = false);
                        },
                        child: Text('Скрыть'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: _result.asMap().entries.map((entry) {
                      final index = entry.key;
                      final name = entry.value;
                      return Chip(
                        label: Text('${index + 1}. $name'),
                        avatar: CircleAvatar(
                          backgroundColor: goldColor,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: firstColor, fontSize: 12),
                          ),
                        ),
                        backgroundColor: firstColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Кнопка добавления
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondColor,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _canSelect ? _randomize : null,
                    icon: Icon(Icons.shuffle),
                    label: Text('Запуск'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      foregroundColor: firstColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (_totalPoolItems > 0)
                  IconButton(
                    onPressed: () => _randomize(fromPool: true),
                    icon: Icon(Icons.skip_next),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
