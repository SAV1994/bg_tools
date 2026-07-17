import 'package:bg_tools/core/utils/export.dart';
import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

// Селект для AppBar
class AppBarSelect<T> extends StatefulWidget {
  final List<SelectItem> items;
  final Function(SelectItem?) onSelectionChanged;
  final String? placeholder;

  const AppBarSelect({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    this.placeholder,
  });

  @override
  State<AppBarSelect<T>> createState() => _AppBarSelectState<T>();
}

class _AppBarSelectState<T> extends State<AppBarSelect<T>> {
  bool _isModalnOpen = false;
  SelectItem? _selectedItem;

  void _selectItem(SelectItem? item) {
    setState(() {
      widget.onSelectionChanged(item);
      _selectedItem = item;
      _isModalnOpen = false;
    });
  }

  String _getSelectedName() {
    if (_selectedItem == null) {
      return widget.placeholder ?? 'Не выбрано';
    }
    return _selectedItem!.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isModalnOpen = true;
              buildSelectListModal(
                context,
                widget.items
                    .where((item) => item.id != _selectedItem?.id)
                    .toList(),
                (item) {
                  _selectItem(item);
                },
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isModalnOpen ? goldColor : borderColor,
                width: _isModalnOpen ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: secondColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getSelectedName(),
                    style: TextStyle(
                      color: _selectedItem == null ? redColor : textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
