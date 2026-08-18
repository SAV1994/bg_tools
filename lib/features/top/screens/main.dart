import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';

class TopMainScreen extends ConsumerStatefulWidget {
  const TopMainScreen({super.key});

  @override
  ConsumerState<TopMainScreen> createState() => _TopMainScreenState();
}

class _TopMainScreenState extends ConsumerState<TopMainScreen> {
  @override
  Widget build(BuildContext context) {
    final ratingDataAsync = ref.watch(ratingDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Icon(topsIcon),
        actions: [
          if (ratingDataAsync.value != null)
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {},
              tooltip: 'Продолжить ранжиование',
            ),

          IconButton(
            icon: Icon(addBtnIcon),
            onPressed: () => context.pushNamed('top-add'),
            tooltip: 'Инициализировать топ',
          ),
        ],
      ),
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
                  ElevatedButton.icon(
                    onPressed: () => {context.pushNamed('games-list')},
                    style: btnStyle,
                    label: Text('Общий'),
                    icon: Icon(gamesIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {context.pushNamed('gamers-list')},
                    style: btnStyle,
                    label: Text('По геймдизайнеру'),
                    icon: Icon(designersIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {
                      context.pushNamed('gaming-sessions-list'),
                    },
                    style: btnStyle,
                    label: Text('По художнику'),
                    icon: Icon(artistsIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {context.pushNamed('templates-list')},
                    style: btnStyle,
                    label: Text('По тэгу категорий'),
                    icon: Icon(tagsIcon),
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
