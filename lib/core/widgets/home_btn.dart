import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/theme_consts.dart';

class HomeBtn extends StatelessWidget {
  final BuildContext context;

  const HomeBtn({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Вернутся в главное меню',
      child: IconButton(
        onPressed: () => context.goNamed('home'),
        icon: const Icon(homeIcon, color: greenColor),
      ),
    );
  }
}
