import 'package:flutter/material.dart';

void scrollToDropdown(GlobalKey dropdownKey) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Scrollable.ensureVisible(
      dropdownKey.currentContext!,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.1, // 0.0 - верх, 0.5 - центр, 1.0 - низ
    );
  });
}
