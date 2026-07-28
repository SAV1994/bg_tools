import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';

class InfoRow extends ConsumerStatefulWidget {
  final String label;
  final String? value;
  final Color? valueColor;
  final bool addDivider;

  const InfoRow({
    super.key,
    required this.label,
    this.value,
    this.valueColor,
    this.addDivider = true,
  });

  @override
  ConsumerState<InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends ConsumerState<InfoRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.addDivider) const Divider(),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 145,
                child: Text(widget.label, style: TextStyle(color: titleColor)),
              ),
              Expanded(
                child: Text(
                  widget.value ?? emptyVal,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: widget.valueColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
