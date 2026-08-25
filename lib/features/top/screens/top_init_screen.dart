import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/services/top_data_initializer.dart';

class TopInitScreen extends ConsumerStatefulWidget {
  const TopInitScreen({super.key});

  @override
  ConsumerState<TopInitScreen> createState() => _TopInitScreenState();
}

class _TopInitScreenState extends ConsumerState<TopInitScreen> {
  late int _selectedYear = DateTime.now().year;
  late int _selectedMonth = DateTime.now().month;
  Tag? _selectedTag;
  Designer? _selectedDesigner;
  Artist? _selectedArtist;
  TopEngineEnum _selectedTopEngine = TopEngineEnum.branchAndBound;
  int _totalGames = 0;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _countGames();
  }

  Future<void> _countGames() async {
    setState(() => _isLoading = true);

    final gameDao = ref.read(gameDaoProvider);
    final int totalGames = await gameDao.getTotalCount(
      onlyStandalone: true,
      tagId: _selectedTag?.id,
      artistId: _selectedArtist?.id,
      designerId: _selectedDesigner?.id,
    );

    setState(() {
      _totalGames = totalGames;
      _isLoading = false;
    });
  }

  Future<List<Tag>> _getItemsForTagSelect() async {
    final tagDao = ref.read(tagDaoProvider);
    return await tagDao.getAll();
  }

  Future<List<Designer>> _getItemsForDesignerSelect() async {
    final designerDao = ref.read(designerDaoProvider);
    return await designerDao.getAll();
  }

  Future<List<Artist>> _getItemsForArtistSelect() async {
    final artistDao = ref.read(artistDaoProvider);
    return await artistDao.getAll();
  }

  Future<void> _startRanking() async {
    if (_totalGames > 1) {
      setState(() => _isLoading = true);

      final gameDao = ref.read(gameDaoProvider);
      await TopDataInitializer(
        engine: _selectedTopEngine,
        year: _selectedYear,
        month: _selectedMonth,
        gameDao: gameDao,
        tagId: _selectedTag?.id,
        designerId: _selectedDesigner?.id,
        artistId: _selectedArtist?.id,
      ).init();

      if (mounted) {
        Navigator.pop(context);
        context.pushNamed('top-process');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Недостаточно игр для ранжирования')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Icon(topsIcon, color: bronzeColor)),
      body: _isLoading
          ? LoadingScreen()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Всего будет проранжировано игр: $_totalGames',
                    style: TextStyle(color: goldColor, fontSize: 17),
                  ),

                  if (_selectedDesigner == null && _selectedArtist == null)
                    SelectWithSearch<Tag>(
                      label: 'Тэг категории',
                      getItems: () => _getItemsForTagSelect(),
                      selectedItem: _selectedTag,
                      onSelectionChanged: (tag) {
                        _selectedTag = tag;
                        _countGames();
                      },
                      displayName: (tag) => tag.name,
                      getId: (tag) => tag.id,
                      searchHint: 'Поиск тэга...',
                      placeholder: 'Не выбран',
                    ),

                  if (_selectedTag == null && _selectedArtist == null)
                    SelectWithSearch<Designer>(
                      label: 'Геймдизайнер',
                      getItems: () => _getItemsForDesignerSelect(),
                      selectedItem: _selectedDesigner,
                      onSelectionChanged: (designer) {
                        _selectedDesigner = designer;
                        _countGames();
                      },
                      displayName: (designer) => designer.name,
                      getId: (designer) => designer.id,
                      searchHint: 'Поиск геймдизайнера...',
                      placeholder: 'Не выбран',
                    ),

                  if (_selectedTag == null && _selectedDesigner == null)
                    SelectWithSearch<Artist>(
                      label: 'Художник',
                      getItems: () => _getItemsForArtistSelect(),
                      selectedItem: _selectedArtist,
                      onSelectionChanged: (artist) {
                        _selectedArtist = artist;
                        _countGames();
                      },
                      displayName: (artist) => artist.name,
                      getId: (artist) => artist.id,
                      searchHint: 'Поиск художника...',
                      placeholder: 'Не выбран',
                    ),

                  EnumSelector(
                    label: TopEngineEnum.title,
                    required: true,
                    choices: TopEngineEnum.getDropdownMenuItems(),
                    selected: _selectedTopEngine,
                    onChanged: (value) => setState(
                      () => _selectedTopEngine = value as TopEngineEnum,
                    ),
                  ),

                  YearInput(
                    onChanged: (year) => _selectedYear = year,
                    initialYear: _selectedYear,
                  ),

                  MonthsInput(
                    onChanged: (month) => _selectedMonth = month,
                    initialMonth: _selectedMonth,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _startRanking(),
                          child: Text('Начать'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
