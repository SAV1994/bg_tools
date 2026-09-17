import 'dart:io';

import 'package:flutter/material.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/services/image_service.dart';
import 'package:bg_tools/core/widgets/export.dart';

class ComponentsScreen extends ConsumerStatefulWidget {
  final int gameId;

  const ComponentsScreen({super.key, required this.gameId});

  @override
  ConsumerState<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends ConsumerState<ComponentsScreen> {
  late final Game? _game;
  // Типы компонентов
  List<ComponentTypeData> _types = [];
  ComponentTypeData? _selectedType;
  List<GameComponent> _components = [];
  // Контроллеры
  final TextEditingController _modalController = TextEditingController();
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final GameDao gameDao = ref.read(gameDaoProvider);
    _game = await gameDao.getSingle(widget.gameId);
    _updatedata();
  }

  Future<void> _updatedata() async {
    setState(() => _isLoading = true);

    final ComponentTypeDao componentTypeDao = ref.read(
      componentTypeDaoProvider,
    );
    final List<ComponentTypeData> types = await componentTypeDao.getAll(
      widget.gameId,
    );

    final List<GameComponent> components = [];
    ComponentTypeData? selectedType;
    if (types.isNotEmpty) {
      selectedType = _selectedType == null
          ? types[0]
          : types.firstWhere(
              (type) =>
                  type.componentType.id == _selectedType!.componentType.id,
            );

      components.addAll(selectedType.components);
    }

    setState(() {
      _selectedType = selectedType;
      _types = types;
      _components = components;
      _isLoading = false;
    });
  }

  Future<void> _selectType(ComponentTypeData? componentTypeData) async {
    setState(() => _isLoading = true);

    late List<GameComponent> components;
    if (componentTypeData == null) {
      components = [];
    } else {
      components = componentTypeData.components;
    }

    setState(() {
      _selectedType = componentTypeData;
      _components = components;
      _isLoading = false;
    });
  }

  Future<void> _addComponentType() async {
    final ComponentTypeDao componentTypeDao = ref.read(
      componentTypeDaoProvider,
    );
    await componentTypeDao.create(
      componentType: ComponentTypesCompanion(
        name: Value(_modalController.text),
        gameId: Value(widget.gameId),
      ),
    );

    _modalController.clear();

    _updatedata();
  }

  Future<void> _updateComponentType(ComponentTypeData componentTypeData) async {
    final ComponentTypeDao componentTypeDao = ref.read(
      componentTypeDaoProvider,
    );
    await componentTypeDao.updInstance(
      componentTypeId: componentTypeData.componentType.id,
      componentType: ComponentTypesCompanion(
        name: Value(_modalController.text),
        gameId: Value(widget.gameId),
      ),
    );

    _modalController.clear();

    _updatedata();
  }

  Future<void> _delComponentType() async {
    final ComponentTypeDao componentTypeDao = ref.read(
      componentTypeDaoProvider,
    );
    await componentTypeDao.delInstance(
      componentTypeId: _selectedType!.componentType.id,
    );
    _selectedType = null;

    _updatedata();
  }

  Future<void> _addComponent(String? imagePath) async {
    final ComponentDao componentDao = ref.read(componentDaoProvider);
    await componentDao.create(
      component: GameComponentsCompanion(
        name: Value(_modalController.text),
        componentTypeId: Value(_selectedType!.componentType.id),
        imagePath: Value(imagePath),
      ),
    );

    _modalController.clear();

    _updatedata();
  }

  Future<void> _updateComponent(GameComponent type, String? imagePath) async {
    final ComponentDao componentDao = ref.read(componentDaoProvider);
    await componentDao.updInstance(
      componentId: type.id,
      component: GameComponentsCompanion(
        name: Value(_modalController.text),
        componentTypeId: Value(_selectedType!.componentType.id),
        imagePath: Value(imagePath),
      ),
    );

    _modalController.clear();

    _updatedata();
  }

  Future<void> _delComponent(GameComponent component) async {
    setState(() => _isLoading = true);

    final ComponentDao componentDao = ref.read(componentDaoProvider);
    await componentDao.delInstance(component.id);

    _updatedata();
  }

  void _showTypeDialog({ComponentTypeData? componentTypeData}) {
    if (_selectedType == null) {
      _modalController.clear();
    } else {
      _modalController.text = _selectedType!.componentType.name;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(componentTypeData == null ? 'Новый тип' : 'Редактировать тип'),
            Spacer(),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: textColor),
            ),
          ],
        ),
        content: TextField(
          controller: _modalController,
          decoration: InputDecoration(
            labelText: 'Название типа',
            hintText: 'Например: Жетоны угрозы',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          autofocus: true,
        ),
        actions: [
          Row(
            children: [
              Spacer(),

              ElevatedButton(
                onPressed: () {
                  final name = _modalController.text.trim();
                  if (name.isEmpty) {
                    _showError('Введите название');
                    return;
                  }

                  if (_selectedType == null &&
                      _types.any((type) => type.componentType.name == name)) {
                    _showError('Название должно быть уникальным');
                    return;
                  }

                  Navigator.pop(context);

                  setState(() {
                    if (componentTypeData == null) {
                      _addComponentType();
                    } else {
                      _updateComponentType(componentTypeData);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  componentTypeData == null ? 'Создать' : 'Сохранить',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteType() {
    if (_selectedType == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить тип?'),
        content: Text(
          'Все компоненты типа "${_selectedType!.componentType.name}" будут удалены.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              _delComponentType();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showComponentDialog({GameComponent? component}) {
    if (_selectedType == null) return;

    if (component == null) {
      _modalController.clear();
    } else {
      _modalController.text = component.name;
    }

    bool isSaved = false;
    String? imagePath = component?.imagePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (imagePath != null && component == null && !isSaved) {
                ImageService.deleteImage(imagePath);
              }
            },
            child: AlertDialog(
              title: Row(
                children: [
                  Text(component == null ? 'Новый компонент' : 'Редактировать'),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: textColor),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImagePickerWidget(
                      initialImagePath: imagePath,
                      onImageSelected: (path) {
                        setState(() => imagePath = path);
                      },
                      fieldName: 'Изображение компонента',
                      imageType: ImageEnum.component,
                    ),

                    TextField(
                      controller: _modalController,
                      decoration: InputDecoration(
                        labelText: 'Название',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      autofocus: true,
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    if (component != null)
                      IconButton(
                        onPressed: () {
                          _delComponent(component);
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        icon: Icon(delIcon),
                      ),

                    Spacer(),

                    ElevatedButton(
                      onPressed: () {
                        final name = _modalController.text.trim();
                        if (name.isEmpty) {
                          _showError('Введите название');
                          return;
                        }

                        if (component == null &&
                            _components.any(
                              (component) => component.name == name,
                            )) {
                          _showError('Название должно быть уникальным');
                          return;
                        }

                        isSaved = true;

                        setState(() {
                          if (component == null) {
                            _addComponent(imagePath);
                          } else {
                            _updateComponent(component, imagePath);
                          }
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        foregroundColor: firstColor,
                      ),
                      child: Text(component == null ? 'Добавить' : 'Сохранить'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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

  Widget _buildComponentTile(GameComponent component) {
    return GestureDetector(
      onTap: () => _showComponentDialog(component: component),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Название
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                component.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Изображение
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: component.imagePath != null
                    ? Image.file(
                        File(component.imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: secondColor, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: firstColor,
      ),
      child: Center(
        child: Icon(Icons.image_outlined, size: 40, color: secondColor),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _modalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Tooltip(
          message: _game!.name,
          child: const Icon(componentsIcon, size: 25),
        ),
        actions: [
          if (_selectedType != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  _showTypeDialog(componentTypeData: _selectedType),
              tooltip: 'Редактировать тип',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteType,
              tooltip: 'Удалить тип',
            ),
            IconButton(
              icon: const Icon(Icons.add, color: goldColor),
              onPressed: () => _showComponentDialog(),
              tooltip: 'Добавить компонент',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.deepPurple.shade100),
              ),
            ),
            child: Row(
              children: [
                // Селект типа
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ComponentTypeData?>(
                        value: _selectedType,
                        isExpanded: true,
                        hint: const Text('Выберите тип компонентов'),
                        icon: const Icon(Icons.arrow_drop_down),
                        items: [
                          ..._types.map((componentTypeData) {
                            final count = componentTypeData.components.length;
                            return DropdownMenuItem<ComponentTypeData>(
                              value: componentTypeData,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      componentTypeData.componentType.name,
                                    ),
                                  ),
                                  Text(
                                    '($count)',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) => _selectType(value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Кнопка добавления типа
                IconButton(
                  onPressed: () => _showTypeDialog(),
                  icon: const Icon(Icons.add_circle),
                  color: goldColor,
                  iconSize: 32,
                  tooltip: 'Добавить тип',
                ),
              ],
            ),
          ),

          Expanded(
            child: _selectedType == null
                ? _buildEmptyState(
                    'Выберите тип компонентов',
                    'Компоненты появятся после выбора типа',
                    Icons.category_outlined,
                  )
                : _components.isEmpty
                ? _buildEmptyState(
                    'Нет компонентов',
                    'Нажмите + чтобы добавить компонент',
                    Icons.inbox_outlined,
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: _components.length,
                    itemBuilder: (context, index) {
                      final component = _components[index];
                      return _buildComponentTile(component);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
