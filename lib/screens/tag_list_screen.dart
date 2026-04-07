import 'package:flutter/material.dart';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/tag_dao.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/screens/generic/list_with_modal_form.dart';

class TagsListScreen extends ConsumerWidget {
  const TagsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListWithModalFormScreen<ListWithModalFormConfig>(
      config: ListWithModalFormConfig<Tag, TagDao, TagsCompanion>(
        pageTitle: 'Метки категорий',
        dataProvider: tagsDataProvider,
        daoProvier: tagDaoProvider,
        companionFactory: (name) => TagsCompanion(name: Value(name)),
        imputName: 'Метка категории *'
      )
    );
  }
}
