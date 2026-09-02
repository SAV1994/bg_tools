import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class EmptyPlayersListBanner extends StatelessWidget {
  const EmptyPlayersListBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: textColor),
          SizedBox(height: 16),
          Text(
            'Не выбрано игроков',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
