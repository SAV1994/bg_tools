import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/base.dart';
import 'package:bg_tools/core/providers/paginated_providers/game_provider.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class ListWithModalFormConfig<T, D, C> {
  final IconData icon;
  final AsyncNotifierProvider<BaseNotifier, dynamic> dataProvider;
  final Provider<D> daoProvier;
  final C Function(String name) companionFactory;
  final String imputName;
  final String filterParam;

  const ListWithModalFormConfig({
    required this.icon,
    required this.dataProvider,
    required this.daoProvier,
    required this.companionFactory,
    required this.imputName,
    required this.filterParam,
  });
}

class ListWithModalFormScreen<T> extends ConsumerStatefulWidget {
  final ListWithModalFormConfig config;

  const ListWithModalFormScreen({required this.config, super.key});

  @override
  ConsumerState<ListWithModalFormScreen> createState() =>
      _ListWithModalFormScreenState();
}

class _ListWithModalFormScreenState
    extends ConsumerState<ListWithModalFormScreen> {
  bool _isSearchOpen = false;
  bool _isEditMode = false;
  // Контроллеры
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  void _showModalForm(BuildContext context, WidgetRef ref, [int? instanceId]) {
    showDialog(
      context: context,
      builder: (context) =>
          ModalForm(ref: ref, config: widget.config, instanceId: instanceId),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(widget.config.dataProvider);
    final notifier = ref.read(widget.config.dataProvider.notifier);

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
              : Icon(widget.config.icon),
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
              onPressed: () => {
                setState(() {
                  _isEditMode = !_isEditMode;
                }),
              },
              icon: _isEditMode
                  ? Icon(Icons.edit, color: borderColor)
                  : Icon(gamesIcon, color: goldColor),
            ),
            IconButton(
              onPressed: () => {_showModalForm(context, ref)},
              icon: Icon(addBtnIcon),
            ),
          ],
        ],
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          notifier.reset();
        },
        child: Column(
          children: [
            // Список
            Expanded(
              child: dataAsync.when(
                data: (data) {
                  // Если данных нет
                  if (data.isEmpty) {
                    return EmptyListScreen();
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(widget.config.icon),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                color: _isEditMode ? textColor : goldColor,
                              ),
                            ),
                            trailing: _isEditMode
                                ? Icon(Icons.edit)
                                : Icon(gamesIcon, color: goldColor),
                            onTap: () {
                              if (_isEditMode) {
                                _showModalForm(context, ref, item.id);
                              } else {
                                final notifier = ref.read(
                                  gamesPaginatedProvider.notifier,
                                );

                                if (widget.config.filterParam == 'artistId') {
                                  notifier.filterByArtist(item.id);
                                } else if (widget.config.filterParam ==
                                    'designerId') {
                                  notifier.filterByDesigner(item.id);
                                } else if (widget.config.filterParam ==
                                    'tagId') {
                                  notifier.filterByTag(item.id);
                                }
                                context.pushNamed(
                                  'games-list',
                                  queryParameters: {
                                    widget.config.filterParam: item.id
                                        .toString(),
                                  },
                                );
                              }
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
            if (dataAsync.hasValue && dataAsync.value!.isNotEmpty)
              PaginationPanel(notifier: notifier),
          ],
        ),
      ),
    );
  }
}

class ModalForm extends ConsumerStatefulWidget {
  final int? instanceId;
  final WidgetRef ref;
  final ListWithModalFormConfig config;

  const ModalForm({
    super.key,
    this.instanceId,
    required this.ref,
    required this.config,
  });

  @override
  ConsumerState<ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends ConsumerState<ModalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Контроллеры
  late final TextEditingController _nameController;
  // Загрузка
  bool _isLoading = false;
  // Ошибка
  String? _generalError;
  // Сущность
  late final dynamic instance;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.instanceId == null) {
      _nameController = TextEditingController();
    } else {
      final dao = widget.ref.read(widget.config.daoProvier);
      instance = await dao.get(widget.instanceId);
      _nameController = TextEditingController(text: instance.name);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _submitForm() async {
    final dao = widget.ref.read(widget.config.daoProvier);
    try {
      if (widget.instanceId == null) {
        await dao.create(widget.config.companionFactory(_nameController.text));
      } else {
        await dao.updInstance(
          widget.instanceId,
          widget.config.companionFactory(_nameController.text),
        );

        ref.invalidate(gameFullDataProvider);
        ref.read(widget.config.dataProvider.notifier).refresh();
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _generalError = 'Запись уже существует';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.instanceId == null ? 'Новая запись' : 'Редактирование',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: _isLoading
              ? [LoadingScreen()]
              : [
                  if (widget.instanceId != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outlined),
                      onPressed: () {
                        buildDelModal(
                          context,
                          ref,
                          widget.config.daoProvier,
                          mounted,
                          instance,
                        );
                      },
                    ),
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
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: widget.config.imputName,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Введите ФИО' : null,
                  ),
                ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => {Navigator.pop(context)},
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.instanceId == null ? 'Добавить' : 'Сохранить'),
        ),
      ],
    );
  }
}
