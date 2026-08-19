import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/export.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/features/top/consts.dart';
import 'package:bg_tools/features/top/widgets/generic_tops_list_screen.dart';

class ByArtistsTopListScreen extends ConsumerWidget {
  const ByArtistsTopListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TopListScreen<Artist, ArtistDao>(
      topType: TopTypeEnum.byArtist,
      icon: artistsIcon,
      getSubtitle: (ratingData) =>
          '${TopTypeEnum.byArtist.label} - ${ratingData.artist?.name}',
      filterConfig: FiltreConfig(
        daoProvier: artistDaoProvider,
        getId: (artist) => artist.id,
        getLabel: (artist) => artist.name,
      ),
    );
  }
}
