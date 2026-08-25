import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/dataclasses/rating_dataclasses.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/screens/game/mixins/export.dart';

class FiltreConfig<D> {
  final Provider<D> daoProvier;
  final int Function(dynamic) getId;
  final String Function(dynamic) getLabel;

  const FiltreConfig({
    required this.daoProvier,
    required this.getId,
    required this.getLabel,
  });
}

class TopListScreen<M, D> extends ConsumerStatefulWidget {
  final TopTypeEnum topType;
  final IconData icon;
  final String Function(RatingData) getSubtitle;
  final FiltreConfig<D>? filterConfig;

  const TopListScreen({
    super.key,
    required this.topType,
    required this.icon,
    required this.getSubtitle,
    this.filterConfig,
  });

  @override
  ConsumerState<TopListScreen> createState() => _TopListScreenState();
}

class _TopListScreenState<M, D> extends ConsumerState<TopListScreen>
    with UpdateIsFaforiteMixin {
  List<M> _instances = [];
  M? _instance;
  bool _isInstanceSelectOpen = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  // Загрузка
  bool _isLoading = false;

  void _openRatingPage(int ratingId) {
    final notifier = ref.read(ratingsGamesPaginatedProvider.notifier);
    notifier.setTopType(widget.topType);
    notifier.setRatingId(ratingId);

    context.pushNamed('top-games');
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.filterConfig != null) {
      final dao = ref.read(widget.filterConfig!.daoProvier);
      _instances = await dao.getHasTop();
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratingsAsync = ref.watch(ratingsPaginatedProvider);
    final notifier = ref.read(ratingsPaginatedProvider.notifier);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        notifier.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: (_isInstanceSelectOpen && widget.filterConfig != null)
                ? AppBarSelect(
                    items: _instances
                        .map(
                          (instance) => SelectItem(
                            widget.filterConfig!.getId(instance),
                            widget.filterConfig!.getLabel(instance),
                          ),
                        )
                        .toList(),
                    onSelectionChanged: (artist) {
                      notifier.filterByInstanceId(artist?.id);
                    },
                    selectedItem: (_instance != null)
                        ? SelectItem(
                            widget.filterConfig!.getId(_instance),
                            widget.filterConfig!.getLabel(_instance),
                          )
                        : null,
                  )
                : Row(
                    children: [
                      Icon(topsIcon, color: silverColor),
                      Icon(widget.icon),
                    ],
                  ),
          ),
          actions: [
            if (widget.filterConfig != null)
              IconButton(
                icon: Icon(
                  _isInstanceSelectOpen ? Icons.close : commonSelectIcon,
                  color: _isInstanceSelectOpen ? redColor : textColor,
                ),
                onPressed: () {
                  setState(() {
                    if (_isInstanceSelectOpen) {
                      notifier.filterByInstanceId(null);
                    }
                    _isInstanceSelectOpen = !_isInstanceSelectOpen;
                  });
                },
              ),
            if (!_isInstanceSelectOpen) ...[
              IconButton(
                visualDensity: VisualDensity(horizontal: -4.0),
                icon: Icon(
                  notifier.reverseOrdering
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: notifier.reverseOrdering ? goldColor : textColor,
                ),
                onPressed: () => notifier.toggleOrdering(),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Выйти', style: TextStyle(color: redColor)),
              ),
            ],
          ],
        ),
        body: _isLoading
            ? LoadingScreen()
            : Column(
                children: [
                  // Список
                  Expanded(
                    child: ratingsAsync.when(
                      data: (ratings) {
                        if (ratings.isEmpty) {
                          return EmptyListScreen();
                        }
                        return Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: ratings.length,
                            itemBuilder: (context, index) {
                              final RatingData ratingData = ratings[index];

                              return Card(
                                child: ListTile(
                                  leading: IconButton(
                                    icon: Icon(widget.icon),
                                    onPressed: () {},
                                  ),
                                  title: Text(
                                    '${ratingData.rating.year}г. ${MonthsEnum.fromId(ratingData.rating.month).label}',
                                    style: TextStyle(
                                      color: ratingData.rating.isActual
                                          ? goldColor
                                          : textColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    widget.getSubtitle(ratingData),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () =>
                                      _openRatingPage(ratingData.rating.id),
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
                  if (ratingsAsync.hasValue && ratingsAsync.value!.isNotEmpty)
                    PaginationPanel(notifier: notifier),
                ],
              ),
      ),
    );
  }
}
