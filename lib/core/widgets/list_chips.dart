import 'package:bg_tools/core/consts/export.dart';
import 'package:flutter/material.dart';

class ListChips extends StatelessWidget {
  final String title;
  final List items;
  final Function getItemTitle;
  final Function? onTap;

  const ListChips({
    super.key,
    required this.title,
    required this.items,
    required this.getItemTitle,
    this.onTap,
  });

  Widget getChip(item) {
    return Chip(
      label: Text(getItemTitle(item), style: TextStyle(color: goldColor)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            if (onTap != null) {
              return GestureDetector(
                onTap: () => onTap!(item.id),
                child: getChip(item),
              );
            } else {
              return getChip(item);
            }
          }).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
