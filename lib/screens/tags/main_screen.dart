import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class TagsMenuScreen extends ConsumerStatefulWidget {
  const TagsMenuScreen({super.key});

  @override
  ConsumerState<TagsMenuScreen> createState() => _TagsMenuScreenState();
}

class _TagsMenuScreenState extends ConsumerState<TagsMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Tooltip(message: 'Меню тэгов', child: Icon(tagsIcon)),
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
                  MenuButton(
                    onPressed: () => context.pushNamed('tags-categories'),
                    label: 'Категории',
                    icon: categoriesIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('tags-designers'),
                    label: 'Геймдизайнеры',
                    icon: designersIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('tags-artists'),
                    label: 'Художники',
                    icon: artistsIcon,
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
