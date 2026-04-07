import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// import 'package:go_router/go_router.dart';

class GamesAddScreen extends ConsumerStatefulWidget {
  const GamesAddScreen({super.key});

  @override
  ConsumerState<GamesAddScreen> createState() => _GamesAddScreenState();
}

class _GamesAddScreenState extends ConsumerState<GamesAddScreen> {
  final _formKey = GlobalKey<FormState>();
  // Локальное состояние формы
  bool _isInCollection = false;
  int? _selectedBaseId;
  // Контроллеры
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _minPlayersController = TextEditingController();
  final TextEditingController _maxPlayersController = TextEditingController();
  // Список наставников
  List<Game> _baseGames = [];
  bool _isLoadingBaseGames = false;

  @override
  void initState() {
    super.initState();
    _loadBaseGames();
  }

  Future<void> _loadBaseGames() async {
    setState(() => _isLoadingBaseGames = true);
    
    final gameDao = ref.read(gameDaoProvider);
    final games = await gameDao.getAllBase();
    
    setState(() {
      _baseGames = games;
      _isLoadingBaseGames = false;
    });
  }
  
  Future<void> _save() async {
    final gameDao = ref.read(gameDaoProvider);

    await gameDao.create(GamesCompanion.insert(
      title: _titleController.text,
      description: Value(_descriptionController.text),
      year: Value(_yearController.text),
      minPlayers: Value(_minPlayersController.text.trim().isEmpty
            ? null
            : int.tryParse(_minPlayersController.text.trim())),
      maxPlayers: Value(_maxPlayersController.text.trim().isEmpty
            ? null
            : int.tryParse(_maxPlayersController.text.trim())),
      parentId: Value(_selectedBaseId),
      isInCollection: Value(_isInCollection),
    ));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _save();
      
      // Показать SnackBar об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Игра добавлена!')),
      );
      
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расширенная форма')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
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
                  if (value.length < 2) {
                    return 'Имя должно содержать минимум 2 символа';
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
              if (_isLoadingBaseGames)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Базовая игра',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.layers),
                    ),
                    initialValue: _selectedBaseId,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('-- Не выбран --'),
                      ),
                      ..._baseGames.map((game) {
                        return DropdownMenuItem(
                          value: game.id,
                          child: Text(
                            game.title,
                            // style: TextStyle(
                            //   fontWeight: game.id == widget.designer?.id
                            //       ? FontWeight.bold
                            //       : FontWeight.normal,
                            // ),
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedBaseId = value);
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
