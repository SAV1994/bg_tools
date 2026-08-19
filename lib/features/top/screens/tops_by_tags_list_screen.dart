import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/widgets/export.dart';

class ByTagsTopListScreen extends ConsumerWidget {
  const ByTagsTopListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TopListScreen<Tag, TagDao>(
      topType: TopTypeEnum.byTag,
      icon: tagsIcon,
      getSubtitle: (ratingData) =>
          '${TopTypeEnum.byTag.label} - ${ratingData.tag?.name}',
      filterConfig: FiltreConfig<TagDao>(
        daoProvier: tagDaoProvider,
        getId: (tag) => tag.id,
        getLabel: (tag) => tag.name,
      ),
    );
  }
}
