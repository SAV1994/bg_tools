// widgets/single_select_with_search.dart
import 'package:flutter/material.dart';

class SelectWithSearch<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onSelectionChanged;
  final String Function(T) displayName;
  final int Function(T) getId;
  final String? searchHint;
  final Widget Function(T)? customItemBuilder;
  final bool isRequired;
  final String? placeholder;
  
  const SelectWithSearch({
    super.key,
    required this.label,
    required this.items,
    this.selectedItem,
    required this.onSelectionChanged,
    required this.displayName,
    required this.getId,
    this.searchHint,
    this.customItemBuilder,
    this.isRequired = false,
    this.placeholder,
  });
  
  @override
  State<SelectWithSearch<T>> createState() => _SelectWithSearchState<T>();
}

class _SelectWithSearchState<T> extends State<SelectWithSearch<T>> {
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
  
  T? get _selectedItem => widget.selectedItem;
  
  void _selectItem(T? item) {
    widget.onSelectionChanged(item);
    setState(() {
      _isDropdownOpen = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }
  
  String _getSelectedName() {
    if (_selectedItem == null) {
      return widget.placeholder ?? 'Не выбрано';
    }
    return widget.displayName(_selectedItem!);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Метка
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
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
              border: Border.all(
                color: _isDropdownOpen ? Colors.blue : Colors.grey.shade400,
                width: _isDropdownOpen ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getSelectedName(),
                    style: TextStyle(
                      color: _selectedItem == null ? Colors.grey.shade500 : Colors.black87,
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
                            final isSelected = _selectedItem == item;
                            
                            return _buildListItem(item, isSelected);
                          },
                        ),
                ),
                
                // Кнопка очистки (если не обязательное поле)
                if (!widget.isRequired && _selectedItem != null)
                  Column(
                    children: [
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.clear, color: Colors.red),
                        title: const Text(
                          'Очистить',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () => _selectItem(null),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildListItem(T item, bool isSelected) {
    return InkWell(
      onTap: () => _selectItem(item),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue, size: 20)
              else
                Icon(Icons.radio_button_unchecked, color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: widget.customItemBuilder != null
                    ? widget.customItemBuilder!(item)
                    : Text(
                        widget.displayName(item),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}