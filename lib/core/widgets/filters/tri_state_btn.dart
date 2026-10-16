import 'package:flutter/material.dart';

class TriStateBtn extends StatelessWidget {
  final bool? value;
  final Function(bool?) onChanged;
  final List<String> labels; // [не важно, да, нет]

  const TriStateBtn({
    super.key,
    this.value,
    required this.onChanged,
    required this.labels,
  });

  Widget _buildTriStateButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color selectedColor = Colors.deepPurple,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? selectedColor : Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTriStateButton(
            label: labels[0],
            isSelected: value == null,
            onTap: () => onChanged(null),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildTriStateButton(
            label: labels[1],
            isSelected: value == true,
            onTap: () => onChanged(true),
            selectedColor: Colors.green,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildTriStateButton(
            label: labels[2],
            isSelected: value == false,
            onTap: () => onChanged(false),
            selectedColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
