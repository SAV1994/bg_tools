import 'package:drift/drift.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/database/tables/randomizer/component_type.dart';
import 'package:bg_tools/core/database/tables/randomizer/game_component.dart';
import 'package:bg_tools/core/dataclasses/export.dart';
import 'package:bg_tools/core/services/image_service.dart';

part 'component_type_dao.g.dart';

@DriftAccessor(tables: [ComponentTypes, GameComponents])
class ComponentTypeDao extends DatabaseAccessor<AppDatabase>
    with _$ComponentTypeDaoMixin {
  ComponentTypeDao(super.db);

  // Создание новой записи
  Future<int> create({required ComponentTypesCompanion componentType}) async {
    int componentTypeId = await into(componentTypes).insert(componentType);

    return componentTypeId;
  }

  // Редактирование
  Future<bool> updInstance({
    required int componentTypeId,
    required ComponentTypesCompanion componentType,
  }) async {
    final updateResult = await (update(
      componentTypes,
    )..where((ct) => ct.id.equals(componentTypeId))).write(componentType);

    return updateResult > 0;
  }

  // Удаление
  Future<int> delInstance({required int componentTypeId}) async {
    final List<GameComponent> components = await (select(
      gameComponents,
    )..where((gc) => gc.componentTypeId.equals(componentTypeId))).get();
    for (final GameComponent component in components) {
      if (component.imagePath != null) {
        await ImageService.deleteImage(component.imagePath);
      }
      await (delete(
        gameComponents,
      )..where((c) => c.id.equals(component.id))).go();
    }

    return await (delete(
      componentTypes,
    )..where((rl) => rl.id.equals(componentTypeId))).go();
  }

  // Все Типы компонентов с компонентами
  Future<List<ComponentTypeData>> getAll(int gameId) async {
    SimpleSelectStatement<$ComponentTypesTable, ComponentType> query =
        _getBaseQuery()..where((ct) => ct.gameId.equals(gameId));

    final joinedQuery = query.join([
      leftOuterJoin(
        gameComponents,
        gameComponents.componentTypeId.equalsExp(componentTypes.id),
      ),
    ]);

    final rows = await joinedQuery.get();

    final Map<int, dynamic> componentTypesData = {};
    for (TypedResult row in rows) {
      final ComponentType componentType = row.readTable(componentTypes);
      final GameComponent? gameComponent = row.readTableOrNull(gameComponents);

      if (componentTypesData[componentType.id] == null) {
        componentTypesData[componentType.id] = {
          'gamingSession': componentType,
          'gameComponents': gameComponent != null ? [gameComponent] : [],
        };
      } else {
        componentTypesData[componentType.id]['gameComponents'].add(
          gameComponent,
        );
      }
    }

    return componentTypesData.values.map((value) {
      value['gameComponents'].sort((a, b) {
        final nameA = a.name as String;
        final nameB = b.name as String;
        return nameA.compareTo(nameB);
      });

      return ComponentTypeData(
        componentType: value['gamingSession'],
        components: value['gameComponents'].isNotEmpty
            ? value['gameComponents']
            : [],
      );
    }).toList();
  }

  // Тип компонентов с компонентами
  Future<ComponentTypeData> get({required int componentTypeId}) async {
    ComponentType? componentType = await (select(
      componentTypes,
    )..where((ct) => ct.id.equals(componentTypeId))).getSingleOrNull();

    List<GameComponent> components =
        await (select(gameComponents)
              ..orderBy([
                (c) => OrderingTerm(
                  expression: c.name.collate(const Collate('UNICODE_CI')),
                  mode: OrderingMode.asc,
                ),
              ])
              ..where((c) => c.componentTypeId.equals(componentTypeId)))
            .get();

    return ComponentTypeData(
      componentType: componentType!,
      components: components,
    );
  }

  SimpleSelectStatement<$ComponentTypesTable, ComponentType> _getBaseQuery({
    bool reverse = false,
  }) {
    return select(componentTypes)..orderBy([
      (t) => OrderingTerm(
        expression: t.name.collate(const Collate('UNICODE_CI')),
        mode: reverse ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);
  }
}
