import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/services/session_data_initializer.dart';

class GamesCountingTemplatesSelectScreen<T> extends ConsumerStatefulWidget {
  final int gameId;

  const GamesCountingTemplatesSelectScreen({required this.gameId, super.key});

  @override
  ConsumerState<GamesCountingTemplatesSelectScreen> createState() =>
      _GamesCountingTemplatesSelectScreenState();
}

class _GamesCountingTemplatesSelectScreenState
    extends ConsumerState<GamesCountingTemplatesSelectScreen> {
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _runSession(int gamesCountingTemplatesId) async {
    final gamesCountingTemplatesDao = ref.read(
      gamesCountingTemplatesDaoProvider,
    );
    GamesCountingTemplatesData? templateData = await gamesCountingTemplatesDao
        .getSingle(gamesCountingTemplatesId);
    await initSessionData(templateData!);

    if (mounted) {
      await context.pushNamed('session-runner');
      ref.invalidate(gameFullDataProvider); // Обновляем провайдер
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gamesCountingTemplatesAsync = ref.watch(
      gamesCountingTemplatesPaginatedProvider,
    );
    final notifier = ref.read(gamesCountingTemplatesPaginatedProvider.notifier);

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
                      hintText: 'Поиск игр...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textColor),
                      contentPadding: const EdgeInsets.symmetric(),
                    ),
                    style: const TextStyle(color: textColor),
                    onChanged: (value) => notifier.search(value),
                  )
                : Text('Выбор шаблона'),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : borderColor,
              ),
              onPressed: () {
                setState(() {
                  if (_isSearchOpen) {
                    _searchController.clear();
                    notifier.search('');
                  }
                  _isSearchOpen = !_isSearchOpen;
                });
              },
            ),
            if (!_isSearchOpen) ...[
              IconButton(
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : borderColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: gamesCountingTemplatesAsync.when(
                data: (gamesCountingTemplates) {
                  // Если данных нет
                  if (gamesCountingTemplates.isEmpty) {
                    return EmptyListScreen();
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: gamesCountingTemplates.length,
                      itemBuilder: (context, index) {
                        final gamesCountingTemplatesData =
                            gamesCountingTemplates[index];
                        final gamesCountingTemplate =
                            gamesCountingTemplatesData.gamesCountingTemplate;
                        String subtitle = gamesCountingTemplatesData.expansions
                            .map((expansion) => expansion.name)
                            .toList()
                            .join(', ');

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.build),
                            title: Text(gamesCountingTemplate.name),
                            subtitle: Text(subtitle),
                            trailing: Icon(Icons.play_arrow),
                            onTap: () {
                              _runSession(gamesCountingTemplate.id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => LoadingScreen(),
                error: (err, _) => Text('ОШИБКА: ${err.toString()}'),
              ),
            ),
            if (gamesCountingTemplatesAsync.hasValue &&
                gamesCountingTemplatesAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
