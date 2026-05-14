// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counting_template_dao.dart';

// ignore_for_file: type=lint
mixin _$CountingTemplateDaoMixin on DatabaseAccessor<AppDatabase> {
  $CountingTemplatesTable get countingTemplates =>
      attachedDatabase.countingTemplates;
  CountingTemplateDaoManager get managers => CountingTemplateDaoManager(this);
}

class CountingTemplateDaoManager {
  final _$CountingTemplateDaoMixin _db;
  CountingTemplateDaoManager(this._db);
  $$CountingTemplatesTableTableManager get countingTemplates =>
      $$CountingTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.countingTemplates,
      );
}
