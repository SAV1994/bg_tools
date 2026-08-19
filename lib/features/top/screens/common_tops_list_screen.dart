import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/widgets/export.dart';

class CommonTopListScreen extends ConsumerWidget {
  const CommonTopListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TopListScreen(
      topType: TopTypeEnum.common,
      icon: gamersIcon,
      getSubtitle: (ratingData) => TopTypeEnum.common.label,
    );
  }
}
