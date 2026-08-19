import 'package:bg_tools/features/top/consts.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/rating_provider.dart';
import 'package:bg_tools/core/widgets/export.dart';

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
              onPressed: () => context.pushNamed('top-process'),
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
                  MenuButton(
                    onPressed: () => {context.pushNamed('top-common')},
                    label: 'Общий',
                    icon: gamesIcon,
                  ),
                  MenuButton(
                    onPressed: () {
                      ref
                          .read(ratingsPaginatedProvider.notifier)
                          .setTopType(TopTypeEnum.byDesigner);
                      context.pushNamed('top-designers');
                    },
                    label: 'По геймдизайнеру',
                    icon: designersIcon,
                  ),
                  MenuButton(
                    onPressed: () {
                      ref
                          .read(ratingsPaginatedProvider.notifier)
                          .setTopType(TopTypeEnum.byArtist);
                      context.pushNamed('top-artists');
                    },
                    label: 'По художнику',
                    icon: artistsIcon,
                  ),
                  MenuButton(
                    onPressed: () {
                      ref
                          .read(ratingsPaginatedProvider.notifier)
                          .setTopType(TopTypeEnum.byTag);
                      context.pushNamed('top-tags');
                    },
                    label: 'По тэгу категорий',
                    icon: tagsIcon,
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
