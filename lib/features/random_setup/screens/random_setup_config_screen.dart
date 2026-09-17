import 'dart:io';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class RandomSetupConfigFormScreen extends ConsumerStatefulWidget {
  final int gameId;
  final int? randomSetupId;

  const RandomSetupConfigFormScreen({
    super.key,
    required this.gameId,
    this.randomSetupId,
  });

  @override
  ConsumerState<RandomSetupConfigFormScreen> createState() =>
      _RandomSetupScreenState();
}

class _RandomSetupScreenState
    extends ConsumerState<RandomSetupConfigFormScreen> {
  RandomSetupData? _randomSetup;
  List<ComponentTypeData> _componentTypes = [];
  // Состояние для диалога выбора компонентов
  ComponentTypeData? _selectedTypeInDialog;
  // Контроллеры
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modalController1 = TextEditingController();
  final TextEditingController _modalController2 = TextEditingController();
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    if (widget.randomSetupId != null) {
      final RandomSetupDao randomSetupDao = ref.read(randomSetupDaoProvider);
      _randomSetup = await randomSetupDao.get(
        randomSetupId: widget.randomSetupId!,
      );
      _nameController.text = _randomSetup!.randomSetup.name;

      final ComponentTypeDao componentTypeDao = ref.read(
        componentTypeDaoProvider,
      );
      _componentTypes = await componentTypeDao.getAll(widget.gameId);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveSetup() async {
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Введите название сетапа');
      return;
    }

    late final int setupId;
    try {
      final RandomSetupDao randomSetupDao = ref.read(randomSetupDaoProvider);

      if (widget.randomSetupId == null) {
        setupId = await randomSetupDao.create(
          randomSetup: RandomSetupsCompanion(
            name: Value(name),
            gameId: Value(widget.gameId),
          ),
        );
      } else {
        await randomSetupDao.updInstance(
          randomSetupId: widget.randomSetupId!,
          randomSetup: RandomSetupsCompanion(
            name: Value(name),
            gameId: Value(widget.gameId),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _generalError = 'Запись уже существует';
        _isLoading = false;
      });
      return;
    }

    final notifier = ref.read(randomSetupPaginatedProvider.notifier);
    notifier.refresh();

    if (mounted && widget.randomSetupId == null) {
      Navigator.pop(context);

      context.pushNamed(
        'random-setups-setup-update',
        pathParameters: {
          'gameId': widget.gameId.toString(),
          'setupId': setupId.toString(),
        },
      );
    }

    _loadData();
  }

  Future<void> _saveRandomList(
    int? randomListId,
    RandomListsCompanion listCompanion,
    List<ListItemInputData> items,
  ) async {
    setState(() => _isLoading = true);

    try {
      final RandomListDao randomListDao = ref.read(randomListDaoProvider);

      if (randomListId == null) {
        await randomListDao.create(randomList: listCompanion, items: items);
      } else {
        await randomListDao.updInstance(
          randomListId: randomListId,
          randomList: listCompanion,
          items: items,
        );
      }
    } catch (e) {
      setState(() {
        _generalError = 'Запись уже существует';
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      Navigator.pop(context);
    }

    _loadData();
  }

  void _showListDialog({RandomListData? list}) {
    _modalController1.text = list?.randomList.name ?? '';
    _modalController2.text = list?.randomList.itemsNum.toString() ?? '1';
    bool isUnique = list?.randomList.isUnique ?? false;

    List<ListItemInputData> selected = [];
    if (list != null && list.items.isNotEmpty) {
      selected = list.items
          .map(
            (item) => ListItemInputData(
              component: item.component!,
              copiesNum: item.listItem.copiesNum,
            ),
          )
          .toList();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: firstColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Заголовок
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            list == null ? 'Новый список' : 'Редактирование',
                            style: const TextStyle(
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

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Название
                          TextField(
                            controller: _modalController1,
                            decoration: InputDecoration(
                              labelText: 'Название списка',
                              hintText: 'Например: Жетоны товаров',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.label_outline),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Количество
                          TextField(
                            controller: _modalController2,
                            decoration: InputDecoration(
                              labelText: 'Количество элементов',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.numbers),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Уникальность
                          CheckboxListTile(
                            value: isUnique,
                            onChanged: (v) {
                              setStateDialog(() => isUnique = v ?? false);
                            },
                            title: const Text('Уникальные компоненты'),
                            subtitle: const Text(
                              'Не выбирать один и тот же компонент дважды',
                            ),
                            activeColor: secondColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 16),

                          // Выбранные компоненты
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Выбранные компоненты:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${selected.length}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          if (selected.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: secondColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 40,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Нет выбранных компонентов',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: selected.map((component) {
                                return _buildSelectedComponentRow(
                                  component: component,
                                  onCopiesChanged: (delta) {
                                    setStateDialog(() {
                                      final newCopies =
                                          component.copiesNum + delta;
                                      component.copiesNum = newCopies < 0
                                          ? 0
                                          : newCopies;
                                      if (component.copiesNum == 0) {
                                        selected = selected
                                            .where((item) => item.copiesNum > 0)
                                            .toList();
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),

                          const SizedBox(height: 12),

                          // Кнопка выбора компонентов
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showComponentSelector(
                                initial: selected,
                                onSubmit: (list) {
                                  setStateDialog(() {
                                    selected = list
                                        .where((item) => item.copiesNum > 0)
                                        .toList();
                                  });
                                },
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Выбрать компоненты'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: borderColor,
                                side: const BorderSide(color: borderColor),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Кнопки
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (list != null)
                          TextButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Удалить'),
                          ),

                        const Spacer(),

                        ElevatedButton(
                          onPressed: () {
                            final name = _modalController1.text.trim();
                            final count =
                                int.tryParse(_modalController2.text) ?? 0;

                            if (name.isEmpty) {
                              _showError('Введите название');
                              return;
                            }
                            if (count < 1) {
                              _showError('Количество должно быть ≥ 1');
                              return;
                            }
                            if (selected.isEmpty) {
                              _showError('Выберите хотя бы один компонент');
                              return;
                            }
                            _saveRandomList(
                              list?.randomList.id,
                              RandomListsCompanion(
                                name: Value(name),
                                randomSetupId: Value(widget.randomSetupId),
                                gameId: Value(widget.gameId),
                                type: Value(RandomListTypeEnum.setup.id),
                                isUnique: Value(isUnique),
                                itemsNum: Value(count),
                              ),
                              selected,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldColor,
                            foregroundColor: firstColor,
                          ),
                          child: Text(list == null ? 'Добавить' : 'Сохранить'),
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

  Widget _buildSelectedComponentRow({
    required ListItemInputData component,
    required Function(int) onCopiesChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: secondColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (component.component!.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                File(component.component!.imagePath!),
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildMiniPlaceholder(),
              ),
            )
          else
            _buildMiniPlaceholder(),
          const SizedBox(width: 8),

          // ===== НАЗВАНИЕ =====
          Expanded(
            child: Text(
              component.component!.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ===== МИНУС =====
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            onPressed: component.copiesNum > 0
                ? () => onCopiesChanged(-1)
                : null,
            color: Colors.red.shade400,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),

          // ===== СЧЁТЧИК =====
          Container(
            width: 30,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: firstColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              '${component.copiesNum}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

          // ===== ПЛЮС =====
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            onPressed: () => onCopiesChanged(1),
            color: Colors.green.shade400,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPlaceholder() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 18,
        color: Colors.deepPurple,
      ),
    );
  }

  void _showComponentSelector({
    required List<ListItemInputData> initial,
    required Function(List<ListItemInputData>) onSubmit,
  }) {
    if (initial.isNotEmpty) {
      _selectedTypeInDialog = _componentTypes.firstWhere(
        (typeData) =>
            typeData.componentType.id == initial[0].component!.componentTypeId,
      );
    } else {
      _selectedTypeInDialog = _componentTypes.isNotEmpty
          ? _componentTypes.first
          : null;
    }

    final List<ListItemInputData> allComponents = [];

    List<ListItemInputData> selected = initial
        .map((item) => item.clone())
        .toList();

    void updateComponents() {
      allComponents.clear();

      if (_selectedTypeInDialog != null &&
          selected.isNotEmpty &&
          selected[0].component!.componentTypeId ==
              _selectedTypeInDialog!.componentType.id) {
        allComponents.addAll(selected);
      }

      Set<int> selectedIds = selected.map((item) => item.component!.id).toSet();
      for (final GameComponent component in _selectedTypeInDialog!.components) {
        if (!selectedIds.contains(component.id)) {
          allComponents.add(
            ListItemInputData(component: component, copiesNum: 0),
          );
        }
      }
    }

    updateComponents();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          final selectedList = allComponents
              .where((lid) => lid.copiesNum > 0)
              .toList();
          final totalCopies = selectedList.fold(
            0,
            (s, lid) => s + lid.copiesNum,
          );

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Компоненты',
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Выбрано: ${selectedList.length} (копий: $totalCopies)',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: textColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: secondColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ComponentTypeData>(
                          value: _selectedTypeInDialog,
                          isExpanded: true,
                          hint: const Text('Выберите тип'),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: textColor,
                          ),
                          items: _componentTypes.map((type) {
                            return DropdownMenuItem<ComponentTypeData>(
                              value: type,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(type.componentType.name),
                                  ),
                                  Text(
                                    '(${type.components.length})',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              _selectedTypeInDialog = value;
                              updateComponents();
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Сетка компонентов
                  Expanded(
                    child: allComponents.isEmpty
                        ? _buildEmptyComponents()
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount: allComponents.length,
                            itemBuilder: (context, index) {
                              final component = allComponents[index];

                              return _buildComponentTile(
                                item: component,
                                onChange: (newCopies) {
                                  setStateDialog(() {
                                    component.copiesNum = newCopies;
                                  });
                                },
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
                        TextButton(
                          onPressed: () {
                            setStateDialog(() {
                              for (var component in allComponents) {
                                component.copiesNum = 0;
                              }
                            });
                          },
                          child: const Text('Очистить'),
                        ),
                        TextButton(
                          onPressed: () {
                            setStateDialog(() {
                              for (var component in allComponents) {
                                if (component.copiesNum < 1) {
                                  component.copiesNum = 1;
                                }
                              }
                            });
                          },
                          child: const Text('Выбрать все'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            onSubmit(allComponents);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldColor,
                            foregroundColor: firstColor,
                          ),
                          child: const Text('ОК'),
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

  Widget _buildComponentTile({
    required ListItemInputData item,
    required Function(int) onChange,
  }) {
    final isSelected = item.copiesNum > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
          width: isSelected ? 3 : 1,
        ),
        color: isSelected ? Colors.deepPurple.shade50 : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepPurple.shade100
                  : Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: Text(
              item.component!.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.deepPurple : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => onChange(item.copiesNum + 1),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    child: item.component!.imagePath != null
                        ? Image.file(
                            File(item.component!.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  // Бейдж с количеством копий
                  if (item.copiesNum > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '×${item.copiesNum}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Минус
                InkWell(
                  onTap: item.copiesNum > 0
                      ? () => onChange(item.copiesNum - 1)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                      color: item.copiesNum > 0
                          ? (isSelected ? Colors.white : Colors.black87)
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
                // Количество
                Text(
                  '${item.copiesNum}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Плюс
                InkWell(
                  onTap: () => onChange(item.copiesNum + 1),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyComponents() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Нет компонентов этого типа',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите другой тип или добавьте компоненты',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 24,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCreationMode() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Создание сетапа',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Введите название, чтобы начать настройку',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          if (_generalError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _generalError!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Название сетапа',
              hintText: 'Например: Случайная партия',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveSetup,
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                foregroundColor: firstColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditingMode() {
    return Column(
      children: [
        // Название сетапа
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.title, color: textColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _randomSetup!.randomSetup.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
              ),
              Text(
                'всего: ${_randomSetup!.randomLists.length}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),

        if (_generalError != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _generalError!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: 7),

        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Название сетапа',
            hintText: 'Например: Случайная раскладка',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.title),
          ),
        ),

        // Список рандомных списков
        Expanded(
          child: _randomSetup!.randomLists.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _randomSetup!.randomLists.length,
                  itemBuilder: (context, index) {
                    return _buildListCard(_randomSetup!.randomLists[index]);
                  },
                ),
        ),

        // Кнопка добавления
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: secondColor,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showListDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Добавить список компонентов'),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                foregroundColor: firstColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(RandomListData list) {
    final selectedComponents = list.items
        .where((item) => item.listItem.copiesNum > 0)
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showListDialog(list: list),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      list.randomList.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Выбрать N
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: firstColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Выбрать ${list.randomList.itemsNum}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (selectedComponents.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Нет компонентов',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedComponents.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final sc = selectedComponents[index];
                      return _buildComponentThumbnail(sc);
                    },
                  ),
                ),

              const SizedBox(height: 8),

              Row(
                children: [
                  // Количество компонентов
                  Icon(Icons.widgets_outlined, size: 14, color: textColor),
                  const SizedBox(width: 4),
                  Text(
                    '${selectedComponents.length} комп.',
                    style: TextStyle(fontSize: 11, color: textColor),
                  ),

                  const SizedBox(width: 12),

                  if (list.randomList.isUnique)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 11,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Уникальные',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Иконка редактирования
                  Icon(Icons.edit_outlined, size: 16, color: textColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComponentThumbnail(ListItemData sc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Изображение с бейджем количества
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: sc.component!.imagePath != null
                    ? Image.file(
                        File(sc.component!.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildMiniPlaceholder(),
                      )
                    : _buildMiniPlaceholder(),
              ),
            ),
            // Бейдж с количеством копий
            if (sc.listItem.copiesNum > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  child: Text(
                    '${sc.listItem.copiesNum}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        // Название компонента (обрезанное)
        SizedBox(
          width: 52,
          child: Text(
            sc.component!.name,
            style: TextStyle(fontSize: 9, color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shuffle, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Нет рандомных списков',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавьте список, чтобы настроить генерацию',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _modalController1.dispose();
    _modalController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.randomSetupId == null ? 'Новый сетап' : 'Настройка сетапа',
        ),
        actions: [
          if (widget.randomSetupId != null) ...[
            if (_randomSetup!.randomLists.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Запустить генерацию',
                onPressed: () {
                  // Переход на экран генерации
                  // Navigator.push(...);
                },
              ),

            IconButton(onPressed: _saveSetup, icon: Icon(saveIcon)),
          ],
        ],
      ),
      body: widget.randomSetupId == null
          ? _buildCreationMode()
          : _buildEditingMode(),
    );
  }
}
