import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class RandomSetupConfigScreen extends ConsumerStatefulWidget {
  final int gameId;

  const RandomSetupConfigScreen({required this.gameId, super.key});

  @override
  ConsumerState<RandomSetupConfigScreen> createState() =>
      _RandomSetupConfigScreenState();
}

class _RandomSetupConfigScreenState
    extends ConsumerState<RandomSetupConfigScreen> {
  Game? _game;
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
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

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadingScreen();
    }

    final randomSetupsAsync = ref.watch(randomSetupPaginatedProvider);
    final notifier = ref.read(randomSetupPaginatedProvider.notifier);

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
                      hintText: 'Поиск сетапа...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: textColor),
                      contentPadding: const EdgeInsets.symmetric(),
                    ),
                    style: const TextStyle(color: textColor),
                    onChanged: (value) => notifier.search(value),
                  )
                : Tooltip(
                    message: _game!.name,
                    child: const Icon(setupsConfigIcon, size: 25),
                  ),
          ),

          actions: [
            IconButton(
              icon: Icon(
                _isSearchOpen ? Icons.close : Icons.search,
                color: _isSearchOpen ? redColor : textColor,
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
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),
              IconButton(
                icon: Icon(addBtnIcon),
                onPressed: () => context.pushNamed(
                  'random-setups-setup-add',
                  pathParameters: {'gameId': widget.gameId.toString()},
                ),
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: randomSetupsAsync.when(
                data: (randomSetups) {
                  // Если данных нет
                  if (randomSetups.isEmpty) {
                    return EmptyListScreen();
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: randomSetups.length,
                      itemBuilder: (context, index) {
                        final randomSetup = randomSetups[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(setupsConfigIcon),
                            title: Text(randomSetup.name),
                            trailing: Icon(Icons.edit),
                            onTap: () => context.pushNamed(
                              'random-setups-setup-update',
                              pathParameters: {
                                'gameId': widget.gameId.toString(),
                                'setupId': randomSetup.id.toString(),
                              },
                            ),
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
            if (randomSetupsAsync.hasValue &&
                randomSetupsAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
