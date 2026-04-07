import 'package:flutter/material.dart';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/daos/designer_dao.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/screens/generic/list_with_modal_form.dart';

class DesignersListScreen extends ConsumerWidget {
  const DesignersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListWithModalFormScreen<ListWithModalFormConfig>(
      config: ListWithModalFormConfig<Designer, DesignerDao, DesignersCompanion>(
        pageTitle: 'Геймдизайнеры',
        dataProvider: designersDataProvider,
        daoProvier: designerDaoProvider,
        companionFactory: (name) => DesignersCompanion(name: Value(name)),
        imputName: 'Геймдизайнер *'
      )
    );
  }
}
