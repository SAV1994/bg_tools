import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/loading_screen.dart';
import 'package:bg_tools/screens/generic/list_with_modal_form.dart';

// Мультиселект с возможностью поиска
class MultiSelectWithSearch<T> extends ConsumerStatefulWidget {
  final String label;
  final Future<List<T>> Function() getItems;
  final Set<int> selectedIds;
  final Function(Set<int>) onSelectionChanged;
  final String Function(T) displayName;
  final int Function(T) getId;
  final bool Function(T)? isEnabled;
  final Widget Function(T)? customItemBuilder;
  final String? searchHint;
  final ModalFormConfig? configForModal;

  const MultiSelectWithSearch({
    super.key,
    required this.label,
    required this.getItems,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.displayName,
    required this.getId,
    this.isEnabled,
    this.customItemBuilder,
    this.searchHint,
    this.configForModal,
  });

  @override
  ConsumerState<MultiSelectWithSearch<T>> createState() =>
      MultiSelectWithSearchState<T>();
}

class MultiSelectWithSearchState<T>
    extends ConsumerState<MultiSelectWithSearch<T>> {
  final GlobalKey _dropdownKey = GlobalKey();

  List<T> items = [];
  // Контроллеры
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // Загрузка
  bool _isLoading = false;

  String _searchQuery = '';
  bool _isDropdownOpen = false;

  Set<int> get _selectedIds => widget.selectedIds;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    setState(() => _isLoading = true);

    List<T> newItems = await widget.getItems();

    setState(() {
      items = newItems;
      _isLoading = false;
    });
  }

  List<T> getFilteredItems() {
    if (_searchQuery.isEmpty) return items;

    return items.where((item) {
      final displayName = widget.displayName(item).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return displayName.contains(query);
    }).toList();
  }

  void _toggleSelection(int id) {
    final newSelected = Set<int>.from(_selectedIds);
    if (newSelected.contains(id)) {
      newSelected.remove(id);
    } else {
      newSelected.add(id);
    }
    widget.onSelectionChanged(newSelected);
  }

  void _selectAll() {
    final List<T> filteredItems = getFilteredItems();
    final allIds = filteredItems.map((item) => widget.getId(item)).toSet();
    final newSelected = Set<int>.from(_selectedIds)..addAll(allIds);
    widget.onSelectionChanged(newSelected);
  }

  void _clearAll() {
    final List<T> filteredItems = getFilteredItems();
    final filteredIds = filteredItems.map((item) => widget.getId(item)).toSet();
    final newSelected = Set<int>.from(_selectedIds)..removeAll(filteredIds);
    widget.onSelectionChanged(newSelected);
  }

  String _getSelectedNames() {
    if (_selectedIds.isEmpty) return 'Не выбрано';

    final selectedItems = items.where((item) {
      return _selectedIds.contains(widget.getId(item));
    }).toList();

    if (selectedItems.length <= 2) {
      return selectedItems.map((item) => widget.displayName(item)).join(', ');
    } else {
      return 'Выбрано: ${selectedItems.length}';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<T> filteredItems = getFilteredItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Метка
        Row(
          children: [
            Text(
              widget.label,
              key: _dropdownKey,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (widget.configForModal != null)
              IconButton(
                onPressed: () =>
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ModalForm(ref: ref, config: widget.configForModal!),
                    ).then((result) {
                      if (result == true) {
                        loadData();
                      }
                    }),
                icon: Icon(addBtnIcon, color: textColor),
                visualDensity: VisualDensity(vertical: -4.0),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Кнопка-селектор
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
              scrollToDropdown(_dropdownKey);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getSelectedNames(),
                    style: TextStyle(
                      color: _selectedIds.isEmpty ? textColor : Colors.green,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _isDropdownOpen ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),

        // Выпадающий список
        if (_isDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Поле поиска
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: widget.searchHint ?? 'Поиск...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),

                // Кнопки действий
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _selectAll,
                        child: const Text('Выбрать все'),
                      ),
                      TextButton(
                        onPressed: _clearAll,
                        child: const Text('Очистить'),
                      ),
                      const Spacer(),
                      if (filteredItems.isNotEmpty)
                        Text(
                          filteredItems.length.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Список элементов
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: _isLoading
                      ? LoadingScreen()
                      : filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ничего не найдено',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final id = widget.getId(item);
                              final isSelected = _selectedIds.contains(id);
                              final isEnabled =
                                  widget.isEnabled?.call(item) ?? true;

                              return CheckboxListTile(
                                title: widget.customItemBuilder != null
                                    ? widget.customItemBuilder!(item)
                                    : Text(widget.displayName(item)),
                                value: isSelected && isEnabled,
                                onChanged: isEnabled
                                    ? (selected) => _toggleSelection(id)
                                    : null,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),

        // Чипсы выбранных элементов (опционально)
        if (_selectedIds.isNotEmpty && !_isDropdownOpen)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _selectedIds.take(5).map((id) {
                final item = items.firstWhere(
                  (item) => widget.getId(item) == id,
                  orElse: () => null as T,
                );
                if (item == null) return const SizedBox.shrink();

                return Chip(
                  label: Text(widget.displayName(item)),
                  onDeleted: () => _toggleSelection(id),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 20,
                    color: redColor,
                  ),

                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ),

        if (_selectedIds.length > 5 && !_isDropdownOpen)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'и еще ${_selectedIds.length - 5}...',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }
}
