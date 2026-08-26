import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/game/game_dao.dart';
import 'package:bg_tools/core/dataclasses/game_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/services/image_service.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/export_import_service/services/game_mover.dart';
import 'package:bg_tools/features/export_import_service/utils/export.dart';
import 'package:bg_tools/screens/game/widgets/export.dart';
import 'package:bg_tools/screens/generic/list_with_modal_form.dart';

class GamesFormScreen extends ConsumerStatefulWidget {
  final int? gameId;
  final int? baseGameId;

  const GamesFormScreen({super.key, this.gameId, this.baseGameId});

  @override
  ConsumerState<GamesFormScreen> createState() => _GamesFormScreenState();
}

class _GamesFormScreenState extends ConsumerState<GamesFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final GameFullData? gameData;
  // Локальное состояние формы
  bool _isInCollection = false;
  bool _isStandalone = true;
  Set<int> _selectedBaseIds = {};
  Set<int> _selectedDesignerIds = {};
  Set<int> _selectedArtistIds = {};
  Set<int> _selectedTagIds = {};
  String? _imagePath;
  double _rating = 0.0;
  // Контроллеры
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _yearController;
  late final TextEditingController _minPlayersController;
  late final TextEditingController _maxPlayersController;
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

    final GameDao gameDao = ref.read(gameDaoProvider);

    if (widget.gameId == null) {
      gameData = null;
      if (widget.baseGameId != null) {
        _selectedBaseIds.add(widget.baseGameId!);
      }
    } else {
      gameData = await gameDao.getFullInfo(widget.gameId!);

      _imagePath = gameData!.game.imagePath;
      _isInCollection = gameData!.game.isInCollection;
      _selectedBaseIds = gameData!.selectedBaseIds;
      _selectedDesignerIds = gameData!.selectedDesignerIds;
      _selectedArtistIds = gameData!.selectedArtistIds;
      _selectedTagIds = gameData!.selectedTagIds;
      _isStandalone = gameData!.game.isStandalone;
      _rating = gameData!.game.rating ?? _rating;
    }

    _titleController = TextEditingController(text: gameData?.game.name);
    _descriptionController = TextEditingController(
      text: gameData?.game.description,
    );
    _yearController = TextEditingController(text: gameData?.game.year);
    _minPlayersController = TextEditingController(
      text: gameData?.game.minPlayers?.toString(),
    );
    _maxPlayersController = TextEditingController(
      text: gameData?.game.maxPlayers?.toString(),
    );

    setState(() => _isLoading = false);
  }

  Future<List<Game>> getItemsForForBaseGamesSelect() async {
    final GameDao gameDao = ref.read(gameDaoProvider);
    if (widget.gameId != null) {
      return await gameDao.getAllExceptSelected([widget.gameId!]);
    } else {
      return await gameDao.getStandalones();
    }
  }

  Future<List<Designer>> getItemsForForDesignersSelect() async {
    final designerDao = ref.read(designerDaoProvider);
    return await designerDao.getAll();
  }

  Future<List<Artist>> getItemsForForArtistsSelect() async {
    final artistDao = ref.read(artistDaoProvider);
    return await artistDao.getAll();
  }

  Future<List<Tag>> getItemsForForTagsSelect() async {
    final tagDao = ref.read(tagDaoProvider);
    return await tagDao.getAll();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final gameDao = ref.read(gameDaoProvider);

      try {
        final GamesCompanion gameComp = GamesCompanion(
          name: Value(_titleController.text),
          description: Value(_descriptionController.text),
          year: Value(
            _yearController.text.isEmpty ? null : _yearController.text,
          ),
          minPlayers: Value(
            _minPlayersController.text.trim().isEmpty
                ? null
                : int.tryParse(_minPlayersController.text.trim()),
          ),
          maxPlayers: Value(
            _maxPlayersController.text.trim().isEmpty
                ? null
                : int.tryParse(_maxPlayersController.text.trim()),
          ),
          isInCollection: Value(_isInCollection),
          rating: Value(_rating),
          imagePath: Value(_imagePath),
          isStandalone: Value(_isStandalone),
        );
        if (widget.gameId == null) {
          await gameDao.create(
            gameComp,
            _selectedBaseIds,
            _selectedDesignerIds,
            _selectedArtistIds,
            _selectedTagIds,
          );
        } else {
          await gameDao.updInstance(
            widget.gameId!,
            gameComp,
            _selectedBaseIds,
            _selectedDesignerIds,
            _selectedArtistIds,
            _selectedTagIds,
          );
        }

        ref.invalidate(gameFullDataProvider);
        ref.read(gamesPaginatedProvider.notifier).refresh();
        ref.read(ratingsGamesPaginatedProvider.notifier).refresh();

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.gameId == null
                    ? 'Игра добавлена'
                    : 'Изменения сохранены',
              ),
            ),
          );
        }

        _formKey.currentState!.save();
      } catch (e) {
        setState(() => _generalError = 'Запись уже существует');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    _yearController.dispose();
    _minPlayersController.dispose();
    _maxPlayersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (widget.gameId == null && _imagePath != null) {
          ImageService.deleteImage(_imagePath);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Icon(
            gamesIcon,
            color: widget.gameId == null ? bronzeColor : blueColor,
          ),
          actions: [
            if (widget.gameId == null)
              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                icon: Icon(importIcon),
                onPressed: () => importData(
                  context: context,
                  mover: GameMover(),
                  onSuccess: () {
                    // Обновляем провайдеры
                    ref.invalidate(countingTemplateDataProvider);
                    ref.invalidate(gameFullDataProvider);
                    // AsyncNotifierProvider
                    final countingTemplatesNotifier = ref.read(
                      countingTemplatesPaginatedProvider.notifier,
                    );
                    countingTemplatesNotifier.refresh();
                    final gamesNotifier = ref.read(
                      gamesPaginatedProvider.notifier,
                    );
                    gamesNotifier.refresh();
                    final gamesCountingTemplatesNotifier = ref.read(
                      gamesCountingTemplatesPaginatedProvider.notifier,
                    );
                    gamesCountingTemplatesNotifier.refresh();
                  },
                  warnStr:
                      'Импорт добавит игру.\n'
                      'Возможны дубликаты шаблонов, если игра у Вас уже есть.\n'
                      'Вы уверены, что хотите продолжить?',
                ),
              ),
          ],
        ),
        body: _isLoading
            ? LoadingScreen()
            : Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 16,
                      children: [
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
                                Icon(
                                  Icons.error,
                                  color: Colors.red.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _generalError!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                    ),
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
                        ImagePickerWidget(
                          initialImagePath: _imagePath,
                          onImageSelected: (path) {
                            setState(() => _imagePath = path);
                          },
                          fieldName: 'Изображение с игрой',
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
                          keyboardType:
                              TextInputType.number, // Цифровая клавиатура
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Только цифры
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
                          keyboardType:
                              TextInputType.number, // Цифровая клавиатура
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Только цифры
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
                            setState(() => _isInCollection = value!);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        RatingSlider(
                          initialValue: _rating,
                          onChanged: (value) {
                            setState(() => _rating = value);
                          },
                        ),
                        Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: false,
                          interactive: false,
                          child: TextFormField(
                            controller: _descriptionController,
                            scrollController: _scrollController,
                            decoration: InputDecoration(
                              labelText: 'Описание',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                          ),
                        ),
                        MultiSelectWithSearch<Game>(
                          label: 'Базовая игра',
                          getItems: () => getItemsForForBaseGamesSelect(),
                          selectedIds: _selectedBaseIds,
                          onSelectionChanged: (newSelected) {
                            setState(() => _selectedBaseIds = newSelected);
                          },
                          displayName: (baseGame) => baseGame.name,
                          getId: (baseGame) => baseGame.id,
                          searchHint: 'Поиск игр...',
                          customItemBuilder: (baseGame) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                baseGame.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_selectedBaseIds.isNotEmpty)
                          CheckboxListTile(
                            title: Text('Самодостаточность'),
                            value: _isStandalone,
                            onChanged: (value) {
                              setState(() => _isStandalone = value!);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        MultiSelectWithSearch<Designer>(
                          label: 'Геймдизайнеры',
                          getItems: () => getItemsForForDesignersSelect(),
                          selectedIds: _selectedDesignerIds,
                          onSelectionChanged: (newSelected) {
                            setState(() => _selectedDesignerIds = newSelected);
                          },
                          displayName: (designer) => designer.name,
                          getId: (designer) => designer.id,
                          searchHint: 'Поиск геймдизайнеров...',
                          customItemBuilder: (designer) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                designer.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          configForModal: ModalFormConfig(
                            dataProvider: designersPaginatedProvider,
                            daoProvier: designerDaoProvider,
                            companionFactory: (name) =>
                                DesignersCompanion(name: Value(name)),
                            imputName: 'Геймдизайнер *',
                          ),
                        ),
                        MultiSelectWithSearch<Artist>(
                          label: 'Художники',
                          getItems: () => getItemsForForArtistsSelect(),
                          selectedIds: _selectedArtistIds,
                          onSelectionChanged: (newSelected) {
                            setState(() => _selectedArtistIds = newSelected);
                          },
                          displayName: (artist) => artist.name,
                          getId: (artist) => artist.id,
                          searchHint: 'Поиск художника...',
                          customItemBuilder: (artist) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artist.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          configForModal: ModalFormConfig(
                            dataProvider: artistsPaginatedProvider,
                            daoProvier: artistDaoProvider,
                            companionFactory: (name) =>
                                ArtistsCompanion(name: Value(name)),
                            imputName: 'Художник *',
                          ),
                        ),
                        MultiSelectWithSearch<Tag>(
                          label: 'Метки категорий',
                          getItems: () => getItemsForForTagsSelect(),
                          selectedIds: _selectedTagIds,
                          onSelectionChanged: (newSelected) {
                            setState(() => _selectedTagIds = newSelected);
                          },
                          displayName: (tag) => tag.name,
                          getId: (tag) => tag.id,
                          searchHint: 'Поиск тэгов...',
                          customItemBuilder: (tag) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tag.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          configForModal: ModalFormConfig(
                            dataProvider: tagsPaginatedProvider,
                            daoProvier: tagDaoProvider,
                            companionFactory: (name) =>
                                TagsCompanion(name: Value(name)),
                            imputName: 'Метка категории *',
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
              ),
      ),
    );
  }
}
