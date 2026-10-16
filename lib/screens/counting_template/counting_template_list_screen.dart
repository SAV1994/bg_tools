import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class CountingTemplateListScreen extends ConsumerStatefulWidget {
  const CountingTemplateListScreen({super.key});

  @override
  ConsumerState<CountingTemplateListScreen> createState() =>
      _CountingTemplateListScreenListScreenState();
}

class _CountingTemplateListScreenListScreenState
    extends ConsumerState<CountingTemplateListScreen> {
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final ScrollController _modalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _showFilterModal(CountingTemplatesNotifier notifier) async {
    GameTypeEnum? gameType = notifier.gameTypeId != null
        ? GameTypeEnum.fromId(notifier.gameTypeId!)
        : null;
    FirstPlayerStartTypeEnum? firstPlayerStartType =
        notifier.firstPlayerStartTypeId != null
        ? FirstPlayerStartTypeEnum.fromId(notifier.firstPlayerStartTypeId!)
        : null;
    ResultTypeEnum? resultType = notifier.resultTypeId != null
        ? ResultTypeEnum.fromId(notifier.resultTypeId!)
        : null;
    GeneralDefeatTypeEnum? generalDefeatType =
        notifier.generalDefeatTypeId != null
        ? GeneralDefeatTypeEnum.fromId(notifier.generalDefeatTypeId!)
        : null;
    TeamPointTypeEnum? teamPointType = notifier.teamPointTypeId != null
        ? TeamPointTypeEnum.fromId(notifier.teamPointTypeId!)
        : null;
    PointTypeEnum? pointType = notifier.pointTypeId != null
        ? PointTypeEnum.fromId(notifier.pointTypeId!)
        : null;
    RoundsTypeEnum? roundsType = notifier.roundsTypeId != null
        ? RoundsTypeEnum.fromId(notifier.roundsTypeId!)
        : null;
    AltVictoryTypeEnum? altVictoryType = notifier.altVictoryTypeId != null
        ? AltVictoryTypeEnum.fromId(notifier.altVictoryTypeId!)
        : null;
    FirstPlayerRoundTypeEnum? firstPlayerRoundType =
        notifier.firstPlayerRoundTypeId != null
        ? FirstPlayerRoundTypeEnum.fromId(notifier.firstPlayerRoundTypeId!)
        : null;
    FirstPlayerRoundPointTypeEnum? firstPlayerRoundPointType =
        notifier.frstPlayerRoundPointTypeId != null
        ? FirstPlayerRoundPointTypeEnum.fromId(
            notifier.frstPlayerRoundPointTypeId!,
          )
        : null;
    SequencePlayersMovesTypeEnum? sequencePlayersMovesType =
        notifier.sequencePlayersMovesTypeId != null
        ? SequencePlayersMovesTypeEnum.fromId(
            notifier.sequencePlayersMovesTypeId!,
          )
        : null;
    GameHostTypeEnum? gameHostType = notifier.gameHostTypeId != null
        ? GameHostTypeEnum.fromId(notifier.gameHostTypeId!)
        : null;
    SecretRolesDistributionTypeEnum? secretRolesDistributionType =
        notifier.secretRolesDistributionTypeId != null
        ? SecretRolesDistributionTypeEnum.fromId(
            notifier.secretRolesDistributionTypeId!,
          )
        : null;
    UniquenessRolesTypeEnum? uniquenessRolesType =
        notifier.uniquenessRolesTypeId != null
        ? UniquenessRolesTypeEnum.fromId(notifier.uniquenessRolesTypeId!)
        : null;

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: secondColor, // ← Фон заголовка
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.filter, color: Colors.white),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Фильтры',
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

                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: firstColor,
                        child: Scrollbar(
                          controller: _modalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 10,
                            ),
                            controller: _modalScrollController,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                EnumSelector(
                                  label: GameTypeEnum.title,
                                  choices: GameTypeEnum.getDropdownMenuItems(),
                                  selected: gameType,
                                  onChanged: (value) => setStateDialog(
                                    () => gameType = value as GameTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: FirstPlayerStartTypeEnum.title,
                                  choices:
                                      FirstPlayerStartTypeEnum.getDropdownMenuItems(),
                                  selected: firstPlayerStartType,
                                  onChanged: (value) => setStateDialog(
                                    () => firstPlayerStartType =
                                        value as FirstPlayerStartTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: ResultTypeEnum.title,
                                  choices:
                                      ResultTypeEnum.getDropdownMenuItems(),
                                  selected: resultType,
                                  onChanged: (value) => setStateDialog(
                                    () => resultType = value as ResultTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: GeneralDefeatTypeEnum.title,
                                  choices:
                                      GeneralDefeatTypeEnum.getDropdownMenuItems(),
                                  selected: generalDefeatType,
                                  onChanged: (value) => setStateDialog(
                                    () => generalDefeatType =
                                        value as GeneralDefeatTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: TeamPointTypeEnum.title,
                                  choices:
                                      TeamPointTypeEnum.getDropdownMenuItems(),
                                  selected: teamPointType,
                                  onChanged: (value) => setStateDialog(
                                    () => teamPointType =
                                        value as TeamPointTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: PointTypeEnum.title,
                                  choices: PointTypeEnum.getDropdownMenuItems(),
                                  selected: pointType,
                                  onChanged: (value) => setStateDialog(
                                    () => pointType = value as PointTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: RoundsTypeEnum.title,
                                  choices:
                                      RoundsTypeEnum.getDropdownMenuItems(),
                                  selected: roundsType,
                                  onChanged: (value) => setStateDialog(
                                    () => roundsType = value as RoundsTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: AltVictoryTypeEnum.title,
                                  choices:
                                      AltVictoryTypeEnum.getDropdownMenuItems(),
                                  selected: altVictoryType,
                                  onChanged: (value) => setStateDialog(
                                    () => altVictoryType =
                                        value as AltVictoryTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: FirstPlayerRoundTypeEnum.title,
                                  choices:
                                      FirstPlayerRoundTypeEnum.getDropdownMenuItems(),
                                  selected: firstPlayerRoundType,
                                  onChanged: (value) => setStateDialog(
                                    () => firstPlayerRoundType =
                                        value as FirstPlayerRoundTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: FirstPlayerRoundPointTypeEnum.title,
                                  choices:
                                      FirstPlayerRoundPointTypeEnum.getDropdownMenuItems(),
                                  selected: firstPlayerRoundPointType,
                                  onChanged: (value) => setStateDialog(
                                    () => firstPlayerRoundPointType =
                                        value as FirstPlayerRoundPointTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: SequencePlayersMovesTypeEnum.title,
                                  choices:
                                      SequencePlayersMovesTypeEnum.getDropdownMenuItems(),
                                  selected: sequencePlayersMovesType,
                                  onChanged: (value) => setStateDialog(
                                    () => sequencePlayersMovesType =
                                        value as SequencePlayersMovesTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: GameHostTypeEnum.title,
                                  choices:
                                      GameHostTypeEnum.getDropdownMenuItems(),
                                  selected: gameHostType,
                                  onChanged: (value) => setStateDialog(
                                    () => gameHostType =
                                        value as GameHostTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: SecretRolesDistributionTypeEnum.title,
                                  choices:
                                      SecretRolesDistributionTypeEnum.getDropdownMenuItems(),
                                  selected: secretRolesDistributionType,
                                  onChanged: (value) => setStateDialog(
                                    () => secretRolesDistributionType =
                                        value
                                            as SecretRolesDistributionTypeEnum,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                EnumSelector(
                                  label: UniquenessRolesTypeEnum.title,
                                  choices:
                                      UniquenessRolesTypeEnum.getDropdownMenuItems(),
                                  selected: uniquenessRolesType,
                                  onChanged: (value) => setStateDialog(
                                    () => uniquenessRolesType =
                                        value as UniquenessRolesTypeEnum,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: secondColor,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              notifier.reset();
                              Navigator.pop(context);
                            },
                            child: Text('Сбросить'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: goldColor,
                              foregroundColor: firstColor,
                            ),
                            onPressed: () {
                              notifier.gameTypeId = gameType?.id;
                              notifier.firstPlayerStartTypeId =
                                  firstPlayerStartType?.id;
                              notifier.resultTypeId = resultType?.id;
                              notifier.generalDefeatTypeId =
                                  generalDefeatType?.id;
                              notifier.teamPointTypeId = teamPointType?.id;
                              notifier.pointTypeId = pointType?.id;
                              notifier.roundsTypeId = roundsType?.id;
                              notifier.altVictoryTypeId = altVictoryType?.id;
                              notifier.firstPlayerRoundTypeId =
                                  firstPlayerRoundType?.id;
                              notifier.frstPlayerRoundPointTypeId =
                                  firstPlayerRoundPointType?.id;
                              notifier.sequencePlayersMovesTypeId =
                                  sequencePlayersMovesType?.id;
                              notifier.gameHostTypeId = gameHostType?.id;
                              notifier.secretRolesDistributionTypeId =
                                  secretRolesDistributionType?.id;
                              notifier.uniquenessRolesTypeId =
                                  uniquenessRolesType?.id;

                              notifier.refresh();

                              Navigator.pop(context);
                            },
                            child: Text('Применить'),
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _modalScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(countingTemplatesPaginatedProvider);
    final notifier = ref.read(countingTemplatesPaginatedProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        notifier.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isSearchOpen
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Поиск шаблонов...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textColor),
                      contentPadding: const EdgeInsets.symmetric(),
                    ),
                    style: const TextStyle(color: textColor),
                    onChanged: (value) => notifier.search(value),
                  )
                : Tooltip(
                    message: 'Список наблонов\nигровых сессий',
                    child: const Icon(templatesIcon),
                  ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : textColor,
              ),
              tooltip: _isSearchOpen ? 'Закрыть поиск' : 'Поиск',
              onPressed: () {
                setState(() {
                  if (_isSearchOpen) {
                    _searchController.clear();
                    notifier.search('');
                    _isSearchOpen = false;
                  } else {
                    _isSearchOpen = true;
                  }
                });
              },
            ),

            if (!_isSearchOpen) ...[
              IconButton(
                icon: getFilterIcon(
                  numActiveFilters: notifier.countActiveFilters(),
                ),
                tooltip: 'Фильтры',
                onPressed: () => _showFilterModal(notifier),
              ),

              IconButton(
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                tooltip:
                    'Сортировка по ${notifier.reverseOrdering ? 'убыванию' : 'возрастанию'}',
                onPressed: () => notifier.toggleOrdering(),
              ),
              IconButton(
                icon: Icon(addBtnIcon),
                tooltip: 'Добавить шаблон',
                onPressed: () => context.pushNamed('templates-add'),
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            // Список
            Expanded(
              child: templatesAsync.when(
                data: (templates) {
                  // Если данных нет
                  if (templates.isEmpty) {
                    return EmptyListScreen();
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        final CountingTemplate template = templates[index];

                        return Card(
                          child: ListTile(
                            leading: Icon(templatesIcon),
                            title: Text(
                              template.name,
                              style: TextStyle(color: goldColor),
                            ),
                            subtitle: Text(template.description ?? emptyVal),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              context.pushNamed(
                                'templates-detail',
                                pathParameters: {
                                  'templateId': template.id.toString(),
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => LoadingScreen(),
                error: (err, _) => ErrorNotification(),
              ),
            ),
            // Панель пагинации (всегда внизу)
            if (templatesAsync.hasValue && templatesAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
