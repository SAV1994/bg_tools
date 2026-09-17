import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/randomizer/game_component.dart';
import 'package:bg_tools/core/services/image_service.dart';

part 'component_dao.g.dart';

@DriftAccessor(tables: [GameComponents])
class ComponentDao extends DatabaseAccessor<AppDatabase>
    with _$ComponentDaoMixin {
  ComponentDao(super.db);

  // Создание новой записи
  Future<int> create({required GameComponentsCompanion component}) async {
    int componentId = await into(gameComponents).insert(component);

    return componentId;
  }

  // Редактирование
  Future<bool> updInstance({
    required int componentId,
    required GameComponentsCompanion component,
  }) async {
    final updateResult = await (update(
      gameComponents,
    )..where((c) => c.id.equals(componentId))).write(component);

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance(int componentId) async {
    final component = await getSingle(componentId);
    if (component != null && component.imagePath != null) {
      await ImageService.deleteImage(component.imagePath);
    }
    return await (delete(
      gameComponents,
    )..where((c) => c.id.equals(componentId))).go();
  }

  // Компонент
  Future<GameComponent?> getSingle(int componentId) async {
    return (select(
      gameComponents,
    )..where((gc) => gc.id.equals(componentId))).getSingleOrNull();
  }
}
