import 'package:flutter/material.dart';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/artist/artist_dao.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/screens/generic/list_with_modal_form.dart';

class ArtistsListScreen extends ConsumerWidget {
  const ArtistsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListWithModalFormScreen<ListWithModalFormConfig>(
      config: ListWithModalFormConfig<Artist, ArtistDao, ArtistsCompanion>(
        pageTitle: 'Художники',
        icon: Icons.border_color,
        dataProvider: artistsDataProvider,
        daoProvier: artistDaoProvider,
        companionFactory: (name) => ArtistsCompanion(name: Value(name)),
        imputName: 'Художник *'
      )
    );
  }
}
