// widgets/multi_select_with_search.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiSelectWithSearch<T> extends ConsumerStatefulWidget {
  final String label;
  final List<T> items;
  final Set<int> selectedIds;
  final Function(Set<int>) onSelectionChanged;
  final String Function(T) displayName;
  final int Function(T) getId;
  final bool Function(T)? isEnabled;
  final Widget Function(T)? customItemBuilder;
  final String? searchHint;
  
  const MultiSelectWithSearch({
    super.key,
    required this.label,
    required this.items,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.displayName,
    required this.getId,
    this.isEnabled,
    this.customItemBuilder,
    this.searchHint,
  });
  
  @override
  ConsumerState<MultiSelectWithSearch<T>> createState() => _MultiSelectWithSearchState<T>();
}

class _MultiSelectWithSearchState<T> extends ConsumerState<MultiSelectWithSearch<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDropdownOpen = false;
  
  List<T> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    
    return widget.items.where((item) {
      final displayName = widget.displayName(item).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return displayName.contains(query);
    }).toList();
  }
  
  Set<int> get _selectedIds => widget.selectedIds;
  
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
    final allIds = _filteredItems.map((item) => widget.getId(item)).toSet();
    final newSelected = Set<int>.from(_selectedIds)..addAll(allIds);
    widget.onSelectionChanged(newSelected);
  }
  
  void _clearAll() {
    final filteredIds = _filteredItems.map((item) => widget.getId(item)).toSet();
    final newSelected = Set<int>.from(_selectedIds)..removeAll(filteredIds);
    widget.onSelectionChanged(newSelected);
  }
  
  String _getSelectedNames() {
    if (_selectedIds.isEmpty) return 'Не выбрано';
    
    final selectedItems = widget.items.where((item) {
      return _selectedIds.contains(widget.getId(item));
    }).toList();
    
    if (selectedItems.length <= 2) {
      return selectedItems.map((item) => widget.displayName(item)).join(', ');
    } else {
      return 'Выбрано: ${selectedItems.length}';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Метка
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        
        // Кнопка-селектор
        GestureDetector(
          onTap: () {
            setState(() => _isDropdownOpen = !_isDropdownOpen);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getSelectedNames(),
                    style: TextStyle(
                      color: _selectedIds.isEmpty ? Colors.grey.shade500 : Colors.black87,
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
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Поле поиска
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: widget.searchHint ?? 'Поиск...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                
                // Кнопки действий
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      if (_filteredItems.isNotEmpty)
                        Text(
                          '${_filteredItems.length} ${_getWordForm(_filteredItems.length)}',
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
                  child: _filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text(
                                  'Ничего не найдено',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final id = widget.getId(item);
                            final isSelected = _selectedIds.contains(id);
                            final isEnabled = widget.isEnabled?.call(item) ?? true;
                            
                            return CheckboxListTile(
                              title: widget.customItemBuilder != null
                                  ? widget.customItemBuilder!(item)
                                  : Text(widget.displayName(item)),
                              value: isSelected && isEnabled,
                              onChanged: isEnabled
                                  ? (selected) => _toggleSelection(id)
                                  : null,
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                            );
                          },
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
                final item = widget.items.firstWhere(
                  (item) => widget.getId(item) == id,
                  orElse: () => null as T,
                );
                if (item == null) return const SizedBox.shrink();
                
                return Chip(
                  label: Text(widget.displayName(item)),
                  onDeleted: () => _toggleSelection(id),
                  deleteIcon: const Icon(Icons.close, size: 16),
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
  
  String _getWordForm(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'проект';
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) return 'проекта';
    return 'проектов';
  }
}