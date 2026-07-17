import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/export.dart';

class GamersListScreen extends ConsumerStatefulWidget {
  const GamersListScreen({super.key});

  @override
  ConsumerState<GamersListScreen> createState() => _GamersListScreenState();
}

class _GamersListScreenState extends ConsumerState<GamersListScreen> {
  bool _isSearchOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _openAddForm() async {
    final result = await context.pushNamed('gamers-add');

    if (result == true) {
      ref.invalidate(gamerDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openUpdatePage(int gamerId) async {
    final result = await context.pushNamed(
      'gamers-update',
      pathParameters: {'gamerId': gamerId.toString()},
    );

    if (result == true) {
      ref.invalidate(gameDaoProvider); // Обновляем провайдер
      setState(() {});
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
    final gamersAsync = ref.watch(gamersPaginatedProvider);
    final notifier = ref.read(gamersPaginatedProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isSearchOpen
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Поиск игроков...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: textColor),
                    contentPadding: const EdgeInsets.symmetric(),
                  ),
                  style: const TextStyle(color: textColor),
                  onChanged: (value) => notifier.search(value),
                )
              : Icon(gamersIcon),
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
            IconButton(
              onPressed: () => {_openAddForm()},
              icon: Icon(Icons.add_box),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Список
          Expanded(
            child: gamersAsync.when(
              data: (gamers) {
                // Если данных нет
                if (gamers.isEmpty) {
                  return buildEmptyListScreen();
                }
                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: gamers.length,
                    itemBuilder: (context, index) {
                      final gamer = gamers[index];

                      String fio = '';

                      if (gamer.lastName != null) {
                        fio += '${gamer.lastName} ';
                      }
                      fio += '${gamer.firstName} ';
                      if (gamer.middleName != null) {
                        fio += '${gamer.middleName}';
                      }

                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.wc),
                          title: Text(gamer.username),
                          subtitle: Text(fio),
                          trailing: Icon(Icons.edit),
                          onTap: () {
                            _openUpdatePage(gamer.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => buildLoadingScreen(),
              error: (err, _) => Text('ОШИБКА'),
            ),
          ),
          // Панель пагинации (всегда внизу)
          if (gamersAsync.hasValue && gamersAsync.value!.isNotEmpty)
            PaginationPanel(notifier: notifier),
        ],
      ),
    );
  }
}
