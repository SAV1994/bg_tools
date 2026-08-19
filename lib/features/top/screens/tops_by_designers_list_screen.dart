import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/widgets/export.dart';

class ByDesignersTopListScreen extends ConsumerWidget {
  const ByDesignersTopListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TopListScreen<Designer, DesignerDao>(
      topType: TopTypeEnum.byDesigner,
      icon: designersIcon,
      getSubtitle: (ratingData) =>
          '${TopTypeEnum.byDesigner.label} - ${ratingData.designer?.name}',
      filterConfig: FiltreConfig<DesignerDao>(
        daoProvier: designerDaoProvider,
        getId: (designer) => designer.id,
        getLabel: (designer) => designer.name,
      ),
    );
  }
}
