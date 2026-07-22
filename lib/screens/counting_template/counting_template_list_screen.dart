import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

enum _ScreenState { search, select, none }

class CountingTemplateListScreen extends ConsumerStatefulWidget {
  const CountingTemplateListScreen({super.key});

  @override
  ConsumerState<CountingTemplateListScreen> createState() =>
      _CountingTemplateListScreenListScreenState();
}

class _CountingTemplateListScreenListScreenState
    extends ConsumerState<CountingTemplateListScreen> {
  _ScreenState _screenState = _ScreenState.none;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _openAddForm() async {
    final result = await context.pushNamed('templates-add');

    if (result == true) {
      ref.invalidate(countingTemplatesDataProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openDetailPage(int templateId) async {
    final result = await context.pushNamed(
      'templates-detail',
      pathParameters: {'templateId': templateId.toString()},
    );

    if (result == true) {
      ref.invalidate(countingTemplatesDataProvider); // Обновляем провайдер
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
            child: _screenState == _ScreenState.none
                ? Icon(templatesIcon)
                : _screenState == _ScreenState.search
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
                : AppBarSelect(
                    items: GameTypeEnum.getSelectItems(),
                    onSelectionChanged: (selectItem) {
                      notifier.filterByGameType(selectItem?.id);
                    },
                  ),
          ),
          actions: [
            if (_screenState != _ScreenState.select)
              IconButton(
                icon: Icon(
                  _screenState == _ScreenState.search
                      ? Icons.close
                      : Icons.search,
                  color: _screenState == _ScreenState.search
                      ? redColor
                      : borderColor,
                ),
                onPressed: () {
                  setState(() {
                    if (_screenState == _ScreenState.search) {
                      _searchController.clear();
                      notifier.search('');
                      _screenState = _ScreenState.none;
                    } else {
                      _screenState = _ScreenState.search;
                    }
                  });
                },
              ),

            if (_screenState != _ScreenState.search)
              IconButton(
                icon: Icon(
                  _screenState == _ScreenState.select
                      ? Icons.close
                      : Icons.filter,
                  color: _screenState == _ScreenState.select
                      ? redColor
                      : borderColor,
                ),
                onPressed: () {
                  setState(() {
                    if (_screenState == _ScreenState.select) {
                      notifier.filterByGameType(null);
                      _screenState = _ScreenState.none;
                    } else {
                      _screenState = _ScreenState.select;
                    }
                  });
                },
              ),
            if (_screenState == _ScreenState.none) ...[
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
              child: templatesAsync.when(
                data: (templates) {
                  // Если данных нет
                  if (templates.isEmpty) {
                    return buildEmptyListScreen();
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
                            leading: Icon(Icons.build),
                            title: Text(
                              template.name,
                              style: TextStyle(color: goldColor),
                            ),
                            subtitle: Text(template.description ?? emptyVal),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              _openDetailPage(template.id);
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
            if (templatesAsync.hasValue && templatesAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}
