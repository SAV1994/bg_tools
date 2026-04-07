// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Artist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final int id;
  final String name;
  const Artist({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(id: Value(id), name: Value(name));
  }

  factory Artist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Artist copyWith({int? id, String? name}) =>
      Artist(id: id ?? this.id, name: name ?? this.name);
  Artist copyWithCompanion(ArtistsCompanion data) {
    return Artist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist && other.id == this.id && other.name == this.name);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<int> id;
  final Value<String> name;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Artist> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ArtistsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ArtistsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $DesignersTable extends Designers
    with TableInfo<$DesignersTable, Designer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DesignersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'designers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Designer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Designer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Designer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $DesignersTable createAlias(String alias) {
    return $DesignersTable(attachedDatabase, alias);
  }
}

class Designer extends DataClass implements Insertable<Designer> {
  final int id;
  final String name;
  const Designer({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  DesignersCompanion toCompanion(bool nullToAbsent) {
    return DesignersCompanion(id: Value(id), name: Value(name));
  }

  factory Designer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Designer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Designer copyWith({int? id, String? name}) =>
      Designer(id: id ?? this.id, name: name ?? this.name);
  Designer copyWithCompanion(DesignersCompanion data) {
    return Designer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Designer(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Designer && other.id == this.id && other.name == this.name);
}

class DesignersCompanion extends UpdateCompanion<Designer> {
  final Value<int> id;
  final Value<String> name;
  const DesignersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  DesignersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Designer> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  DesignersCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return DesignersCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DesignersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
    'year',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minPlayersMeta = const VerificationMeta(
    'minPlayers',
  );
  @override
  late final GeneratedColumn<int> minPlayers = GeneratedColumn<int>(
    'min_players',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPlayersMeta = const VerificationMeta(
    'maxPlayers',
  );
  @override
  late final GeneratedColumn<int> maxPlayers = GeneratedColumn<int>(
    'max_players',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _isInCollectionMeta = const VerificationMeta(
    'isInCollection',
  );
  @override
  late final GeneratedColumn<bool> isInCollection = GeneratedColumn<bool>(
    'is_in_collection',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_in_collection" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    year,
    minPlayers,
    maxPlayers,
    parentId,
    isInCollection,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('min_players')) {
      context.handle(
        _minPlayersMeta,
        minPlayers.isAcceptableOrUnknown(data['min_players']!, _minPlayersMeta),
      );
    }
    if (data.containsKey('max_players')) {
      context.handle(
        _maxPlayersMeta,
        maxPlayers.isAcceptableOrUnknown(data['max_players']!, _maxPlayersMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_in_collection')) {
      context.handle(
        _isInCollectionMeta,
        isInCollection.isAcceptableOrUnknown(
          data['is_in_collection']!,
          _isInCollectionMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year'],
      ),
      minPlayers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_players'],
      ),
      maxPlayers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_players'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      isInCollection: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_in_collection'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final String name;
  final String? description;
  final String? year;
  final int? minPlayers;
  final int? maxPlayers;
  final int? parentId;
  final bool isInCollection;
  final bool isFavorite;
  const Game({
    required this.id,
    required this.name,
    this.description,
    this.year,
    this.minPlayers,
    this.maxPlayers,
    this.parentId,
    required this.isInCollection,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<String>(year);
    }
    if (!nullToAbsent || minPlayers != null) {
      map['min_players'] = Variable<int>(minPlayers);
    }
    if (!nullToAbsent || maxPlayers != null) {
      map['max_players'] = Variable<int>(maxPlayers);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['is_in_collection'] = Variable<bool>(isInCollection);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      minPlayers: minPlayers == null && nullToAbsent
          ? const Value.absent()
          : Value(minPlayers),
      maxPlayers: maxPlayers == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPlayers),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isInCollection: Value(isInCollection),
      isFavorite: Value(isFavorite),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      year: serializer.fromJson<String?>(json['year']),
      minPlayers: serializer.fromJson<int?>(json['minPlayers']),
      maxPlayers: serializer.fromJson<int?>(json['maxPlayers']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      isInCollection: serializer.fromJson<bool>(json['isInCollection']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'year': serializer.toJson<String?>(year),
      'minPlayers': serializer.toJson<int?>(minPlayers),
      'maxPlayers': serializer.toJson<int?>(maxPlayers),
      'parentId': serializer.toJson<int?>(parentId),
      'isInCollection': serializer.toJson<bool>(isInCollection),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Game copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> year = const Value.absent(),
    Value<int?> minPlayers = const Value.absent(),
    Value<int?> maxPlayers = const Value.absent(),
    Value<int?> parentId = const Value.absent(),
    bool? isInCollection,
    bool? isFavorite,
  }) => Game(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    year: year.present ? year.value : this.year,
    minPlayers: minPlayers.present ? minPlayers.value : this.minPlayers,
    maxPlayers: maxPlayers.present ? maxPlayers.value : this.maxPlayers,
    parentId: parentId.present ? parentId.value : this.parentId,
    isInCollection: isInCollection ?? this.isInCollection,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      year: data.year.present ? data.year.value : this.year,
      minPlayers: data.minPlayers.present
          ? data.minPlayers.value
          : this.minPlayers,
      maxPlayers: data.maxPlayers.present
          ? data.maxPlayers.value
          : this.maxPlayers,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isInCollection: data.isInCollection.present
          ? data.isInCollection.value
          : this.isInCollection,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('year: $year, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('parentId: $parentId, ')
          ..write('isInCollection: $isInCollection, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    year,
    minPlayers,
    maxPlayers,
    parentId,
    isInCollection,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.year == this.year &&
          other.minPlayers == this.minPlayers &&
          other.maxPlayers == this.maxPlayers &&
          other.parentId == this.parentId &&
          other.isInCollection == this.isInCollection &&
          other.isFavorite == this.isFavorite);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> year;
  final Value<int?> minPlayers;
  final Value<int?> maxPlayers;
  final Value<int?> parentId;
  final Value<bool> isInCollection;
  final Value<bool> isFavorite;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isInCollection = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isInCollection = const Value.absent(),
    this.isFavorite = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? year,
    Expression<int>? minPlayers,
    Expression<int>? maxPlayers,
    Expression<int>? parentId,
    Expression<bool>? isInCollection,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (year != null) 'year': year,
      if (minPlayers != null) 'min_players': minPlayers,
      if (maxPlayers != null) 'max_players': maxPlayers,
      if (parentId != null) 'parent_id': parentId,
      if (isInCollection != null) 'is_in_collection': isInCollection,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? year,
    Value<int?>? minPlayers,
    Value<int?>? maxPlayers,
    Value<int?>? parentId,
    Value<bool>? isInCollection,
    Value<bool>? isFavorite,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      year: year ?? this.year,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      parentId: parentId ?? this.parentId,
      isInCollection: isInCollection ?? this.isInCollection,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (minPlayers.present) {
      map['min_players'] = Variable<int>(minPlayers.value);
    }
    if (maxPlayers.present) {
      map['max_players'] = Variable<int>(maxPlayers.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (isInCollection.present) {
      map['is_in_collection'] = Variable<bool>(isInCollection.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('year: $year, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('parentId: $parentId, ')
          ..write('isInCollection: $isInCollection, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $GamesArtistsTable extends GamesArtists
    with TableInfo<$GamesArtistsTable, GamesArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
    'artist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, artistId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games_artists';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamesArtist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId, artistId};
  @override
  GamesArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamesArtist(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}artist_id'],
      )!,
    );
  }

  @override
  $GamesArtistsTable createAlias(String alias) {
    return $GamesArtistsTable(attachedDatabase, alias);
  }
}

class GamesArtist extends DataClass implements Insertable<GamesArtist> {
  final int gameId;
  final int artistId;
  const GamesArtist({required this.gameId, required this.artistId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<int>(gameId);
    map['artist_id'] = Variable<int>(artistId);
    return map;
  }

  GamesArtistsCompanion toCompanion(bool nullToAbsent) {
    return GamesArtistsCompanion(
      gameId: Value(gameId),
      artistId: Value(artistId),
    );
  }

  factory GamesArtist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamesArtist(
      gameId: serializer.fromJson<int>(json['gameId']),
      artistId: serializer.fromJson<int>(json['artistId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<int>(gameId),
      'artistId': serializer.toJson<int>(artistId),
    };
  }

  GamesArtist copyWith({int? gameId, int? artistId}) => GamesArtist(
    gameId: gameId ?? this.gameId,
    artistId: artistId ?? this.artistId,
  );
  GamesArtist copyWithCompanion(GamesArtistsCompanion data) {
    return GamesArtist(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamesArtist(')
          ..write('gameId: $gameId, ')
          ..write('artistId: $artistId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, artistId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamesArtist &&
          other.gameId == this.gameId &&
          other.artistId == this.artistId);
}

class GamesArtistsCompanion extends UpdateCompanion<GamesArtist> {
  final Value<int> gameId;
  final Value<int> artistId;
  final Value<int> rowid;
  const GamesArtistsCompanion({
    this.gameId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesArtistsCompanion.insert({
    required int gameId,
    required int artistId,
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       artistId = Value(artistId);
  static Insertable<GamesArtist> custom({
    Expression<int>? gameId,
    Expression<int>? artistId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (artistId != null) 'artist_id': artistId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesArtistsCompanion copyWith({
    Value<int>? gameId,
    Value<int>? artistId,
    Value<int>? rowid,
  }) {
    return GamesArtistsCompanion(
      gameId: gameId ?? this.gameId,
      artistId: artistId ?? this.artistId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesArtistsCompanion(')
          ..write('gameId: $gameId, ')
          ..write('artistId: $artistId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamesDesignersTable extends GamesDesigners
    with TableInfo<$GamesDesignersTable, GamesDesigner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesDesignersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _designerIdMeta = const VerificationMeta(
    'designerId',
  );
  @override
  late final GeneratedColumn<int> designerId = GeneratedColumn<int>(
    'designer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES designers (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, designerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games_designers';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamesDesigner> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('designer_id')) {
      context.handle(
        _designerIdMeta,
        designerId.isAcceptableOrUnknown(data['designer_id']!, _designerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_designerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId, designerId};
  @override
  GamesDesigner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamesDesigner(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      designerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}designer_id'],
      )!,
    );
  }

  @override
  $GamesDesignersTable createAlias(String alias) {
    return $GamesDesignersTable(attachedDatabase, alias);
  }
}

class GamesDesigner extends DataClass implements Insertable<GamesDesigner> {
  final int gameId;
  final int designerId;
  const GamesDesigner({required this.gameId, required this.designerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<int>(gameId);
    map['designer_id'] = Variable<int>(designerId);
    return map;
  }

  GamesDesignersCompanion toCompanion(bool nullToAbsent) {
    return GamesDesignersCompanion(
      gameId: Value(gameId),
      designerId: Value(designerId),
    );
  }

  factory GamesDesigner.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamesDesigner(
      gameId: serializer.fromJson<int>(json['gameId']),
      designerId: serializer.fromJson<int>(json['designerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<int>(gameId),
      'designerId': serializer.toJson<int>(designerId),
    };
  }

  GamesDesigner copyWith({int? gameId, int? designerId}) => GamesDesigner(
    gameId: gameId ?? this.gameId,
    designerId: designerId ?? this.designerId,
  );
  GamesDesigner copyWithCompanion(GamesDesignersCompanion data) {
    return GamesDesigner(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      designerId: data.designerId.present
          ? data.designerId.value
          : this.designerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamesDesigner(')
          ..write('gameId: $gameId, ')
          ..write('designerId: $designerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, designerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamesDesigner &&
          other.gameId == this.gameId &&
          other.designerId == this.designerId);
}

class GamesDesignersCompanion extends UpdateCompanion<GamesDesigner> {
  final Value<int> gameId;
  final Value<int> designerId;
  final Value<int> rowid;
  const GamesDesignersCompanion({
    this.gameId = const Value.absent(),
    this.designerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesDesignersCompanion.insert({
    required int gameId,
    required int designerId,
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       designerId = Value(designerId);
  static Insertable<GamesDesigner> custom({
    Expression<int>? gameId,
    Expression<int>? designerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (designerId != null) 'designer_id': designerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesDesignersCompanion copyWith({
    Value<int>? gameId,
    Value<int>? designerId,
    Value<int>? rowid,
  }) {
    return GamesDesignersCompanion(
      gameId: gameId ?? this.gameId,
      designerId: designerId ?? this.designerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (designerId.present) {
      map['designer_id'] = Variable<int>(designerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesDesignersCompanion(')
          ..write('gameId: $gameId, ')
          ..write('designerId: $designerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({int? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $GamesTagsTable extends GamesTags
    with TableInfo<$GamesTagsTable, GamesTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamesTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId, tagId};
  @override
  GamesTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamesTag(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $GamesTagsTable createAlias(String alias) {
    return $GamesTagsTable(attachedDatabase, alias);
  }
}

class GamesTag extends DataClass implements Insertable<GamesTag> {
  final int gameId;
  final int tagId;
  const GamesTag({required this.gameId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<int>(gameId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  GamesTagsCompanion toCompanion(bool nullToAbsent) {
    return GamesTagsCompanion(gameId: Value(gameId), tagId: Value(tagId));
  }

  factory GamesTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamesTag(
      gameId: serializer.fromJson<int>(json['gameId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<int>(gameId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  GamesTag copyWith({int? gameId, int? tagId}) =>
      GamesTag(gameId: gameId ?? this.gameId, tagId: tagId ?? this.tagId);
  GamesTag copyWithCompanion(GamesTagsCompanion data) {
    return GamesTag(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamesTag(')
          ..write('gameId: $gameId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamesTag &&
          other.gameId == this.gameId &&
          other.tagId == this.tagId);
}

class GamesTagsCompanion extends UpdateCompanion<GamesTag> {
  final Value<int> gameId;
  final Value<int> tagId;
  final Value<int> rowid;
  const GamesTagsCompanion({
    this.gameId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesTagsCompanion.insert({
    required int gameId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       tagId = Value(tagId);
  static Insertable<GamesTag> custom({
    Expression<int>? gameId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesTagsCompanion copyWith({
    Value<int>? gameId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return GamesTagsCompanion(
      gameId: gameId ?? this.gameId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesTagsCompanion(')
          ..write('gameId: $gameId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamersTable extends Gamers with TableInfo<$GamersTable, Gamer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOwnerMeta = const VerificationMeta(
    'isOwner',
  );
  @override
  late final GeneratedColumn<bool> isOwner = GeneratedColumn<bool>(
    'is_owner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_owner" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    firstName,
    lastName,
    middleName,
    isOwner,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gamers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Gamer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middleNameMeta,
        middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta),
      );
    }
    if (data.containsKey('is_owner')) {
      context.handle(
        _isOwnerMeta,
        isOwner.isAcceptableOrUnknown(data['is_owner']!, _isOwnerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gamer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gamer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      ),
      isOwner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_owner'],
      )!,
    );
  }

  @override
  $GamersTable createAlias(String alias) {
    return $GamersTable(attachedDatabase, alias);
  }
}

class Gamer extends DataClass implements Insertable<Gamer> {
  final int id;
  final String username;
  final String firstName;
  final String? lastName;
  final String? middleName;
  final bool isOwner;
  const Gamer({
    required this.id,
    required this.username,
    required this.firstName,
    this.lastName,
    this.middleName,
    required this.isOwner,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    map['is_owner'] = Variable<bool>(isOwner);
    return map;
  }

  GamersCompanion toCompanion(bool nullToAbsent) {
    return GamersCompanion(
      id: Value(id),
      username: Value(username),
      firstName: Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      middleName: middleName == null && nullToAbsent
          ? const Value.absent()
          : Value(middleName),
      isOwner: Value(isOwner),
    );
  }

  factory Gamer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gamer(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      isOwner: serializer.fromJson<bool>(json['isOwner']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'middleName': serializer.toJson<String?>(middleName),
      'isOwner': serializer.toJson<bool>(isOwner),
    };
  }

  Gamer copyWith({
    int? id,
    String? username,
    String? firstName,
    Value<String?> lastName = const Value.absent(),
    Value<String?> middleName = const Value.absent(),
    bool? isOwner,
  }) => Gamer(
    id: id ?? this.id,
    username: username ?? this.username,
    firstName: firstName ?? this.firstName,
    lastName: lastName.present ? lastName.value : this.lastName,
    middleName: middleName.present ? middleName.value : this.middleName,
    isOwner: isOwner ?? this.isOwner,
  );
  Gamer copyWithCompanion(GamersCompanion data) {
    return Gamer(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      middleName: data.middleName.present
          ? data.middleName.value
          : this.middleName,
      isOwner: data.isOwner.present ? data.isOwner.value : this.isOwner,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gamer(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('middleName: $middleName, ')
          ..write('isOwner: $isOwner')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, firstName, lastName, middleName, isOwner);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gamer &&
          other.id == this.id &&
          other.username == this.username &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.middleName == this.middleName &&
          other.isOwner == this.isOwner);
}

class GamersCompanion extends UpdateCompanion<Gamer> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> firstName;
  final Value<String?> lastName;
  final Value<String?> middleName;
  final Value<bool> isOwner;
  const GamersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.isOwner = const Value.absent(),
  });
  GamersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String firstName,
    this.lastName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.isOwner = const Value.absent(),
  }) : username = Value(username),
       firstName = Value(firstName);
  static Insertable<Gamer> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? middleName,
    Expression<bool>? isOwner,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (middleName != null) 'middle_name': middleName,
      if (isOwner != null) 'is_owner': isOwner,
    });
  }

  GamersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? firstName,
    Value<String?>? lastName,
    Value<String?>? middleName,
    Value<bool>? isOwner,
  }) {
    return GamersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (isOwner.present) {
      map['is_owner'] = Variable<bool>(isOwner.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('middleName: $middleName, ')
          ..write('isOwner: $isOwner')
          ..write(')'))
        .toString();
  }
}

class $GamingSessionsTable extends GamingSessions
    with TableInfo<$GamingSessionsTable, GamingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<int> gameId = GeneratedColumn<int>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    startedAt,
    finishedAt,
    comment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gaming_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GamingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
    );
  }

  @override
  $GamingSessionsTable createAlias(String alias) {
    return $GamingSessionsTable(attachedDatabase, alias);
  }
}

class GamingSession extends DataClass implements Insertable<GamingSession> {
  final int id;
  final int gameId;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final String? comment;
  const GamingSession({
    required this.id,
    required this.gameId,
    this.startedAt,
    this.finishedAt,
    this.comment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  GamingSessionsCompanion toCompanion(bool nullToAbsent) {
    return GamingSessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory GamingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamingSession(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  GamingSession copyWith({
    int? id,
    int? gameId,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<String?> comment = const Value.absent(),
  }) => GamingSession(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    comment: comment.present ? comment.value : this.comment,
  );
  GamingSession copyWithCompanion(GamingSessionsCompanion data) {
    return GamingSession(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamingSession(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, startedAt, finishedAt, comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamingSession &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.comment == this.comment);
}

class GamingSessionsCompanion extends UpdateCompanion<GamingSession> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String?> comment;
  const GamingSessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.comment = const Value.absent(),
  });
  GamingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.comment = const Value.absent(),
  }) : gameId = Value(gameId);
  static Insertable<GamingSession> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (comment != null) 'comment': comment,
    });
  }

  GamingSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<String?>? comment,
  }) {
    return GamingSessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      comment: comment ?? this.comment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }
}

class $GamingSessionsGamersTable extends GamingSessionsGamers
    with TableInfo<$GamingSessionsGamersTable, GamingSessionsGamer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamingSessionsGamersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gamingSessionIdMeta = const VerificationMeta(
    'gamingSessionId',
  );
  @override
  late final GeneratedColumn<int> gamingSessionId = GeneratedColumn<int>(
    'gaming_session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gaming_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _gamerIdMeta = const VerificationMeta(
    'gamerId',
  );
  @override
  late final GeneratedColumn<int> gamerId = GeneratedColumn<int>(
    'gamer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gamers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<int> place = GeneratedColumn<int>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _turnOrderMeta = const VerificationMeta(
    'turnOrder',
  );
  @override
  late final GeneratedColumn<int> turnOrder = GeneratedColumn<int>(
    'turn_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    gamingSessionId,
    gamerId,
    score,
    place,
    turnOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gaming_sessions_gamers';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamingSessionsGamer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gaming_session_id')) {
      context.handle(
        _gamingSessionIdMeta,
        gamingSessionId.isAcceptableOrUnknown(
          data['gaming_session_id']!,
          _gamingSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gamingSessionIdMeta);
    }
    if (data.containsKey('gamer_id')) {
      context.handle(
        _gamerIdMeta,
        gamerId.isAcceptableOrUnknown(data['gamer_id']!, _gamerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gamerIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('turn_order')) {
      context.handle(
        _turnOrderMeta,
        turnOrder.isAcceptableOrUnknown(data['turn_order']!, _turnOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gamingSessionId, gamerId};
  @override
  GamingSessionsGamer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamingSessionsGamer(
      gamingSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gaming_session_id'],
      )!,
      gamerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gamer_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place'],
      ),
      turnOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_order'],
      ),
    );
  }

  @override
  $GamingSessionsGamersTable createAlias(String alias) {
    return $GamingSessionsGamersTable(attachedDatabase, alias);
  }
}

class GamingSessionsGamer extends DataClass
    implements Insertable<GamingSessionsGamer> {
  final int gamingSessionId;
  final int gamerId;
  final int? score;
  final int? place;
  final int? turnOrder;
  const GamingSessionsGamer({
    required this.gamingSessionId,
    required this.gamerId,
    this.score,
    this.place,
    this.turnOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gaming_session_id'] = Variable<int>(gamingSessionId);
    map['gamer_id'] = Variable<int>(gamerId);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<int>(place);
    }
    if (!nullToAbsent || turnOrder != null) {
      map['turn_order'] = Variable<int>(turnOrder);
    }
    return map;
  }

  GamingSessionsGamersCompanion toCompanion(bool nullToAbsent) {
    return GamingSessionsGamersCompanion(
      gamingSessionId: Value(gamingSessionId),
      gamerId: Value(gamerId),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      turnOrder: turnOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(turnOrder),
    );
  }

  factory GamingSessionsGamer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamingSessionsGamer(
      gamingSessionId: serializer.fromJson<int>(json['gamingSessionId']),
      gamerId: serializer.fromJson<int>(json['gamerId']),
      score: serializer.fromJson<int?>(json['score']),
      place: serializer.fromJson<int?>(json['place']),
      turnOrder: serializer.fromJson<int?>(json['turnOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gamingSessionId': serializer.toJson<int>(gamingSessionId),
      'gamerId': serializer.toJson<int>(gamerId),
      'score': serializer.toJson<int?>(score),
      'place': serializer.toJson<int?>(place),
      'turnOrder': serializer.toJson<int?>(turnOrder),
    };
  }

  GamingSessionsGamer copyWith({
    int? gamingSessionId,
    int? gamerId,
    Value<int?> score = const Value.absent(),
    Value<int?> place = const Value.absent(),
    Value<int?> turnOrder = const Value.absent(),
  }) => GamingSessionsGamer(
    gamingSessionId: gamingSessionId ?? this.gamingSessionId,
    gamerId: gamerId ?? this.gamerId,
    score: score.present ? score.value : this.score,
    place: place.present ? place.value : this.place,
    turnOrder: turnOrder.present ? turnOrder.value : this.turnOrder,
  );
  GamingSessionsGamer copyWithCompanion(GamingSessionsGamersCompanion data) {
    return GamingSessionsGamer(
      gamingSessionId: data.gamingSessionId.present
          ? data.gamingSessionId.value
          : this.gamingSessionId,
      gamerId: data.gamerId.present ? data.gamerId.value : this.gamerId,
      score: data.score.present ? data.score.value : this.score,
      place: data.place.present ? data.place.value : this.place,
      turnOrder: data.turnOrder.present ? data.turnOrder.value : this.turnOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamingSessionsGamer(')
          ..write('gamingSessionId: $gamingSessionId, ')
          ..write('gamerId: $gamerId, ')
          ..write('score: $score, ')
          ..write('place: $place, ')
          ..write('turnOrder: $turnOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(gamingSessionId, gamerId, score, place, turnOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamingSessionsGamer &&
          other.gamingSessionId == this.gamingSessionId &&
          other.gamerId == this.gamerId &&
          other.score == this.score &&
          other.place == this.place &&
          other.turnOrder == this.turnOrder);
}

class GamingSessionsGamersCompanion
    extends UpdateCompanion<GamingSessionsGamer> {
  final Value<int> gamingSessionId;
  final Value<int> gamerId;
  final Value<int?> score;
  final Value<int?> place;
  final Value<int?> turnOrder;
  final Value<int> rowid;
  const GamingSessionsGamersCompanion({
    this.gamingSessionId = const Value.absent(),
    this.gamerId = const Value.absent(),
    this.score = const Value.absent(),
    this.place = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamingSessionsGamersCompanion.insert({
    required int gamingSessionId,
    required int gamerId,
    this.score = const Value.absent(),
    this.place = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gamingSessionId = Value(gamingSessionId),
       gamerId = Value(gamerId);
  static Insertable<GamingSessionsGamer> custom({
    Expression<int>? gamingSessionId,
    Expression<int>? gamerId,
    Expression<int>? score,
    Expression<int>? place,
    Expression<int>? turnOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gamingSessionId != null) 'gaming_session_id': gamingSessionId,
      if (gamerId != null) 'gamer_id': gamerId,
      if (score != null) 'score': score,
      if (place != null) 'place': place,
      if (turnOrder != null) 'turn_order': turnOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamingSessionsGamersCompanion copyWith({
    Value<int>? gamingSessionId,
    Value<int>? gamerId,
    Value<int?>? score,
    Value<int?>? place,
    Value<int?>? turnOrder,
    Value<int>? rowid,
  }) {
    return GamingSessionsGamersCompanion(
      gamingSessionId: gamingSessionId ?? this.gamingSessionId,
      gamerId: gamerId ?? this.gamerId,
      score: score ?? this.score,
      place: place ?? this.place,
      turnOrder: turnOrder ?? this.turnOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gamingSessionId.present) {
      map['gaming_session_id'] = Variable<int>(gamingSessionId.value);
    }
    if (gamerId.present) {
      map['gamer_id'] = Variable<int>(gamerId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (place.present) {
      map['place'] = Variable<int>(place.value);
    }
    if (turnOrder.present) {
      map['turn_order'] = Variable<int>(turnOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamingSessionsGamersCompanion(')
          ..write('gamingSessionId: $gamingSessionId, ')
          ..write('gamerId: $gamerId, ')
          ..write('score: $score, ')
          ..write('place: $place, ')
          ..write('turnOrder: $turnOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $DesignersTable designers = $DesignersTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $GamesArtistsTable gamesArtists = $GamesArtistsTable(this);
  late final $GamesDesignersTable gamesDesigners = $GamesDesignersTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $GamesTagsTable gamesTags = $GamesTagsTable(this);
  late final $GamersTable gamers = $GamersTable(this);
  late final $GamingSessionsTable gamingSessions = $GamingSessionsTable(this);
  late final $GamingSessionsGamersTable gamingSessionsGamers =
      $GamingSessionsGamersTable(this);
  late final GamerDao gamerDao = GamerDao(this as AppDatabase);
  late final GameDao gameDao = GameDao(this as AppDatabase);
  late final DesignerDao designerDao = DesignerDao(this as AppDatabase);
  late final ArtistDao artistDao = ArtistDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final GamingSessionDao gamingSessionDao = GamingSessionDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    artists,
    designers,
    games,
    gamesArtists,
    gamesDesigners,
    tags,
    gamesTags,
    gamers,
    gamingSessions,
    gamingSessionsGamers,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games_artists', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'artists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games_artists', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games_designers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'designers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games_designers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('gaming_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gaming_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('gaming_sessions_gamers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gamers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('gaming_sessions_gamers', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ArtistsTableCreateCompanionBuilder =
    ArtistsCompanion Function({Value<int> id, required String name});
typedef $$ArtistsTableUpdateCompanionBuilder =
    ArtistsCompanion Function({Value<int> id, Value<String> name});

final class $$ArtistsTableReferences
    extends BaseReferences<_$AppDatabase, $ArtistsTable, Artist> {
  $$ArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GamesArtistsTable, List<GamesArtist>>
  _gamesArtistsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamesArtists,
    aliasName: $_aliasNameGenerator(db.artists.id, db.gamesArtists.artistId),
  );

  $$GamesArtistsTableProcessedTableManager get gamesArtistsRefs {
    final manager = $$GamesArtistsTableTableManager(
      $_db,
      $_db.gamesArtists,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesArtistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamesArtistsRefs(
    Expression<bool> Function($$GamesArtistsTableFilterComposer f) f,
  ) {
    final $$GamesArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesArtists,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesArtistsTableFilterComposer(
            $db: $db,
            $table: $db.gamesArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtistsTable> {
  $$ArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> gamesArtistsRefs<T extends Object>(
    Expression<T> Function($$GamesArtistsTableAnnotationComposer a) f,
  ) {
    final $$GamesArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesArtists,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.gamesArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArtistsTable,
          Artist,
          $$ArtistsTableFilterComposer,
          $$ArtistsTableOrderingComposer,
          $$ArtistsTableAnnotationComposer,
          $$ArtistsTableCreateCompanionBuilder,
          $$ArtistsTableUpdateCompanionBuilder,
          (Artist, $$ArtistsTableReferences),
          Artist,
          PrefetchHooks Function({bool gamesArtistsRefs})
        > {
  $$ArtistsTableTableManager(_$AppDatabase db, $ArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => ArtistsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  ArtistsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ArtistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamesArtistsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gamesArtistsRefs) db.gamesArtists],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamesArtistsRefs)
                    await $_getPrefetchedData<
                      Artist,
                      $ArtistsTable,
                      GamesArtist
                    >(
                      currentTable: table,
                      referencedTable: $$ArtistsTableReferences
                          ._gamesArtistsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ArtistsTableReferences(
                        db,
                        table,
                        p0,
                      ).gamesArtistsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.artistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArtistsTable,
      Artist,
      $$ArtistsTableFilterComposer,
      $$ArtistsTableOrderingComposer,
      $$ArtistsTableAnnotationComposer,
      $$ArtistsTableCreateCompanionBuilder,
      $$ArtistsTableUpdateCompanionBuilder,
      (Artist, $$ArtistsTableReferences),
      Artist,
      PrefetchHooks Function({bool gamesArtistsRefs})
    >;
typedef $$DesignersTableCreateCompanionBuilder =
    DesignersCompanion Function({Value<int> id, required String name});
typedef $$DesignersTableUpdateCompanionBuilder =
    DesignersCompanion Function({Value<int> id, Value<String> name});

final class $$DesignersTableReferences
    extends BaseReferences<_$AppDatabase, $DesignersTable, Designer> {
  $$DesignersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GamesDesignersTable, List<GamesDesigner>>
  _gamesDesignersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamesDesigners,
    aliasName: $_aliasNameGenerator(
      db.designers.id,
      db.gamesDesigners.designerId,
    ),
  );

  $$GamesDesignersTableProcessedTableManager get gamesDesignersRefs {
    final manager = $$GamesDesignersTableTableManager(
      $_db,
      $_db.gamesDesigners,
    ).filter((f) => f.designerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesDesignersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DesignersTableFilterComposer
    extends Composer<_$AppDatabase, $DesignersTable> {
  $$DesignersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamesDesignersRefs(
    Expression<bool> Function($$GamesDesignersTableFilterComposer f) f,
  ) {
    final $$GamesDesignersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesDesigners,
      getReferencedColumn: (t) => t.designerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesDesignersTableFilterComposer(
            $db: $db,
            $table: $db.gamesDesigners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DesignersTableOrderingComposer
    extends Composer<_$AppDatabase, $DesignersTable> {
  $$DesignersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DesignersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DesignersTable> {
  $$DesignersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> gamesDesignersRefs<T extends Object>(
    Expression<T> Function($$GamesDesignersTableAnnotationComposer a) f,
  ) {
    final $$GamesDesignersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesDesigners,
      getReferencedColumn: (t) => t.designerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesDesignersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamesDesigners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DesignersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DesignersTable,
          Designer,
          $$DesignersTableFilterComposer,
          $$DesignersTableOrderingComposer,
          $$DesignersTableAnnotationComposer,
          $$DesignersTableCreateCompanionBuilder,
          $$DesignersTableUpdateCompanionBuilder,
          (Designer, $$DesignersTableReferences),
          Designer,
          PrefetchHooks Function({bool gamesDesignersRefs})
        > {
  $$DesignersTableTableManager(_$AppDatabase db, $DesignersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DesignersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DesignersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DesignersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => DesignersCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  DesignersCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DesignersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamesDesignersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (gamesDesignersRefs) db.gamesDesigners,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamesDesignersRefs)
                    await $_getPrefetchedData<
                      Designer,
                      $DesignersTable,
                      GamesDesigner
                    >(
                      currentTable: table,
                      referencedTable: $$DesignersTableReferences
                          ._gamesDesignersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DesignersTableReferences(
                            db,
                            table,
                            p0,
                          ).gamesDesignersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.designerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DesignersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DesignersTable,
      Designer,
      $$DesignersTableFilterComposer,
      $$DesignersTableOrderingComposer,
      $$DesignersTableAnnotationComposer,
      $$DesignersTableCreateCompanionBuilder,
      $$DesignersTableUpdateCompanionBuilder,
      (Designer, $$DesignersTableReferences),
      Designer,
      PrefetchHooks Function({bool gamesDesignersRefs})
    >;
typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> year,
      Value<int?> minPlayers,
      Value<int?> maxPlayers,
      Value<int?> parentId,
      Value<bool> isInCollection,
      Value<bool> isFavorite,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> year,
      Value<int?> minPlayers,
      Value<int?> maxPlayers,
      Value<int?> parentId,
      Value<bool> isInCollection,
      Value<bool> isFavorite,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _parentIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.games.parentId, db.games.id),
  );

  $$GamesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GamesArtistsTable, List<GamesArtist>>
  _gamesArtistsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamesArtists,
    aliasName: $_aliasNameGenerator(db.games.id, db.gamesArtists.gameId),
  );

  $$GamesArtistsTableProcessedTableManager get gamesArtistsRefs {
    final manager = $$GamesArtistsTableTableManager(
      $_db,
      $_db.gamesArtists,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesArtistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamesDesignersTable, List<GamesDesigner>>
  _gamesDesignersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamesDesigners,
    aliasName: $_aliasNameGenerator(db.games.id, db.gamesDesigners.gameId),
  );

  $$GamesDesignersTableProcessedTableManager get gamesDesignersRefs {
    final manager = $$GamesDesignersTableTableManager(
      $_db,
      $_db.gamesDesigners,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesDesignersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamesTagsTable, List<GamesTag>>
  _gamesTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamesTags,
    aliasName: $_aliasNameGenerator(db.games.id, db.gamesTags.gameId),
  );

  $$GamesTagsTableProcessedTableManager get gamesTagsRefs {
    final manager = $$GamesTagsTableTableManager(
      $_db,
      $_db.gamesTags,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GamingSessionsTable, List<GamingSession>>
  _gamingSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamingSessions,
    aliasName: $_aliasNameGenerator(db.games.id, db.gamingSessions.gameId),
  );

  $$GamingSessionsTableProcessedTableManager get gamingSessionsRefs {
    final manager = $$GamingSessionsTableTableManager(
      $_db,
      $_db.gamingSessions,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamingSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInCollection => $composableBuilder(
    column: $table.isInCollection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get parentId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gamesArtistsRefs(
    Expression<bool> Function($$GamesArtistsTableFilterComposer f) f,
  ) {
    final $$GamesArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesArtists,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesArtistsTableFilterComposer(
            $db: $db,
            $table: $db.gamesArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gamesDesignersRefs(
    Expression<bool> Function($$GamesDesignersTableFilterComposer f) f,
  ) {
    final $$GamesDesignersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesDesigners,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesDesignersTableFilterComposer(
            $db: $db,
            $table: $db.gamesDesigners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gamesTagsRefs(
    Expression<bool> Function($$GamesTagsTableFilterComposer f) f,
  ) {
    final $$GamesTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesTags,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTagsTableFilterComposer(
            $db: $db,
            $table: $db.gamesTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gamingSessionsRefs(
    Expression<bool> Function($$GamingSessionsTableFilterComposer f) f,
  ) {
    final $$GamingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamingSessions,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.gamingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInCollection => $composableBuilder(
    column: $table.isInCollection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get parentId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isInCollection => $composableBuilder(
    column: $table.isInCollection,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get parentId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gamesArtistsRefs<T extends Object>(
    Expression<T> Function($$GamesArtistsTableAnnotationComposer a) f,
  ) {
    final $$GamesArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesArtists,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.gamesArtists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gamesDesignersRefs<T extends Object>(
    Expression<T> Function($$GamesDesignersTableAnnotationComposer a) f,
  ) {
    final $$GamesDesignersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesDesigners,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesDesignersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamesDesigners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gamesTagsRefs<T extends Object>(
    Expression<T> Function($$GamesTagsTableAnnotationComposer a) f,
  ) {
    final $$GamesTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesTags,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.gamesTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gamingSessionsRefs<T extends Object>(
    Expression<T> Function($$GamingSessionsTableAnnotationComposer a) f,
  ) {
    final $$GamingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamingSessions,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.gamingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({
            bool parentId,
            bool gamesArtistsRefs,
            bool gamesDesignersRefs,
            bool gamesTagsRefs,
            bool gamingSessionsRefs,
          })
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> year = const Value.absent(),
                Value<int?> minPlayers = const Value.absent(),
                Value<int?> maxPlayers = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<bool> isInCollection = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                name: name,
                description: description,
                year: year,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                parentId: parentId,
                isInCollection: isInCollection,
                isFavorite: isFavorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> year = const Value.absent(),
                Value<int?> minPlayers = const Value.absent(),
                Value<int?> maxPlayers = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<bool> isInCollection = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                name: name,
                description: description,
                year: year,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                parentId: parentId,
                isInCollection: isInCollection,
                isFavorite: isFavorite,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                gamesArtistsRefs = false,
                gamesDesignersRefs = false,
                gamesTagsRefs = false,
                gamingSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamesArtistsRefs) db.gamesArtists,
                    if (gamesDesignersRefs) db.gamesDesigners,
                    if (gamesTagsRefs) db.gamesTags,
                    if (gamingSessionsRefs) db.gamingSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable: $$GamesTableReferences
                                        ._parentIdTable(db),
                                    referencedColumn: $$GamesTableReferences
                                        ._parentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamesArtistsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamesArtist
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamesArtistsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesArtistsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamesDesignersRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamesDesigner
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamesDesignersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesDesignersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamesTagsRefs)
                        await $_getPrefetchedData<Game, $GamesTable, GamesTag>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamesTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamingSessionsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamingSession
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamingSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamingSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({
        bool parentId,
        bool gamesArtistsRefs,
        bool gamesDesignersRefs,
        bool gamesTagsRefs,
        bool gamingSessionsRefs,
      })
    >;
typedef $$GamesArtistsTableCreateCompanionBuilder =
    GamesArtistsCompanion Function({
      required int gameId,
      required int artistId,
      Value<int> rowid,
    });
typedef $$GamesArtistsTableUpdateCompanionBuilder =
    GamesArtistsCompanion Function({
      Value<int> gameId,
      Value<int> artistId,
      Value<int> rowid,
    });

final class $$GamesArtistsTableReferences
    extends BaseReferences<_$AppDatabase, $GamesArtistsTable, GamesArtist> {
  $$GamesArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamesArtists.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ArtistsTable _artistIdTable(_$AppDatabase db) =>
      db.artists.createAlias(
        $_aliasNameGenerator(db.gamesArtists.artistId, db.artists.id),
      );

  $$ArtistsTableProcessedTableManager get artistId {
    final $_column = $_itemColumn<int>('artist_id')!;

    final manager = $$ArtistsTableTableManager(
      $_db,
      $_db.artists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamesArtistsTableFilterComposer
    extends Composer<_$AppDatabase, $GamesArtistsTable> {
  $$GamesArtistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableFilterComposer get artistId {
    final $$ArtistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableFilterComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesArtistsTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesArtistsTable> {
  $$GamesArtistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableOrderingComposer get artistId {
    final $$ArtistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableOrderingComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesArtistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesArtistsTable> {
  $$GamesArtistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtistsTableAnnotationComposer get artistId {
    final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artistId,
      referencedTable: $db.artists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtistsTableAnnotationComposer(
            $db: $db,
            $table: $db.artists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesArtistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesArtistsTable,
          GamesArtist,
          $$GamesArtistsTableFilterComposer,
          $$GamesArtistsTableOrderingComposer,
          $$GamesArtistsTableAnnotationComposer,
          $$GamesArtistsTableCreateCompanionBuilder,
          $$GamesArtistsTableUpdateCompanionBuilder,
          (GamesArtist, $$GamesArtistsTableReferences),
          GamesArtist,
          PrefetchHooks Function({bool gameId, bool artistId})
        > {
  $$GamesArtistsTableTableManager(_$AppDatabase db, $GamesArtistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesArtistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesArtistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesArtistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> gameId = const Value.absent(),
                Value<int> artistId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesArtistsCompanion(
                gameId: gameId,
                artistId: artistId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gameId,
                required int artistId,
                Value<int> rowid = const Value.absent(),
              }) => GamesArtistsCompanion.insert(
                gameId: gameId,
                artistId: artistId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamesArtistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, artistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$GamesArtistsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$GamesArtistsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (artistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.artistId,
                                referencedTable: $$GamesArtistsTableReferences
                                    ._artistIdTable(db),
                                referencedColumn: $$GamesArtistsTableReferences
                                    ._artistIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamesArtistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesArtistsTable,
      GamesArtist,
      $$GamesArtistsTableFilterComposer,
      $$GamesArtistsTableOrderingComposer,
      $$GamesArtistsTableAnnotationComposer,
      $$GamesArtistsTableCreateCompanionBuilder,
      $$GamesArtistsTableUpdateCompanionBuilder,
      (GamesArtist, $$GamesArtistsTableReferences),
      GamesArtist,
      PrefetchHooks Function({bool gameId, bool artistId})
    >;
typedef $$GamesDesignersTableCreateCompanionBuilder =
    GamesDesignersCompanion Function({
      required int gameId,
      required int designerId,
      Value<int> rowid,
    });
typedef $$GamesDesignersTableUpdateCompanionBuilder =
    GamesDesignersCompanion Function({
      Value<int> gameId,
      Value<int> designerId,
      Value<int> rowid,
    });

final class $$GamesDesignersTableReferences
    extends BaseReferences<_$AppDatabase, $GamesDesignersTable, GamesDesigner> {
  $$GamesDesignersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamesDesigners.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DesignersTable _designerIdTable(_$AppDatabase db) =>
      db.designers.createAlias(
        $_aliasNameGenerator(db.gamesDesigners.designerId, db.designers.id),
      );

  $$DesignersTableProcessedTableManager get designerId {
    final $_column = $_itemColumn<int>('designer_id')!;

    final manager = $$DesignersTableTableManager(
      $_db,
      $_db.designers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_designerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamesDesignersTableFilterComposer
    extends Composer<_$AppDatabase, $GamesDesignersTable> {
  $$GamesDesignersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DesignersTableFilterComposer get designerId {
    final $$DesignersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.designerId,
      referencedTable: $db.designers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignersTableFilterComposer(
            $db: $db,
            $table: $db.designers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesDesignersTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesDesignersTable> {
  $$GamesDesignersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DesignersTableOrderingComposer get designerId {
    final $$DesignersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.designerId,
      referencedTable: $db.designers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignersTableOrderingComposer(
            $db: $db,
            $table: $db.designers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesDesignersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesDesignersTable> {
  $$GamesDesignersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DesignersTableAnnotationComposer get designerId {
    final $$DesignersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.designerId,
      referencedTable: $db.designers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DesignersTableAnnotationComposer(
            $db: $db,
            $table: $db.designers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesDesignersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesDesignersTable,
          GamesDesigner,
          $$GamesDesignersTableFilterComposer,
          $$GamesDesignersTableOrderingComposer,
          $$GamesDesignersTableAnnotationComposer,
          $$GamesDesignersTableCreateCompanionBuilder,
          $$GamesDesignersTableUpdateCompanionBuilder,
          (GamesDesigner, $$GamesDesignersTableReferences),
          GamesDesigner,
          PrefetchHooks Function({bool gameId, bool designerId})
        > {
  $$GamesDesignersTableTableManager(
    _$AppDatabase db,
    $GamesDesignersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesDesignersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesDesignersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesDesignersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> gameId = const Value.absent(),
                Value<int> designerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesDesignersCompanion(
                gameId: gameId,
                designerId: designerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gameId,
                required int designerId,
                Value<int> rowid = const Value.absent(),
              }) => GamesDesignersCompanion.insert(
                gameId: gameId,
                designerId: designerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamesDesignersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, designerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$GamesDesignersTableReferences
                                    ._gameIdTable(db),
                                referencedColumn:
                                    $$GamesDesignersTableReferences
                                        ._gameIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (designerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.designerId,
                                referencedTable: $$GamesDesignersTableReferences
                                    ._designerIdTable(db),
                                referencedColumn:
                                    $$GamesDesignersTableReferences
                                        ._designerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamesDesignersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesDesignersTable,
      GamesDesigner,
      $$GamesDesignersTableFilterComposer,
      $$GamesDesignersTableOrderingComposer,
      $$GamesDesignersTableAnnotationComposer,
      $$GamesDesignersTableCreateCompanionBuilder,
      $$GamesDesignersTableUpdateCompanionBuilder,
      (GamesDesigner, $$GamesDesignersTableReferences),
      GamesDesigner,
      PrefetchHooks Function({bool gameId, bool designerId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({Value<int> id, required String name});
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({Value<int> id, Value<String> name});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GamesTagsTable, List<GamesTag>>
  _gamesTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamesTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.gamesTags.tagId),
  );

  $$GamesTagsTableProcessedTableManager get gamesTagsRefs {
    final manager = $$GamesTagsTableTableManager(
      $_db,
      $_db.gamesTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamesTagsRefs(
    Expression<bool> Function($$GamesTagsTableFilterComposer f) f,
  ) {
    final $$GamesTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTagsTableFilterComposer(
            $db: $db,
            $table: $db.gamesTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> gamesTagsRefs<T extends Object>(
    Expression<T> Function($$GamesTagsTableAnnotationComposer a) f,
  ) {
    final $$GamesTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamesTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.gamesTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool gamesTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TagsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  TagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gamesTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gamesTagsRefs) db.gamesTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamesTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, GamesTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._gamesTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).gamesTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool gamesTagsRefs})
    >;
typedef $$GamesTagsTableCreateCompanionBuilder =
    GamesTagsCompanion Function({
      required int gameId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$GamesTagsTableUpdateCompanionBuilder =
    GamesTagsCompanion Function({
      Value<int> gameId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$GamesTagsTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTagsTable, GamesTag> {
  $$GamesTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamesTags.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias($_aliasNameGenerator(db.gamesTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamesTagsTableFilterComposer
    extends Composer<_$AppDatabase, $GamesTagsTable> {
  $$GamesTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTagsTable> {
  $$GamesTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTagsTable> {
  $$GamesTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTagsTable,
          GamesTag,
          $$GamesTagsTableFilterComposer,
          $$GamesTagsTableOrderingComposer,
          $$GamesTagsTableAnnotationComposer,
          $$GamesTagsTableCreateCompanionBuilder,
          $$GamesTagsTableUpdateCompanionBuilder,
          (GamesTag, $$GamesTagsTableReferences),
          GamesTag,
          PrefetchHooks Function({bool gameId, bool tagId})
        > {
  $$GamesTagsTableTableManager(_$AppDatabase db, $GamesTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> gameId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesTagsCompanion(
                gameId: gameId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gameId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => GamesTagsCompanion.insert(
                gameId: gameId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamesTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$GamesTagsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$GamesTagsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$GamesTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$GamesTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamesTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTagsTable,
      GamesTag,
      $$GamesTagsTableFilterComposer,
      $$GamesTagsTableOrderingComposer,
      $$GamesTagsTableAnnotationComposer,
      $$GamesTagsTableCreateCompanionBuilder,
      $$GamesTagsTableUpdateCompanionBuilder,
      (GamesTag, $$GamesTagsTableReferences),
      GamesTag,
      PrefetchHooks Function({bool gameId, bool tagId})
    >;
typedef $$GamersTableCreateCompanionBuilder =
    GamersCompanion Function({
      Value<int> id,
      required String username,
      required String firstName,
      Value<String?> lastName,
      Value<String?> middleName,
      Value<bool> isOwner,
    });
typedef $$GamersTableUpdateCompanionBuilder =
    GamersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> firstName,
      Value<String?> lastName,
      Value<String?> middleName,
      Value<bool> isOwner,
    });

final class $$GamersTableReferences
    extends BaseReferences<_$AppDatabase, $GamersTable, Gamer> {
  $$GamersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $GamingSessionsGamersTable,
    List<GamingSessionsGamer>
  >
  _gamingSessionsGamersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamingSessionsGamers,
        aliasName: $_aliasNameGenerator(
          db.gamers.id,
          db.gamingSessionsGamers.gamerId,
        ),
      );

  $$GamingSessionsGamersTableProcessedTableManager
  get gamingSessionsGamersRefs {
    final manager = $$GamingSessionsGamersTableTableManager(
      $_db,
      $_db.gamingSessionsGamers,
    ).filter((f) => f.gamerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gamingSessionsGamersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamersTableFilterComposer
    extends Composer<_$AppDatabase, $GamersTable> {
  $$GamersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOwner => $composableBuilder(
    column: $table.isOwner,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamingSessionsGamersRefs(
    Expression<bool> Function($$GamingSessionsGamersTableFilterComposer f) f,
  ) {
    final $$GamingSessionsGamersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamingSessionsGamers,
      getReferencedColumn: (t) => t.gamerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsGamersTableFilterComposer(
            $db: $db,
            $table: $db.gamingSessionsGamers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamersTableOrderingComposer
    extends Composer<_$AppDatabase, $GamersTable> {
  $$GamersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOwner => $composableBuilder(
    column: $table.isOwner,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamersTable> {
  $$GamersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOwner =>
      $composableBuilder(column: $table.isOwner, builder: (column) => column);

  Expression<T> gamingSessionsGamersRefs<T extends Object>(
    Expression<T> Function($$GamingSessionsGamersTableAnnotationComposer a) f,
  ) {
    final $$GamingSessionsGamersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamingSessionsGamers,
          getReferencedColumn: (t) => t.gamerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamingSessionsGamersTableAnnotationComposer(
                $db: $db,
                $table: $db.gamingSessionsGamers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GamersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamersTable,
          Gamer,
          $$GamersTableFilterComposer,
          $$GamersTableOrderingComposer,
          $$GamersTableAnnotationComposer,
          $$GamersTableCreateCompanionBuilder,
          $$GamersTableUpdateCompanionBuilder,
          (Gamer, $$GamersTableReferences),
          Gamer,
          PrefetchHooks Function({bool gamingSessionsGamersRefs})
        > {
  $$GamersTableTableManager(_$AppDatabase db, $GamersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<bool> isOwner = const Value.absent(),
              }) => GamersCompanion(
                id: id,
                username: username,
                firstName: firstName,
                lastName: lastName,
                middleName: middleName,
                isOwner: isOwner,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String firstName,
                Value<String?> lastName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<bool> isOwner = const Value.absent(),
              }) => GamersCompanion.insert(
                id: id,
                username: username,
                firstName: firstName,
                lastName: lastName,
                middleName: middleName,
                isOwner: isOwner,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gamingSessionsGamersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (gamingSessionsGamersRefs) db.gamingSessionsGamers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamingSessionsGamersRefs)
                    await $_getPrefetchedData<
                      Gamer,
                      $GamersTable,
                      GamingSessionsGamer
                    >(
                      currentTable: table,
                      referencedTable: $$GamersTableReferences
                          ._gamingSessionsGamersRefsTable(db),
                      managerFromTypedResult: (p0) => $$GamersTableReferences(
                        db,
                        table,
                        p0,
                      ).gamingSessionsGamersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gamerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GamersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamersTable,
      Gamer,
      $$GamersTableFilterComposer,
      $$GamersTableOrderingComposer,
      $$GamersTableAnnotationComposer,
      $$GamersTableCreateCompanionBuilder,
      $$GamersTableUpdateCompanionBuilder,
      (Gamer, $$GamersTableReferences),
      Gamer,
      PrefetchHooks Function({bool gamingSessionsGamersRefs})
    >;
typedef $$GamingSessionsTableCreateCompanionBuilder =
    GamingSessionsCompanion Function({
      Value<int> id,
      required int gameId,
      Value<DateTime?> startedAt,
      Value<DateTime?> finishedAt,
      Value<String?> comment,
    });
typedef $$GamingSessionsTableUpdateCompanionBuilder =
    GamingSessionsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<DateTime?> startedAt,
      Value<DateTime?> finishedAt,
      Value<String?> comment,
    });

final class $$GamingSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $GamingSessionsTable, GamingSession> {
  $$GamingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamingSessions.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<int>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $GamingSessionsGamersTable,
    List<GamingSessionsGamer>
  >
  _gamingSessionsGamersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamingSessionsGamers,
        aliasName: $_aliasNameGenerator(
          db.gamingSessions.id,
          db.gamingSessionsGamers.gamingSessionId,
        ),
      );

  $$GamingSessionsGamersTableProcessedTableManager
  get gamingSessionsGamersRefs {
    final manager = $$GamingSessionsGamersTableTableManager(
      $_db,
      $_db.gamingSessionsGamers,
    ).filter((f) => f.gamingSessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gamingSessionsGamersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $GamingSessionsTable> {
  $$GamingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gamingSessionsGamersRefs(
    Expression<bool> Function($$GamingSessionsGamersTableFilterComposer f) f,
  ) {
    final $$GamingSessionsGamersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamingSessionsGamers,
      getReferencedColumn: (t) => t.gamingSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsGamersTableFilterComposer(
            $db: $db,
            $table: $db.gamingSessionsGamers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GamingSessionsTable> {
  $$GamingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamingSessionsTable> {
  $$GamingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gamingSessionsGamersRefs<T extends Object>(
    Expression<T> Function($$GamingSessionsGamersTableAnnotationComposer a) f,
  ) {
    final $$GamingSessionsGamersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamingSessionsGamers,
          getReferencedColumn: (t) => t.gamingSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamingSessionsGamersTableAnnotationComposer(
                $db: $db,
                $table: $db.gamingSessionsGamers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GamingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamingSessionsTable,
          GamingSession,
          $$GamingSessionsTableFilterComposer,
          $$GamingSessionsTableOrderingComposer,
          $$GamingSessionsTableAnnotationComposer,
          $$GamingSessionsTableCreateCompanionBuilder,
          $$GamingSessionsTableUpdateCompanionBuilder,
          (GamingSession, $$GamingSessionsTableReferences),
          GamingSession,
          PrefetchHooks Function({bool gameId, bool gamingSessionsGamersRefs})
        > {
  $$GamingSessionsTableTableManager(
    _$AppDatabase db,
    $GamingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String?> comment = const Value.absent(),
              }) => GamingSessionsCompanion(
                id: id,
                gameId: gameId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                comment: comment,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String?> comment = const Value.absent(),
              }) => GamingSessionsCompanion.insert(
                id: id,
                gameId: gameId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                comment: comment,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gameId = false, gamingSessionsGamersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamingSessionsGamersRefs) db.gamingSessionsGamers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.gameId,
                                    referencedTable:
                                        $$GamingSessionsTableReferences
                                            ._gameIdTable(db),
                                    referencedColumn:
                                        $$GamingSessionsTableReferences
                                            ._gameIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamingSessionsGamersRefs)
                        await $_getPrefetchedData<
                          GamingSession,
                          $GamingSessionsTable,
                          GamingSessionsGamer
                        >(
                          currentTable: table,
                          referencedTable: $$GamingSessionsTableReferences
                              ._gamingSessionsGamersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamingSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).gamingSessionsGamersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gamingSessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamingSessionsTable,
      GamingSession,
      $$GamingSessionsTableFilterComposer,
      $$GamingSessionsTableOrderingComposer,
      $$GamingSessionsTableAnnotationComposer,
      $$GamingSessionsTableCreateCompanionBuilder,
      $$GamingSessionsTableUpdateCompanionBuilder,
      (GamingSession, $$GamingSessionsTableReferences),
      GamingSession,
      PrefetchHooks Function({bool gameId, bool gamingSessionsGamersRefs})
    >;
typedef $$GamingSessionsGamersTableCreateCompanionBuilder =
    GamingSessionsGamersCompanion Function({
      required int gamingSessionId,
      required int gamerId,
      Value<int?> score,
      Value<int?> place,
      Value<int?> turnOrder,
      Value<int> rowid,
    });
typedef $$GamingSessionsGamersTableUpdateCompanionBuilder =
    GamingSessionsGamersCompanion Function({
      Value<int> gamingSessionId,
      Value<int> gamerId,
      Value<int?> score,
      Value<int?> place,
      Value<int?> turnOrder,
      Value<int> rowid,
    });

final class $$GamingSessionsGamersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GamingSessionsGamersTable,
          GamingSessionsGamer
        > {
  $$GamingSessionsGamersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamingSessionsTable _gamingSessionIdTable(_$AppDatabase db) =>
      db.gamingSessions.createAlias(
        $_aliasNameGenerator(
          db.gamingSessionsGamers.gamingSessionId,
          db.gamingSessions.id,
        ),
      );

  $$GamingSessionsTableProcessedTableManager get gamingSessionId {
    final $_column = $_itemColumn<int>('gaming_session_id')!;

    final manager = $$GamingSessionsTableTableManager(
      $_db,
      $_db.gamingSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gamingSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamersTable _gamerIdTable(_$AppDatabase db) => db.gamers.createAlias(
    $_aliasNameGenerator(db.gamingSessionsGamers.gamerId, db.gamers.id),
  );

  $$GamersTableProcessedTableManager get gamerId {
    final $_column = $_itemColumn<int>('gamer_id')!;

    final manager = $$GamersTableTableManager(
      $_db,
      $_db.gamers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gamerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamingSessionsGamersTableFilterComposer
    extends Composer<_$AppDatabase, $GamingSessionsGamersTable> {
  $$GamingSessionsGamersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get turnOrder => $composableBuilder(
    column: $table.turnOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$GamingSessionsTableFilterComposer get gamingSessionId {
    final $$GamingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gamingSessionId,
      referencedTable: $db.gamingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.gamingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamersTableFilterComposer get gamerId {
    final $$GamersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gamerId,
      referencedTable: $db.gamers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamersTableFilterComposer(
            $db: $db,
            $table: $db.gamers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamingSessionsGamersTableOrderingComposer
    extends Composer<_$AppDatabase, $GamingSessionsGamersTable> {
  $$GamingSessionsGamersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get turnOrder => $composableBuilder(
    column: $table.turnOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamingSessionsTableOrderingComposer get gamingSessionId {
    final $$GamingSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gamingSessionId,
      referencedTable: $db.gamingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.gamingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamersTableOrderingComposer get gamerId {
    final $$GamersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gamerId,
      referencedTable: $db.gamers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamersTableOrderingComposer(
            $db: $db,
            $table: $db.gamers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamingSessionsGamersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamingSessionsGamersTable> {
  $$GamingSessionsGamersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<int> get turnOrder =>
      $composableBuilder(column: $table.turnOrder, builder: (column) => column);

  $$GamingSessionsTableAnnotationComposer get gamingSessionId {
    final $$GamingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gamingSessionId,
      referencedTable: $db.gamingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.gamingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GamersTableAnnotationComposer get gamerId {
    final $$GamersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gamerId,
      referencedTable: $db.gamers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamingSessionsGamersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamingSessionsGamersTable,
          GamingSessionsGamer,
          $$GamingSessionsGamersTableFilterComposer,
          $$GamingSessionsGamersTableOrderingComposer,
          $$GamingSessionsGamersTableAnnotationComposer,
          $$GamingSessionsGamersTableCreateCompanionBuilder,
          $$GamingSessionsGamersTableUpdateCompanionBuilder,
          (GamingSessionsGamer, $$GamingSessionsGamersTableReferences),
          GamingSessionsGamer,
          PrefetchHooks Function({bool gamingSessionId, bool gamerId})
        > {
  $$GamingSessionsGamersTableTableManager(
    _$AppDatabase db,
    $GamingSessionsGamersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamingSessionsGamersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamingSessionsGamersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GamingSessionsGamersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> gamingSessionId = const Value.absent(),
                Value<int> gamerId = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> place = const Value.absent(),
                Value<int?> turnOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamingSessionsGamersCompanion(
                gamingSessionId: gamingSessionId,
                gamerId: gamerId,
                score: score,
                place: place,
                turnOrder: turnOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gamingSessionId,
                required int gamerId,
                Value<int?> score = const Value.absent(),
                Value<int?> place = const Value.absent(),
                Value<int?> turnOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamingSessionsGamersCompanion.insert(
                gamingSessionId: gamingSessionId,
                gamerId: gamerId,
                score: score,
                place: place,
                turnOrder: turnOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamingSessionsGamersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamingSessionId = false, gamerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gamingSessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gamingSessionId,
                                referencedTable:
                                    $$GamingSessionsGamersTableReferences
                                        ._gamingSessionIdTable(db),
                                referencedColumn:
                                    $$GamingSessionsGamersTableReferences
                                        ._gamingSessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (gamerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gamerId,
                                referencedTable:
                                    $$GamingSessionsGamersTableReferences
                                        ._gamerIdTable(db),
                                referencedColumn:
                                    $$GamingSessionsGamersTableReferences
                                        ._gamerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamingSessionsGamersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamingSessionsGamersTable,
      GamingSessionsGamer,
      $$GamingSessionsGamersTableFilterComposer,
      $$GamingSessionsGamersTableOrderingComposer,
      $$GamingSessionsGamersTableAnnotationComposer,
      $$GamingSessionsGamersTableCreateCompanionBuilder,
      $$GamingSessionsGamersTableUpdateCompanionBuilder,
      (GamingSessionsGamer, $$GamingSessionsGamersTableReferences),
      GamingSessionsGamer,
      PrefetchHooks Function({bool gamingSessionId, bool gamerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db, _db.designers);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$GamesArtistsTableTableManager get gamesArtists =>
      $$GamesArtistsTableTableManager(_db, _db.gamesArtists);
  $$GamesDesignersTableTableManager get gamesDesigners =>
      $$GamesDesignersTableTableManager(_db, _db.gamesDesigners);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$GamesTagsTableTableManager get gamesTags =>
      $$GamesTagsTableTableManager(_db, _db.gamesTags);
  $$GamersTableTableManager get gamers =>
      $$GamersTableTableManager(_db, _db.gamers);
  $$GamingSessionsTableTableManager get gamingSessions =>
      $$GamingSessionsTableTableManager(_db, _db.gamingSessions);
  $$GamingSessionsGamersTableTableManager get gamingSessionsGamers =>
      $$GamingSessionsGamersTableTableManager(_db, _db.gamingSessionsGamers);
}
