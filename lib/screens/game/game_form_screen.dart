import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/widgets/multiple_select_with_search.dart';
import 'package:bg_tools/core/widgets/select_with_search.dart';

class GamesFormScreen extends ConsumerStatefulWidget {
  final int? gameId;
  
  const GamesFormScreen({super.key, this.gameId});

  @override
  ConsumerState<GamesFormScreen> createState() => _GamesFormScreenState();
}

class _GamesFormScreenState extends ConsumerState<GamesFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late final GameFullData? gameData;
  // Локальное состояние формы
  bool _isInCollection = false;
  Game? _selectedBase;
  Set<int> _selectedDesignersIds = {};
  Set<int> _selectedArtistsIds = {};
  Set<int> _selectedTagsIds = {};
  // Контроллеры
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _yearController;
  late final TextEditingController _minPlayersController;
  late final TextEditingController _maxPlayersController;
  // Список наставников
  List<Game> _baseGames = [];
  List<Designer> _designers = [];
  List<Artist> _artists = [];
  List<Tag> _tags = [];
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final GameDao gameDao = ref.read(gameDaoProvider);
    final List<Game> games = await gameDao.getAllBase();
    final List<Designer> designers;
    final List<Artist> artists;
    final List<Tag> tags;

    if (widget.gameId == null) {
      final designerDao = ref.read(designerDaoProvider);
      designers = await designerDao.getAll();

      final artistDao = ref.read(artistDaoProvider);
      artists = await artistDao.getAll();

      final tagDao = ref.read(tagDaoProvider);
      tags = await tagDao.getAll();
      gameData = null;
    } else {
      gameData = await gameDao.getFullInfo(widget.gameId!);
      designers = gameData!.designers;
      artists = gameData!.artists;
      tags = gameData!.tags;

      _selectedBase = gameData!.baseGame;
      _isInCollection = gameData!.game.isInCollection;
      _selectedDesignersIds = gameData!.selectedDesignerIds;
      _selectedArtistsIds = gameData!.selectedArtistIds;
      _selectedTagsIds = gameData!.selectedTagIds;
    }

    _titleController = TextEditingController(text: gameData?.game.name);
    _descriptionController = TextEditingController(text: gameData?.game.description);
    _yearController = TextEditingController(text: gameData?.game.year);
    _minPlayersController = TextEditingController(text: gameData?.game.minPlayers?.toString());
    _maxPlayersController = TextEditingController(text: gameData?.game.maxPlayers?.toString());
    
    _baseGames = games;
    _designers = designers;
    _artists = artists;
    _tags = tags;
    setState(() => _isLoading = false);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final gameDao = ref.read(gameDaoProvider);

      try {
        final GamesCompanion gameComp = GamesCompanion(
          name: Value(_titleController.text),
          description: Value(_descriptionController.text),
          year: Value(_yearController.text.isEmpty ? null : _yearController.text),
          minPlayers: Value(_minPlayersController.text.trim().isEmpty
            ? null
            : int.tryParse(_minPlayersController.text.trim())),
          maxPlayers: Value(_maxPlayersController.text.trim().isEmpty
            ? null
            : int.tryParse(_maxPlayersController.text.trim())),
          parentId: Value(_selectedBase?.id),
          isInCollection: Value(_isInCollection),
        );
        if (widget.gameId == null) {
          await gameDao.create(
            gameComp,
            _selectedDesignersIds,
            _selectedArtistsIds,
            _selectedTagsIds
          );
        } else {
          await gameDao.updInstance(
            widget.gameId!,
            gameComp,
            _selectedDesignersIds,
            _selectedArtistsIds,
            _selectedTagsIds
          );
        }

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.gameId == null ? 'Игра добавлена' : 'Изменения сохранены')),
          );
        }

         _formKey.currentState!.save();      
      } catch (e) {
        setState(() {
          _generalError = 'Запись уже существует';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.gameId == null ? 'Новая настольная игра': 'Редактирование игры'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Кидаем кубы...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.gameId == null ? 'Новая настольная игра': 'Редактирование игры')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              if (_generalError != null) Container(
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
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Название *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Год',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (RegExp(r'^-?\d+$').hasMatch(value)) {
                    return null;
                  }
                  return 'Некорректный год';
                },
              ),
              TextFormField(
                controller: _minPlayersController,
                decoration: InputDecoration(
                  labelText: 'Минимальное количество игроков',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,  // Цифровая клавиатура
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,  // Только цифры
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final num = int.tryParse(value);
                    if (num == null) return 'Некорректное число';
                    if (num < 1) return 'Должно быть не меньше 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxPlayersController,
                decoration: InputDecoration(
                  labelText: 'Максимальное количество игроков',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,  // Цифровая клавиатура
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,  // Только цифры
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final num = int.tryParse(value);
                    if (num == null) return 'Некорректное число';
                    if (num < 1) return 'Должно быть не меньше 1';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('Наличие в коллекции'),
                value: _isInCollection,
                onChanged: (value) {
                  setState(() {
                    _isInCollection = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SelectWithSearch<Game>(
                label: 'Базовая игра',
                items: _baseGames,
                selectedItem: _selectedBase,
                onSelectionChanged: (baseGame) {
                  setState(() {
                    _selectedBase = baseGame;
                  });
                },
                displayName: (baseGame) => baseGame.name,
                getId: (baseGame) => baseGame.id,
                searchHint: 'Поиск игры...',
                placeholder: 'Не выбрана',
                customItemBuilder: (baseGame) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baseGame.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              MultiSelectWithSearch<Designer>(
                label: 'Геймдизайнеры',
                items: _designers,
                selectedIds: _selectedDesignersIds,
                onSelectionChanged: (newSelected) {
                  setState(() {
                    _selectedDesignersIds = newSelected;
                  });
                },
                displayName: (designer) => designer.name,
                getId: (designer) => designer.id,
                searchHint: 'Поиск геймдизайнеров...',
                customItemBuilder: (designer) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      designer.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              MultiSelectWithSearch<Artist>(
                label: 'Художники',
                items: _artists,
                selectedIds: _selectedArtistsIds,
                onSelectionChanged: (newSelected) {
                  setState(() {
                    _selectedArtistsIds = newSelected;
                  });
                },
                displayName: (artist) => artist.name,
                getId: (artist) => artist.id,
                searchHint: 'Поиск художника...',
                customItemBuilder: (artist) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              MultiSelectWithSearch<Tag>(
                label: 'Метки категорий',
                items: _tags,
                selectedIds: _selectedTagsIds,
                onSelectionChanged: (newSelected) {
                  setState(() {
                    _selectedTagsIds = newSelected;
                  });
                },
                displayName: (tag) => tag.name,
                getId: (tag) => tag.id,
                searchHint: 'Поиск тэгов...',
                customItemBuilder: (tag) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
