import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
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
                      : textColor,
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
                      : textColor,
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
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),
              IconButton(
                onPressed: () => context.pushNamed('templates-add'),
                icon: Icon(addBtnIcon),
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
