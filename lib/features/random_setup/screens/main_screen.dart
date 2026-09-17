import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class RandomSetupMenuScreen extends ConsumerStatefulWidget {
  final int gameId;
  const RandomSetupMenuScreen({required this.gameId, super.key});

  @override
  ConsumerState<RandomSetupMenuScreen> createState() =>
      _RandomSetupMenuScreenState();
}

class _RandomSetupMenuScreenState extends ConsumerState<RandomSetupMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Icon(setupsMenuIcon)),
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-number'),
                    label: 'Случайный сетап',
                    icon: setupsIcon,
                  ),
                  MenuButton(
                    onPressed: () {
                      final notifier = ref.read(
                        randomSetupPaginatedProvider.notifier,
                      );
                      notifier.filterByGame(widget.gameId);

                      context.pushNamed(
                        'random-setups-setup-configs',
                        pathParameters: {'gameId': widget.gameId.toString()},
                      );
                    },
                    label: 'Настройка сетапов',
                    icon: setupsConfigIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-games'),
                    label: 'Случайные списки',
                    icon: listsIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed(
                      'random-setups-components',
                      pathParameters: {'gameId': widget.gameId.toString()},
                    ),
                    label: 'Компоненты',
                    icon: componentsIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
