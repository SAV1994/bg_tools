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

class $CountingTemplatesTable extends CountingTemplates
    with TableInfo<$CountingTemplatesTable, CountingTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountingTemplatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counting_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<CountingTemplate> instance, {
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
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CountingTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CountingTemplate(
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
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $CountingTemplatesTable createAlias(String alias) {
    return $CountingTemplatesTable(attachedDatabase, alias);
  }
}

class CountingTemplate extends DataClass
    implements Insertable<CountingTemplate> {
  final int id;
  final String name;
  final String? description;
  final String data;
  const CountingTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['data'] = Variable<String>(data);
    return map;
  }

  CountingTemplatesCompanion toCompanion(bool nullToAbsent) {
    return CountingTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      data: Value(data),
    );
  }

  factory CountingTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CountingTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'data': serializer.toJson<String>(data),
    };
  }

  CountingTemplate copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? data,
  }) => CountingTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    data: data ?? this.data,
  );
  CountingTemplate copyWithCompanion(CountingTemplatesCompanion data) {
    return CountingTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CountingTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CountingTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.data == this.data);
}

class CountingTemplatesCompanion extends UpdateCompanion<CountingTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> data;
  const CountingTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.data = const Value.absent(),
  });
  CountingTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required String data,
  }) : name = Value(name),
       data = Value(data);
  static Insertable<CountingTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (data != null) 'data': data,
    });
  }

  CountingTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? data,
  }) {
    return CountingTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      data: data ?? this.data,
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
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountingTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('data: $data')
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
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (rating >= 0 AND rating <= 10)',
  );
  static const VerificationMeta _isStandaloneMeta = const VerificationMeta(
    'isStandalone',
  );
  @override
  late final GeneratedColumn<bool> isStandalone = GeneratedColumn<bool>(
    'is_standalone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_standalone" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    year,
    minPlayers,
    maxPlayers,
    isInCollection,
    isFavorite,
    rating,
    isStandalone,
    imagePath,
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
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_standalone')) {
      context.handle(
        _isStandaloneMeta,
        isStandalone.isAcceptableOrUnknown(
          data['is_standalone']!,
          _isStandaloneMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
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
      isInCollection: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_in_collection'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      isStandalone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_standalone'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
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
  final bool isInCollection;
  final bool isFavorite;
  final double? rating;
  final bool isStandalone;
  final String? imagePath;
  const Game({
    required this.id,
    required this.name,
    this.description,
    this.year,
    this.minPlayers,
    this.maxPlayers,
    required this.isInCollection,
    required this.isFavorite,
    this.rating,
    required this.isStandalone,
    this.imagePath,
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
    map['is_in_collection'] = Variable<bool>(isInCollection);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    map['is_standalone'] = Variable<bool>(isStandalone);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
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
      isInCollection: Value(isInCollection),
      isFavorite: Value(isFavorite),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isStandalone: Value(isStandalone),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
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
      isInCollection: serializer.fromJson<bool>(json['isInCollection']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      rating: serializer.fromJson<double?>(json['rating']),
      isStandalone: serializer.fromJson<bool>(json['isStandalone']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
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
      'isInCollection': serializer.toJson<bool>(isInCollection),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'rating': serializer.toJson<double?>(rating),
      'isStandalone': serializer.toJson<bool>(isStandalone),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  Game copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> year = const Value.absent(),
    Value<int?> minPlayers = const Value.absent(),
    Value<int?> maxPlayers = const Value.absent(),
    bool? isInCollection,
    bool? isFavorite,
    Value<double?> rating = const Value.absent(),
    bool? isStandalone,
    Value<String?> imagePath = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    year: year.present ? year.value : this.year,
    minPlayers: minPlayers.present ? minPlayers.value : this.minPlayers,
    maxPlayers: maxPlayers.present ? maxPlayers.value : this.maxPlayers,
    isInCollection: isInCollection ?? this.isInCollection,
    isFavorite: isFavorite ?? this.isFavorite,
    rating: rating.present ? rating.value : this.rating,
    isStandalone: isStandalone ?? this.isStandalone,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
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
      isInCollection: data.isInCollection.present
          ? data.isInCollection.value
          : this.isInCollection,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      rating: data.rating.present ? data.rating.value : this.rating,
      isStandalone: data.isStandalone.present
          ? data.isStandalone.value
          : this.isStandalone,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
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
          ..write('isInCollection: $isInCollection, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rating: $rating, ')
          ..write('isStandalone: $isStandalone, ')
          ..write('imagePath: $imagePath')
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
    isInCollection,
    isFavorite,
    rating,
    isStandalone,
    imagePath,
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
          other.isInCollection == this.isInCollection &&
          other.isFavorite == this.isFavorite &&
          other.rating == this.rating &&
          other.isStandalone == this.isStandalone &&
          other.imagePath == this.imagePath);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> year;
  final Value<int?> minPlayers;
  final Value<int?> maxPlayers;
  final Value<bool> isInCollection;
  final Value<bool> isFavorite;
  final Value<double?> rating;
  final Value<bool> isStandalone;
  final Value<String?> imagePath;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.isInCollection = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rating = const Value.absent(),
    this.isStandalone = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.year = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.isInCollection = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rating = const Value.absent(),
    this.isStandalone = const Value.absent(),
    this.imagePath = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? year,
    Expression<int>? minPlayers,
    Expression<int>? maxPlayers,
    Expression<bool>? isInCollection,
    Expression<bool>? isFavorite,
    Expression<double>? rating,
    Expression<bool>? isStandalone,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (year != null) 'year': year,
      if (minPlayers != null) 'min_players': minPlayers,
      if (maxPlayers != null) 'max_players': maxPlayers,
      if (isInCollection != null) 'is_in_collection': isInCollection,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rating != null) 'rating': rating,
      if (isStandalone != null) 'is_standalone': isStandalone,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? year,
    Value<int?>? minPlayers,
    Value<int?>? maxPlayers,
    Value<bool>? isInCollection,
    Value<bool>? isFavorite,
    Value<double?>? rating,
    Value<bool>? isStandalone,
    Value<String?>? imagePath,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      year: year ?? this.year,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      isInCollection: isInCollection ?? this.isInCollection,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      isStandalone: isStandalone ?? this.isStandalone,
      imagePath: imagePath ?? this.imagePath,
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
    if (isInCollection.present) {
      map['is_in_collection'] = Variable<bool>(isInCollection.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isStandalone.present) {
      map['is_standalone'] = Variable<bool>(isStandalone.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
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
          ..write('isInCollection: $isInCollection, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rating: $rating, ')
          ..write('isStandalone: $isStandalone, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $ExpansionsGamesTable extends ExpansionsGames
    with TableInfo<$ExpansionsGamesTable, ExpansionsGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpansionsGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _expansionIdMeta = const VerificationMeta(
    'expansionId',
  );
  @override
  late final GeneratedColumn<int> expansionId = GeneratedColumn<int>(
    'expansion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
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
  @override
  List<GeneratedColumn> get $columns => [expansionId, gameId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expansions_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpansionsGame> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('expansion_id')) {
      context.handle(
        _expansionIdMeta,
        expansionId.isAcceptableOrUnknown(
          data['expansion_id']!,
          _expansionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expansionIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {expansionId, gameId};
  @override
  ExpansionsGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpansionsGame(
      expansionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expansion_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
    );
  }

  @override
  $ExpansionsGamesTable createAlias(String alias) {
    return $ExpansionsGamesTable(attachedDatabase, alias);
  }
}

class ExpansionsGame extends DataClass implements Insertable<ExpansionsGame> {
  final int expansionId;
  final int gameId;
  const ExpansionsGame({required this.expansionId, required this.gameId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['expansion_id'] = Variable<int>(expansionId);
    map['game_id'] = Variable<int>(gameId);
    return map;
  }

  ExpansionsGamesCompanion toCompanion(bool nullToAbsent) {
    return ExpansionsGamesCompanion(
      expansionId: Value(expansionId),
      gameId: Value(gameId),
    );
  }

  factory ExpansionsGame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpansionsGame(
      expansionId: serializer.fromJson<int>(json['expansionId']),
      gameId: serializer.fromJson<int>(json['gameId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'expansionId': serializer.toJson<int>(expansionId),
      'gameId': serializer.toJson<int>(gameId),
    };
  }

  ExpansionsGame copyWith({int? expansionId, int? gameId}) => ExpansionsGame(
    expansionId: expansionId ?? this.expansionId,
    gameId: gameId ?? this.gameId,
  );
  ExpansionsGame copyWithCompanion(ExpansionsGamesCompanion data) {
    return ExpansionsGame(
      expansionId: data.expansionId.present
          ? data.expansionId.value
          : this.expansionId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpansionsGame(')
          ..write('expansionId: $expansionId, ')
          ..write('gameId: $gameId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(expansionId, gameId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpansionsGame &&
          other.expansionId == this.expansionId &&
          other.gameId == this.gameId);
}

class ExpansionsGamesCompanion extends UpdateCompanion<ExpansionsGame> {
  final Value<int> expansionId;
  final Value<int> gameId;
  final Value<int> rowid;
  const ExpansionsGamesCompanion({
    this.expansionId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpansionsGamesCompanion.insert({
    required int expansionId,
    required int gameId,
    this.rowid = const Value.absent(),
  }) : expansionId = Value(expansionId),
       gameId = Value(gameId);
  static Insertable<ExpansionsGame> custom({
    Expression<int>? expansionId,
    Expression<int>? gameId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (expansionId != null) 'expansion_id': expansionId,
      if (gameId != null) 'game_id': gameId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpansionsGamesCompanion copyWith({
    Value<int>? expansionId,
    Value<int>? gameId,
    Value<int>? rowid,
  }) {
    return ExpansionsGamesCompanion(
      expansionId: expansionId ?? this.expansionId,
      gameId: gameId ?? this.gameId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (expansionId.present) {
      map['expansion_id'] = Variable<int>(expansionId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpansionsGamesCompanion(')
          ..write('expansionId: $expansionId, ')
          ..write('gameId: $gameId, ')
          ..write('rowid: $rowid')
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

class $GamesCountingTemplatesTable extends GamesCountingTemplates
    with TableInfo<$GamesCountingTemplatesTable, GamesCountingTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesCountingTemplatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _countingTemplateIdMeta =
      const VerificationMeta('countingTemplateId');
  @override
  late final GeneratedColumn<int> countingTemplateId = GeneratedColumn<int>(
    'counting_template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES counting_templates (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    data,
    gameId,
    countingTemplateId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games_counting_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamesCountingTemplate> instance, {
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
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('counting_template_id')) {
      context.handle(
        _countingTemplateIdMeta,
        countingTemplateId.isAcceptableOrUnknown(
          data['counting_template_id']!,
          _countingTemplateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countingTemplateIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GamesCountingTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamesCountingTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      countingTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counting_template_id'],
      )!,
    );
  }

  @override
  $GamesCountingTemplatesTable createAlias(String alias) {
    return $GamesCountingTemplatesTable(attachedDatabase, alias);
  }
}

class GamesCountingTemplate extends DataClass
    implements Insertable<GamesCountingTemplate> {
  final int id;
  final String name;
  final String? data;
  final int gameId;
  final int countingTemplateId;
  const GamesCountingTemplate({
    required this.id,
    required this.name,
    this.data,
    required this.gameId,
    required this.countingTemplateId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['game_id'] = Variable<int>(gameId);
    map['counting_template_id'] = Variable<int>(countingTemplateId);
    return map;
  }

  GamesCountingTemplatesCompanion toCompanion(bool nullToAbsent) {
    return GamesCountingTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      gameId: Value(gameId),
      countingTemplateId: Value(countingTemplateId),
    );
  }

  factory GamesCountingTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamesCountingTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      data: serializer.fromJson<String?>(json['data']),
      gameId: serializer.fromJson<int>(json['gameId']),
      countingTemplateId: serializer.fromJson<int>(json['countingTemplateId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'data': serializer.toJson<String?>(data),
      'gameId': serializer.toJson<int>(gameId),
      'countingTemplateId': serializer.toJson<int>(countingTemplateId),
    };
  }

  GamesCountingTemplate copyWith({
    int? id,
    String? name,
    Value<String?> data = const Value.absent(),
    int? gameId,
    int? countingTemplateId,
  }) => GamesCountingTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    data: data.present ? data.value : this.data,
    gameId: gameId ?? this.gameId,
    countingTemplateId: countingTemplateId ?? this.countingTemplateId,
  );
  GamesCountingTemplate copyWithCompanion(
    GamesCountingTemplatesCompanion data,
  ) {
    return GamesCountingTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      data: data.data.present ? data.data.value : this.data,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      countingTemplateId: data.countingTemplateId.present
          ? data.countingTemplateId.value
          : this.countingTemplateId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamesCountingTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('data: $data, ')
          ..write('gameId: $gameId, ')
          ..write('countingTemplateId: $countingTemplateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, data, gameId, countingTemplateId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamesCountingTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.data == this.data &&
          other.gameId == this.gameId &&
          other.countingTemplateId == this.countingTemplateId);
}

class GamesCountingTemplatesCompanion
    extends UpdateCompanion<GamesCountingTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> data;
  final Value<int> gameId;
  final Value<int> countingTemplateId;
  const GamesCountingTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.data = const Value.absent(),
    this.gameId = const Value.absent(),
    this.countingTemplateId = const Value.absent(),
  });
  GamesCountingTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.data = const Value.absent(),
    required int gameId,
    required int countingTemplateId,
  }) : name = Value(name),
       gameId = Value(gameId),
       countingTemplateId = Value(countingTemplateId);
  static Insertable<GamesCountingTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? data,
    Expression<int>? gameId,
    Expression<int>? countingTemplateId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (data != null) 'data': data,
      if (gameId != null) 'game_id': gameId,
      if (countingTemplateId != null)
        'counting_template_id': countingTemplateId,
    });
  }

  GamesCountingTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? data,
    Value<int>? gameId,
    Value<int>? countingTemplateId,
  }) {
    return GamesCountingTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data ?? this.data,
      gameId: gameId ?? this.gameId,
      countingTemplateId: countingTemplateId ?? this.countingTemplateId,
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
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (countingTemplateId.present) {
      map['counting_template_id'] = Variable<int>(countingTemplateId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCountingTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('data: $data, ')
          ..write('gameId: $gameId, ')
          ..write('countingTemplateId: $countingTemplateId')
          ..write(')'))
        .toString();
  }
}

class $GamesCountingTemplatesExpansionsTable
    extends GamesCountingTemplatesExpansions
    with
        TableInfo<
          $GamesCountingTemplatesExpansionsTable,
          GamesCountingTemplatesExpansion
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesCountingTemplatesExpansionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gamesCountingTemplateIdMeta =
      const VerificationMeta('gamesCountingTemplateId');
  @override
  late final GeneratedColumn<int> gamesCountingTemplateId =
      GeneratedColumn<int>(
        'games_counting_template_id',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES games_counting_templates (id) ON DELETE CASCADE',
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
  @override
  List<GeneratedColumn> get $columns => [gamesCountingTemplateId, gameId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games_counting_templates_expansions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamesCountingTemplatesExpansion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('games_counting_template_id')) {
      context.handle(
        _gamesCountingTemplateIdMeta,
        gamesCountingTemplateId.isAcceptableOrUnknown(
          data['games_counting_template_id']!,
          _gamesCountingTemplateIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gamesCountingTemplateIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gamesCountingTemplateId, gameId};
  @override
  GamesCountingTemplatesExpansion map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamesCountingTemplatesExpansion(
      gamesCountingTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_counting_template_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
    );
  }

  @override
  $GamesCountingTemplatesExpansionsTable createAlias(String alias) {
    return $GamesCountingTemplatesExpansionsTable(attachedDatabase, alias);
  }
}

class GamesCountingTemplatesExpansion extends DataClass
    implements Insertable<GamesCountingTemplatesExpansion> {
  final int gamesCountingTemplateId;
  final int gameId;
  const GamesCountingTemplatesExpansion({
    required this.gamesCountingTemplateId,
    required this.gameId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['games_counting_template_id'] = Variable<int>(gamesCountingTemplateId);
    map['game_id'] = Variable<int>(gameId);
    return map;
  }

  GamesCountingTemplatesExpansionsCompanion toCompanion(bool nullToAbsent) {
    return GamesCountingTemplatesExpansionsCompanion(
      gamesCountingTemplateId: Value(gamesCountingTemplateId),
      gameId: Value(gameId),
    );
  }

  factory GamesCountingTemplatesExpansion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamesCountingTemplatesExpansion(
      gamesCountingTemplateId: serializer.fromJson<int>(
        json['gamesCountingTemplateId'],
      ),
      gameId: serializer.fromJson<int>(json['gameId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gamesCountingTemplateId': serializer.toJson<int>(
        gamesCountingTemplateId,
      ),
      'gameId': serializer.toJson<int>(gameId),
    };
  }

  GamesCountingTemplatesExpansion copyWith({
    int? gamesCountingTemplateId,
    int? gameId,
  }) => GamesCountingTemplatesExpansion(
    gamesCountingTemplateId:
        gamesCountingTemplateId ?? this.gamesCountingTemplateId,
    gameId: gameId ?? this.gameId,
  );
  GamesCountingTemplatesExpansion copyWithCompanion(
    GamesCountingTemplatesExpansionsCompanion data,
  ) {
    return GamesCountingTemplatesExpansion(
      gamesCountingTemplateId: data.gamesCountingTemplateId.present
          ? data.gamesCountingTemplateId.value
          : this.gamesCountingTemplateId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamesCountingTemplatesExpansion(')
          ..write('gamesCountingTemplateId: $gamesCountingTemplateId, ')
          ..write('gameId: $gameId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gamesCountingTemplateId, gameId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamesCountingTemplatesExpansion &&
          other.gamesCountingTemplateId == this.gamesCountingTemplateId &&
          other.gameId == this.gameId);
}

class GamesCountingTemplatesExpansionsCompanion
    extends UpdateCompanion<GamesCountingTemplatesExpansion> {
  final Value<int> gamesCountingTemplateId;
  final Value<int> gameId;
  final Value<int> rowid;
  const GamesCountingTemplatesExpansionsCompanion({
    this.gamesCountingTemplateId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCountingTemplatesExpansionsCompanion.insert({
    required int gamesCountingTemplateId,
    required int gameId,
    this.rowid = const Value.absent(),
  }) : gamesCountingTemplateId = Value(gamesCountingTemplateId),
       gameId = Value(gameId);
  static Insertable<GamesCountingTemplatesExpansion> custom({
    Expression<int>? gamesCountingTemplateId,
    Expression<int>? gameId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gamesCountingTemplateId != null)
        'games_counting_template_id': gamesCountingTemplateId,
      if (gameId != null) 'game_id': gameId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCountingTemplatesExpansionsCompanion copyWith({
    Value<int>? gamesCountingTemplateId,
    Value<int>? gameId,
    Value<int>? rowid,
  }) {
    return GamesCountingTemplatesExpansionsCompanion(
      gamesCountingTemplateId:
          gamesCountingTemplateId ?? this.gamesCountingTemplateId,
      gameId: gameId ?? this.gameId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gamesCountingTemplateId.present) {
      map['games_counting_template_id'] = Variable<int>(
        gamesCountingTemplateId.value,
      );
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCountingTemplatesExpansionsCompanion(')
          ..write('gamesCountingTemplateId: $gamesCountingTemplateId, ')
          ..write('gameId: $gameId, ')
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  static const VerificationMeta _gameTypeMeta = const VerificationMeta(
    'gameType',
  );
  @override
  late final GeneratedColumn<int> gameType = GeneratedColumn<int>(
    'game_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rootSessionIdMeta = const VerificationMeta(
    'rootSessionId',
  );
  @override
  late final GeneratedColumn<int> rootSessionId = GeneratedColumn<int>(
    'root_session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gaming_sessions (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    startedAt,
    finishedAt,
    isFinished,
    comment,
    gameType,
    data,
    rootSessionId,
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
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('game_type')) {
      context.handle(
        _gameTypeMeta,
        gameType.isAcceptableOrUnknown(data['game_type']!, _gameTypeMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('root_session_id')) {
      context.handle(
        _rootSessionIdMeta,
        rootSessionId.isAcceptableOrUnknown(
          data['root_session_id']!,
          _rootSessionIdMeta,
        ),
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
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      gameType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_type'],
      ),
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
      rootSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}root_session_id'],
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
  final DateTime startedAt;
  final DateTime finishedAt;
  final bool isFinished;
  final String? comment;
  final int? gameType;
  final String? data;
  final int? rootSessionId;
  const GamingSession({
    required this.id,
    required this.gameId,
    required this.startedAt,
    required this.finishedAt,
    required this.isFinished,
    this.comment,
    this.gameType,
    this.data,
    this.rootSessionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    map['is_finished'] = Variable<bool>(isFinished);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || gameType != null) {
      map['game_type'] = Variable<int>(gameType);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    if (!nullToAbsent || rootSessionId != null) {
      map['root_session_id'] = Variable<int>(rootSessionId);
    }
    return map;
  }

  GamingSessionsCompanion toCompanion(bool nullToAbsent) {
    return GamingSessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      startedAt: Value(startedAt),
      finishedAt: Value(finishedAt),
      isFinished: Value(isFinished),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      gameType: gameType == null && nullToAbsent
          ? const Value.absent()
          : Value(gameType),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      rootSessionId: rootSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(rootSessionId),
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
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      comment: serializer.fromJson<String?>(json['comment']),
      gameType: serializer.fromJson<int?>(json['gameType']),
      data: serializer.fromJson<String?>(json['data']),
      rootSessionId: serializer.fromJson<int?>(json['rootSessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'isFinished': serializer.toJson<bool>(isFinished),
      'comment': serializer.toJson<String?>(comment),
      'gameType': serializer.toJson<int?>(gameType),
      'data': serializer.toJson<String?>(data),
      'rootSessionId': serializer.toJson<int?>(rootSessionId),
    };
  }

  GamingSession copyWith({
    int? id,
    int? gameId,
    DateTime? startedAt,
    DateTime? finishedAt,
    bool? isFinished,
    Value<String?> comment = const Value.absent(),
    Value<int?> gameType = const Value.absent(),
    Value<String?> data = const Value.absent(),
    Value<int?> rootSessionId = const Value.absent(),
  }) => GamingSession(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    isFinished: isFinished ?? this.isFinished,
    comment: comment.present ? comment.value : this.comment,
    gameType: gameType.present ? gameType.value : this.gameType,
    data: data.present ? data.value : this.data,
    rootSessionId: rootSessionId.present
        ? rootSessionId.value
        : this.rootSessionId,
  );
  GamingSession copyWithCompanion(GamingSessionsCompanion data) {
    return GamingSession(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      comment: data.comment.present ? data.comment.value : this.comment,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      data: data.data.present ? data.data.value : this.data,
      rootSessionId: data.rootSessionId.present
          ? data.rootSessionId.value
          : this.rootSessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamingSession(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('isFinished: $isFinished, ')
          ..write('comment: $comment, ')
          ..write('gameType: $gameType, ')
          ..write('data: $data, ')
          ..write('rootSessionId: $rootSessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    startedAt,
    finishedAt,
    isFinished,
    comment,
    gameType,
    data,
    rootSessionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamingSession &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.isFinished == this.isFinished &&
          other.comment == this.comment &&
          other.gameType == this.gameType &&
          other.data == this.data &&
          other.rootSessionId == this.rootSessionId);
}

class GamingSessionsCompanion extends UpdateCompanion<GamingSession> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<DateTime> startedAt;
  final Value<DateTime> finishedAt;
  final Value<bool> isFinished;
  final Value<String?> comment;
  final Value<int?> gameType;
  final Value<String?> data;
  final Value<int?> rootSessionId;
  const GamingSessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.comment = const Value.absent(),
    this.gameType = const Value.absent(),
    this.data = const Value.absent(),
    this.rootSessionId = const Value.absent(),
  });
  GamingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required DateTime startedAt,
    required DateTime finishedAt,
    this.isFinished = const Value.absent(),
    this.comment = const Value.absent(),
    this.gameType = const Value.absent(),
    this.data = const Value.absent(),
    this.rootSessionId = const Value.absent(),
  }) : gameId = Value(gameId),
       startedAt = Value(startedAt),
       finishedAt = Value(finishedAt);
  static Insertable<GamingSession> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<bool>? isFinished,
    Expression<String>? comment,
    Expression<int>? gameType,
    Expression<String>? data,
    Expression<int>? rootSessionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (isFinished != null) 'is_finished': isFinished,
      if (comment != null) 'comment': comment,
      if (gameType != null) 'game_type': gameType,
      if (data != null) 'data': data,
      if (rootSessionId != null) 'root_session_id': rootSessionId,
    });
  }

  GamingSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<DateTime>? startedAt,
    Value<DateTime>? finishedAt,
    Value<bool>? isFinished,
    Value<String?>? comment,
    Value<int?>? gameType,
    Value<String?>? data,
    Value<int?>? rootSessionId,
  }) {
    return GamingSessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      isFinished: isFinished ?? this.isFinished,
      comment: comment ?? this.comment,
      gameType: gameType ?? this.gameType,
      data: data ?? this.data,
      rootSessionId: rootSessionId ?? this.rootSessionId,
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
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (gameType.present) {
      map['game_type'] = Variable<int>(gameType.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rootSessionId.present) {
      map['root_session_id'] = Variable<int>(rootSessionId.value);
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
          ..write('isFinished: $isFinished, ')
          ..write('comment: $comment, ')
          ..write('gameType: $gameType, ')
          ..write('data: $data, ')
          ..write('rootSessionId: $rootSessionId')
          ..write(')'))
        .toString();
  }
}

class $GamingSessionsExpansionsTable extends GamingSessionsExpansions
    with TableInfo<$GamingSessionsExpansionsTable, GamingSessionsExpansion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamingSessionsExpansionsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [gamingSessionId, gameId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gaming_sessions_expansions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamingSessionsExpansion> instance, {
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
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gamingSessionId, gameId};
  @override
  GamingSessionsExpansion map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamingSessionsExpansion(
      gamingSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gaming_session_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
    );
  }

  @override
  $GamingSessionsExpansionsTable createAlias(String alias) {
    return $GamingSessionsExpansionsTable(attachedDatabase, alias);
  }
}

class GamingSessionsExpansion extends DataClass
    implements Insertable<GamingSessionsExpansion> {
  final int gamingSessionId;
  final int gameId;
  const GamingSessionsExpansion({
    required this.gamingSessionId,
    required this.gameId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gaming_session_id'] = Variable<int>(gamingSessionId);
    map['game_id'] = Variable<int>(gameId);
    return map;
  }

  GamingSessionsExpansionsCompanion toCompanion(bool nullToAbsent) {
    return GamingSessionsExpansionsCompanion(
      gamingSessionId: Value(gamingSessionId),
      gameId: Value(gameId),
    );
  }

  factory GamingSessionsExpansion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamingSessionsExpansion(
      gamingSessionId: serializer.fromJson<int>(json['gamingSessionId']),
      gameId: serializer.fromJson<int>(json['gameId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gamingSessionId': serializer.toJson<int>(gamingSessionId),
      'gameId': serializer.toJson<int>(gameId),
    };
  }

  GamingSessionsExpansion copyWith({int? gamingSessionId, int? gameId}) =>
      GamingSessionsExpansion(
        gamingSessionId: gamingSessionId ?? this.gamingSessionId,
        gameId: gameId ?? this.gameId,
      );
  GamingSessionsExpansion copyWithCompanion(
    GamingSessionsExpansionsCompanion data,
  ) {
    return GamingSessionsExpansion(
      gamingSessionId: data.gamingSessionId.present
          ? data.gamingSessionId.value
          : this.gamingSessionId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamingSessionsExpansion(')
          ..write('gamingSessionId: $gamingSessionId, ')
          ..write('gameId: $gameId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gamingSessionId, gameId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamingSessionsExpansion &&
          other.gamingSessionId == this.gamingSessionId &&
          other.gameId == this.gameId);
}

class GamingSessionsExpansionsCompanion
    extends UpdateCompanion<GamingSessionsExpansion> {
  final Value<int> gamingSessionId;
  final Value<int> gameId;
  final Value<int> rowid;
  const GamingSessionsExpansionsCompanion({
    this.gamingSessionId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamingSessionsExpansionsCompanion.insert({
    required int gamingSessionId,
    required int gameId,
    this.rowid = const Value.absent(),
  }) : gamingSessionId = Value(gamingSessionId),
       gameId = Value(gameId);
  static Insertable<GamingSessionsExpansion> custom({
    Expression<int>? gamingSessionId,
    Expression<int>? gameId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gamingSessionId != null) 'gaming_session_id': gamingSessionId,
      if (gameId != null) 'game_id': gameId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamingSessionsExpansionsCompanion copyWith({
    Value<int>? gamingSessionId,
    Value<int>? gameId,
    Value<int>? rowid,
  }) {
    return GamingSessionsExpansionsCompanion(
      gamingSessionId: gamingSessionId ?? this.gamingSessionId,
      gameId: gameId ?? this.gameId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gamingSessionId.present) {
      map['gaming_session_id'] = Variable<int>(gamingSessionId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamingSessionsExpansionsCompanion(')
          ..write('gamingSessionId: $gamingSessionId, ')
          ..write('gameId: $gameId, ')
          ..write('rowid: $rowid')
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
  static const VerificationMeta _teamMeta = const VerificationMeta('team');
  @override
  late final GeneratedColumn<int> team = GeneratedColumn<int>(
    'team',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    gamingSessionId,
    gamerId,
    score,
    place,
    turnOrder,
    team,
    data,
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
    if (data.containsKey('team')) {
      context.handle(
        _teamMeta,
        team.isAcceptableOrUnknown(data['team']!, _teamMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
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
      team: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}team'],
      ),
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
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
  final int? team;
  final String? data;
  const GamingSessionsGamer({
    required this.gamingSessionId,
    required this.gamerId,
    this.score,
    this.place,
    this.turnOrder,
    this.team,
    this.data,
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
    if (!nullToAbsent || team != null) {
      map['team'] = Variable<int>(team);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
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
      team: team == null && nullToAbsent ? const Value.absent() : Value(team),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
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
      team: serializer.fromJson<int?>(json['team']),
      data: serializer.fromJson<String?>(json['data']),
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
      'team': serializer.toJson<int?>(team),
      'data': serializer.toJson<String?>(data),
    };
  }

  GamingSessionsGamer copyWith({
    int? gamingSessionId,
    int? gamerId,
    Value<int?> score = const Value.absent(),
    Value<int?> place = const Value.absent(),
    Value<int?> turnOrder = const Value.absent(),
    Value<int?> team = const Value.absent(),
    Value<String?> data = const Value.absent(),
  }) => GamingSessionsGamer(
    gamingSessionId: gamingSessionId ?? this.gamingSessionId,
    gamerId: gamerId ?? this.gamerId,
    score: score.present ? score.value : this.score,
    place: place.present ? place.value : this.place,
    turnOrder: turnOrder.present ? turnOrder.value : this.turnOrder,
    team: team.present ? team.value : this.team,
    data: data.present ? data.value : this.data,
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
      team: data.team.present ? data.team.value : this.team,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamingSessionsGamer(')
          ..write('gamingSessionId: $gamingSessionId, ')
          ..write('gamerId: $gamerId, ')
          ..write('score: $score, ')
          ..write('place: $place, ')
          ..write('turnOrder: $turnOrder, ')
          ..write('team: $team, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    gamingSessionId,
    gamerId,
    score,
    place,
    turnOrder,
    team,
    data,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamingSessionsGamer &&
          other.gamingSessionId == this.gamingSessionId &&
          other.gamerId == this.gamerId &&
          other.score == this.score &&
          other.place == this.place &&
          other.turnOrder == this.turnOrder &&
          other.team == this.team &&
          other.data == this.data);
}

class GamingSessionsGamersCompanion
    extends UpdateCompanion<GamingSessionsGamer> {
  final Value<int> gamingSessionId;
  final Value<int> gamerId;
  final Value<int?> score;
  final Value<int?> place;
  final Value<int?> turnOrder;
  final Value<int?> team;
  final Value<String?> data;
  final Value<int> rowid;
  const GamingSessionsGamersCompanion({
    this.gamingSessionId = const Value.absent(),
    this.gamerId = const Value.absent(),
    this.score = const Value.absent(),
    this.place = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.team = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamingSessionsGamersCompanion.insert({
    required int gamingSessionId,
    required int gamerId,
    this.score = const Value.absent(),
    this.place = const Value.absent(),
    this.turnOrder = const Value.absent(),
    this.team = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gamingSessionId = Value(gamingSessionId),
       gamerId = Value(gamerId);
  static Insertable<GamingSessionsGamer> custom({
    Expression<int>? gamingSessionId,
    Expression<int>? gamerId,
    Expression<int>? score,
    Expression<int>? place,
    Expression<int>? turnOrder,
    Expression<int>? team,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gamingSessionId != null) 'gaming_session_id': gamingSessionId,
      if (gamerId != null) 'gamer_id': gamerId,
      if (score != null) 'score': score,
      if (place != null) 'place': place,
      if (turnOrder != null) 'turn_order': turnOrder,
      if (team != null) 'team': team,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamingSessionsGamersCompanion copyWith({
    Value<int>? gamingSessionId,
    Value<int>? gamerId,
    Value<int?>? score,
    Value<int?>? place,
    Value<int?>? turnOrder,
    Value<int?>? team,
    Value<String?>? data,
    Value<int>? rowid,
  }) {
    return GamingSessionsGamersCompanion(
      gamingSessionId: gamingSessionId ?? this.gamingSessionId,
      gamerId: gamerId ?? this.gamerId,
      score: score ?? this.score,
      place: place ?? this.place,
      turnOrder: turnOrder ?? this.turnOrder,
      team: team ?? this.team,
      data: data ?? this.data,
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
    if (team.present) {
      map['team'] = Variable<int>(team.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
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
          ..write('team: $team, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    title,
    content,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int gameId;
  final String title;
  final String? content;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.gameId,
    required this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<int>(gameId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      title: Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<int>(json['gameId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String?>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<int>(gameId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String?>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    int? id,
    int? gameId,
    String? title,
    Value<String?> content = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    title: title ?? this.title,
    content: content.present ? content.value : this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, title, content, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.title == this.title &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> gameId;
  final Value<String> title;
  final Value<String?> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int gameId,
    required String title,
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : gameId = Value(gameId),
       title = Value(title);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<int>? gameId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int>? gameId,
    Value<String>? title,
    Value<String?>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RatingsTable extends Ratings with TableInfo<$RatingsTable, Rating> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (month >= 2026 AND month <= 9999)',
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (month >= 1 AND month <= 12)',
  );
  static const VerificationMeta _isActualMeta = const VerificationMeta(
    'isActual',
  );
  @override
  late final GeneratedColumn<bool> isActual = GeneratedColumn<bool>(
    'is_actual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_actual" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistIdMeta = const VerificationMeta(
    'artistId',
  );
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
    'artist_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _designerIdMeta = const VerificationMeta(
    'designerId',
  );
  @override
  late final GeneratedColumn<int> designerId = GeneratedColumn<int>(
    'designer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES designers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    isActual,
    data,
    artistId,
    designerId,
    tagId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ratings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rating> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    }
    if (data.containsKey('is_actual')) {
      context.handle(
        _isActualMeta,
        isActual.isAcceptableOrUnknown(data['is_actual']!, _isActualMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(
        _artistIdMeta,
        artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
      );
    }
    if (data.containsKey('designer_id')) {
      context.handle(
        _designerIdMeta,
        designerId.isAcceptableOrUnknown(data['designer_id']!, _designerIdMeta),
      );
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rating map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rating(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      ),
      isActual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_actual'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      artistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}artist_id'],
      ),
      designerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}designer_id'],
      ),
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      ),
    );
  }

  @override
  $RatingsTable createAlias(String alias) {
    return $RatingsTable(attachedDatabase, alias);
  }
}

class Rating extends DataClass implements Insertable<Rating> {
  final int id;
  final int year;
  final int? month;
  final bool isActual;
  final String data;
  final int? artistId;
  final int? designerId;
  final int? tagId;
  const Rating({
    required this.id,
    required this.year,
    this.month,
    required this.isActual,
    required this.data,
    this.artistId,
    this.designerId,
    this.tagId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || month != null) {
      map['month'] = Variable<int>(month);
    }
    map['is_actual'] = Variable<bool>(isActual);
    map['data'] = Variable<String>(data);
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<int>(artistId);
    }
    if (!nullToAbsent || designerId != null) {
      map['designer_id'] = Variable<int>(designerId);
    }
    if (!nullToAbsent || tagId != null) {
      map['tag_id'] = Variable<int>(tagId);
    }
    return map;
  }

  RatingsCompanion toCompanion(bool nullToAbsent) {
    return RatingsCompanion(
      id: Value(id),
      year: Value(year),
      month: month == null && nullToAbsent
          ? const Value.absent()
          : Value(month),
      isActual: Value(isActual),
      data: Value(data),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      designerId: designerId == null && nullToAbsent
          ? const Value.absent()
          : Value(designerId),
      tagId: tagId == null && nullToAbsent
          ? const Value.absent()
          : Value(tagId),
    );
  }

  factory Rating.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rating(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int?>(json['month']),
      isActual: serializer.fromJson<bool>(json['isActual']),
      data: serializer.fromJson<String>(json['data']),
      artistId: serializer.fromJson<int?>(json['artistId']),
      designerId: serializer.fromJson<int?>(json['designerId']),
      tagId: serializer.fromJson<int?>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int?>(month),
      'isActual': serializer.toJson<bool>(isActual),
      'data': serializer.toJson<String>(data),
      'artistId': serializer.toJson<int?>(artistId),
      'designerId': serializer.toJson<int?>(designerId),
      'tagId': serializer.toJson<int?>(tagId),
    };
  }

  Rating copyWith({
    int? id,
    int? year,
    Value<int?> month = const Value.absent(),
    bool? isActual,
    String? data,
    Value<int?> artistId = const Value.absent(),
    Value<int?> designerId = const Value.absent(),
    Value<int?> tagId = const Value.absent(),
  }) => Rating(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month.present ? month.value : this.month,
    isActual: isActual ?? this.isActual,
    data: data ?? this.data,
    artistId: artistId.present ? artistId.value : this.artistId,
    designerId: designerId.present ? designerId.value : this.designerId,
    tagId: tagId.present ? tagId.value : this.tagId,
  );
  Rating copyWithCompanion(RatingsCompanion data) {
    return Rating(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      isActual: data.isActual.present ? data.isActual.value : this.isActual,
      data: data.data.present ? data.data.value : this.data,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      designerId: data.designerId.present
          ? data.designerId.value
          : this.designerId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rating(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('isActual: $isActual, ')
          ..write('data: $data, ')
          ..write('artistId: $artistId, ')
          ..write('designerId: $designerId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, year, month, isActual, data, artistId, designerId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rating &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.isActual == this.isActual &&
          other.data == this.data &&
          other.artistId == this.artistId &&
          other.designerId == this.designerId &&
          other.tagId == this.tagId);
}

class RatingsCompanion extends UpdateCompanion<Rating> {
  final Value<int> id;
  final Value<int> year;
  final Value<int?> month;
  final Value<bool> isActual;
  final Value<String> data;
  final Value<int?> artistId;
  final Value<int?> designerId;
  final Value<int?> tagId;
  const RatingsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.isActual = const Value.absent(),
    this.data = const Value.absent(),
    this.artistId = const Value.absent(),
    this.designerId = const Value.absent(),
    this.tagId = const Value.absent(),
  });
  RatingsCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    this.month = const Value.absent(),
    this.isActual = const Value.absent(),
    required String data,
    this.artistId = const Value.absent(),
    this.designerId = const Value.absent(),
    this.tagId = const Value.absent(),
  }) : year = Value(year),
       data = Value(data);
  static Insertable<Rating> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<bool>? isActual,
    Expression<String>? data,
    Expression<int>? artistId,
    Expression<int>? designerId,
    Expression<int>? tagId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (isActual != null) 'is_actual': isActual,
      if (data != null) 'data': data,
      if (artistId != null) 'artist_id': artistId,
      if (designerId != null) 'designer_id': designerId,
      if (tagId != null) 'tag_id': tagId,
    });
  }

  RatingsCompanion copyWith({
    Value<int>? id,
    Value<int>? year,
    Value<int?>? month,
    Value<bool>? isActual,
    Value<String>? data,
    Value<int?>? artistId,
    Value<int?>? designerId,
    Value<int?>? tagId,
  }) {
    return RatingsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      isActual: isActual ?? this.isActual,
      data: data ?? this.data,
      artistId: artistId ?? this.artistId,
      designerId: designerId ?? this.designerId,
      tagId: tagId ?? this.tagId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (isActual.present) {
      map['is_actual'] = Variable<bool>(isActual.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (designerId.present) {
      map['designer_id'] = Variable<int>(designerId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatingsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('isActual: $isActual, ')
          ..write('data: $data, ')
          ..write('artistId: $artistId, ')
          ..write('designerId: $designerId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }
}

class $RatingsGamesTable extends RatingsGames
    with TableInfo<$RatingsGamesTable, RatingsGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatingsGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ratingIdMeta = const VerificationMeta(
    'ratingId',
  );
  @override
  late final GeneratedColumn<int> ratingId = GeneratedColumn<int>(
    'rating_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ratings (id) ON DELETE CASCADE',
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
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
  @override
  List<GeneratedColumn> get $columns => [ratingId, gameId, score, place];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ratings_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<RatingsGame> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rating_id')) {
      context.handle(
        _ratingIdMeta,
        ratingId.isAcceptableOrUnknown(data['rating_id']!, _ratingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingIdMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ratingId, gameId};
  @override
  RatingsGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RatingsGame(
      ratingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating_id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place'],
      ),
    );
  }

  @override
  $RatingsGamesTable createAlias(String alias) {
    return $RatingsGamesTable(attachedDatabase, alias);
  }
}

class RatingsGame extends DataClass implements Insertable<RatingsGame> {
  final int ratingId;
  final int gameId;
  final double? score;
  final int? place;
  const RatingsGame({
    required this.ratingId,
    required this.gameId,
    this.score,
    this.place,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rating_id'] = Variable<int>(ratingId);
    map['game_id'] = Variable<int>(gameId);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<int>(place);
    }
    return map;
  }

  RatingsGamesCompanion toCompanion(bool nullToAbsent) {
    return RatingsGamesCompanion(
      ratingId: Value(ratingId),
      gameId: Value(gameId),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
    );
  }

  factory RatingsGame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RatingsGame(
      ratingId: serializer.fromJson<int>(json['ratingId']),
      gameId: serializer.fromJson<int>(json['gameId']),
      score: serializer.fromJson<double?>(json['score']),
      place: serializer.fromJson<int?>(json['place']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ratingId': serializer.toJson<int>(ratingId),
      'gameId': serializer.toJson<int>(gameId),
      'score': serializer.toJson<double?>(score),
      'place': serializer.toJson<int?>(place),
    };
  }

  RatingsGame copyWith({
    int? ratingId,
    int? gameId,
    Value<double?> score = const Value.absent(),
    Value<int?> place = const Value.absent(),
  }) => RatingsGame(
    ratingId: ratingId ?? this.ratingId,
    gameId: gameId ?? this.gameId,
    score: score.present ? score.value : this.score,
    place: place.present ? place.value : this.place,
  );
  RatingsGame copyWithCompanion(RatingsGamesCompanion data) {
    return RatingsGame(
      ratingId: data.ratingId.present ? data.ratingId.value : this.ratingId,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      score: data.score.present ? data.score.value : this.score,
      place: data.place.present ? data.place.value : this.place,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RatingsGame(')
          ..write('ratingId: $ratingId, ')
          ..write('gameId: $gameId, ')
          ..write('score: $score, ')
          ..write('place: $place')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ratingId, gameId, score, place);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RatingsGame &&
          other.ratingId == this.ratingId &&
          other.gameId == this.gameId &&
          other.score == this.score &&
          other.place == this.place);
}

class RatingsGamesCompanion extends UpdateCompanion<RatingsGame> {
  final Value<int> ratingId;
  final Value<int> gameId;
  final Value<double?> score;
  final Value<int?> place;
  final Value<int> rowid;
  const RatingsGamesCompanion({
    this.ratingId = const Value.absent(),
    this.gameId = const Value.absent(),
    this.score = const Value.absent(),
    this.place = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RatingsGamesCompanion.insert({
    required int ratingId,
    required int gameId,
    this.score = const Value.absent(),
    this.place = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ratingId = Value(ratingId),
       gameId = Value(gameId);
  static Insertable<RatingsGame> custom({
    Expression<int>? ratingId,
    Expression<int>? gameId,
    Expression<double>? score,
    Expression<int>? place,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ratingId != null) 'rating_id': ratingId,
      if (gameId != null) 'game_id': gameId,
      if (score != null) 'score': score,
      if (place != null) 'place': place,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RatingsGamesCompanion copyWith({
    Value<int>? ratingId,
    Value<int>? gameId,
    Value<double?>? score,
    Value<int?>? place,
    Value<int>? rowid,
  }) {
    return RatingsGamesCompanion(
      ratingId: ratingId ?? this.ratingId,
      gameId: gameId ?? this.gameId,
      score: score ?? this.score,
      place: place ?? this.place,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ratingId.present) {
      map['rating_id'] = Variable<int>(ratingId.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<int>(gameId.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (place.present) {
      map['place'] = Variable<int>(place.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatingsGamesCompanion(')
          ..write('ratingId: $ratingId, ')
          ..write('gameId: $gameId, ')
          ..write('score: $score, ')
          ..write('place: $place, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $CountingTemplatesTable countingTemplates =
      $CountingTemplatesTable(this);
  late final $DesignersTable designers = $DesignersTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $ExpansionsGamesTable expansionsGames = $ExpansionsGamesTable(
    this,
  );
  late final $GamesArtistsTable gamesArtists = $GamesArtistsTable(this);
  late final $GamesCountingTemplatesTable gamesCountingTemplates =
      $GamesCountingTemplatesTable(this);
  late final $GamesCountingTemplatesExpansionsTable
  gamesCountingTemplatesExpansions = $GamesCountingTemplatesExpansionsTable(
    this,
  );
  late final $GamesDesignersTable gamesDesigners = $GamesDesignersTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $GamesTagsTable gamesTags = $GamesTagsTable(this);
  late final $GamersTable gamers = $GamersTable(this);
  late final $GamingSessionsTable gamingSessions = $GamingSessionsTable(this);
  late final $GamingSessionsExpansionsTable gamingSessionsExpansions =
      $GamingSessionsExpansionsTable(this);
  late final $GamingSessionsGamersTable gamingSessionsGamers =
      $GamingSessionsGamersTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $RatingsTable ratings = $RatingsTable(this);
  late final $RatingsGamesTable ratingsGames = $RatingsGamesTable(this);
  late final ArtistDao artistDao = ArtistDao(this as AppDatabase);
  late final CountingTemplateDao countingTemplateDao = CountingTemplateDao(
    this as AppDatabase,
  );
  late final DesignerDao designerDao = DesignerDao(this as AppDatabase);
  late final GameDao gameDao = GameDao(this as AppDatabase);
  late final GamerDao gamerDao = GamerDao(this as AppDatabase);
  late final GamesCountingTemplatesDao gamesCountingTemplatesDao =
      GamesCountingTemplatesDao(this as AppDatabase);
  late final GamingSessionDao gamingSessionDao = GamingSessionDao(
    this as AppDatabase,
  );
  late final NoteDao noteDao = NoteDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    artists,
    countingTemplates,
    designers,
    games,
    expansionsGames,
    gamesArtists,
    gamesCountingTemplates,
    gamesCountingTemplatesExpansions,
    gamesDesigners,
    tags,
    gamesTags,
    gamers,
    gamingSessions,
    gamingSessionsExpansions,
    gamingSessionsGamers,
    notes,
    ratings,
    ratingsGames,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expansions_games', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expansions_games', kind: UpdateKind.delete)],
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
      result: [
        TableUpdate('games_counting_templates', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'counting_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('games_counting_templates', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games_counting_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate(
          'games_counting_templates_expansions',
          kind: UpdateKind.delete,
        ),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate(
          'games_counting_templates_expansions',
          kind: UpdateKind.delete,
        ),
      ],
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
      result: [TableUpdate('gaming_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gaming_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('gaming_sessions_expansions', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('gaming_sessions_expansions', kind: UpdateKind.delete),
      ],
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'artists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ratings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'designers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ratings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ratings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ratings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ratings_games', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ratings_games', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<$RatingsTable, List<Rating>> _ratingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ratings,
    aliasName: $_aliasNameGenerator(db.artists.id, db.ratings.artistId),
  );

  $$RatingsTableProcessedTableManager get ratingsRefs {
    final manager = $$RatingsTableTableManager(
      $_db,
      $_db.ratings,
    ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ratingsRefsTable($_db));
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

  Expression<bool> ratingsRefs(
    Expression<bool> Function($$RatingsTableFilterComposer f) f,
  ) {
    final $$RatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableFilterComposer(
            $db: $db,
            $table: $db.ratings,
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

  Expression<T> ratingsRefs<T extends Object>(
    Expression<T> Function($$RatingsTableAnnotationComposer a) f,
  ) {
    final $$RatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.artistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratings,
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
          PrefetchHooks Function({bool gamesArtistsRefs, bool ratingsRefs})
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
          prefetchHooksCallback:
              ({gamesArtistsRefs = false, ratingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamesArtistsRefs) db.gamesArtists,
                    if (ratingsRefs) db.ratings,
                  ],
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
                          managerFromTypedResult: (p0) =>
                              $$ArtistsTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesArtistsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.artistId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ratingsRefs)
                        await $_getPrefetchedData<
                          Artist,
                          $ArtistsTable,
                          Rating
                        >(
                          currentTable: table,
                          referencedTable: $$ArtistsTableReferences
                              ._ratingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ArtistsTableReferences(
                                db,
                                table,
                                p0,
                              ).ratingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.artistId == item.id,
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
      PrefetchHooks Function({bool gamesArtistsRefs, bool ratingsRefs})
    >;
typedef $$CountingTemplatesTableCreateCompanionBuilder =
    CountingTemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required String data,
    });
typedef $$CountingTemplatesTableUpdateCompanionBuilder =
    CountingTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String> data,
    });

final class $$CountingTemplatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CountingTemplatesTable,
          CountingTemplate
        > {
  $$CountingTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $GamesCountingTemplatesTable,
    List<GamesCountingTemplate>
  >
  _gamesCountingTemplatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamesCountingTemplates,
        aliasName: $_aliasNameGenerator(
          db.countingTemplates.id,
          db.gamesCountingTemplates.countingTemplateId,
        ),
      );

  $$GamesCountingTemplatesTableProcessedTableManager
  get gamesCountingTemplatesRefs {
    final manager =
        $$GamesCountingTemplatesTableTableManager(
          $_db,
          $_db.gamesCountingTemplates,
        ).filter(
          (f) => f.countingTemplateId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _gamesCountingTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CountingTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $CountingTemplatesTable> {
  $$CountingTemplatesTableFilterComposer({
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

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamesCountingTemplatesRefs(
    Expression<bool> Function($$GamesCountingTemplatesTableFilterComposer f) f,
  ) {
    final $$GamesCountingTemplatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.countingTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableFilterComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CountingTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CountingTemplatesTable> {
  $$CountingTemplatesTableOrderingComposer({
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

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CountingTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CountingTemplatesTable> {
  $$CountingTemplatesTableAnnotationComposer({
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

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  Expression<T> gamesCountingTemplatesRefs<T extends Object>(
    Expression<T> Function($$GamesCountingTemplatesTableAnnotationComposer a) f,
  ) {
    final $$GamesCountingTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.countingTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CountingTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CountingTemplatesTable,
          CountingTemplate,
          $$CountingTemplatesTableFilterComposer,
          $$CountingTemplatesTableOrderingComposer,
          $$CountingTemplatesTableAnnotationComposer,
          $$CountingTemplatesTableCreateCompanionBuilder,
          $$CountingTemplatesTableUpdateCompanionBuilder,
          (CountingTemplate, $$CountingTemplatesTableReferences),
          CountingTemplate,
          PrefetchHooks Function({bool gamesCountingTemplatesRefs})
        > {
  $$CountingTemplatesTableTableManager(
    _$AppDatabase db,
    $CountingTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CountingTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CountingTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CountingTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> data = const Value.absent(),
              }) => CountingTemplatesCompanion(
                id: id,
                name: name,
                description: description,
                data: data,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required String data,
              }) => CountingTemplatesCompanion.insert(
                id: id,
                name: name,
                description: description,
                data: data,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CountingTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamesCountingTemplatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (gamesCountingTemplatesRefs) db.gamesCountingTemplates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamesCountingTemplatesRefs)
                    await $_getPrefetchedData<
                      CountingTemplate,
                      $CountingTemplatesTable,
                      GamesCountingTemplate
                    >(
                      currentTable: table,
                      referencedTable: $$CountingTemplatesTableReferences
                          ._gamesCountingTemplatesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CountingTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).gamesCountingTemplatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.countingTemplateId == item.id,
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

typedef $$CountingTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CountingTemplatesTable,
      CountingTemplate,
      $$CountingTemplatesTableFilterComposer,
      $$CountingTemplatesTableOrderingComposer,
      $$CountingTemplatesTableAnnotationComposer,
      $$CountingTemplatesTableCreateCompanionBuilder,
      $$CountingTemplatesTableUpdateCompanionBuilder,
      (CountingTemplate, $$CountingTemplatesTableReferences),
      CountingTemplate,
      PrefetchHooks Function({bool gamesCountingTemplatesRefs})
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

  static MultiTypedResultKey<$RatingsTable, List<Rating>> _ratingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ratings,
    aliasName: $_aliasNameGenerator(db.designers.id, db.ratings.designerId),
  );

  $$RatingsTableProcessedTableManager get ratingsRefs {
    final manager = $$RatingsTableTableManager(
      $_db,
      $_db.ratings,
    ).filter((f) => f.designerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ratingsRefsTable($_db));
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

  Expression<bool> ratingsRefs(
    Expression<bool> Function($$RatingsTableFilterComposer f) f,
  ) {
    final $$RatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.designerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableFilterComposer(
            $db: $db,
            $table: $db.ratings,
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

  Expression<T> ratingsRefs<T extends Object>(
    Expression<T> Function($$RatingsTableAnnotationComposer a) f,
  ) {
    final $$RatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.designerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratings,
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
          PrefetchHooks Function({bool gamesDesignersRefs, bool ratingsRefs})
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
          prefetchHooksCallback:
              ({gamesDesignersRefs = false, ratingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamesDesignersRefs) db.gamesDesigners,
                    if (ratingsRefs) db.ratings,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.designerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ratingsRefs)
                        await $_getPrefetchedData<
                          Designer,
                          $DesignersTable,
                          Rating
                        >(
                          currentTable: table,
                          referencedTable: $$DesignersTableReferences
                              ._ratingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DesignersTableReferences(
                                db,
                                table,
                                p0,
                              ).ratingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.designerId == item.id,
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
      PrefetchHooks Function({bool gamesDesignersRefs, bool ratingsRefs})
    >;
typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> year,
      Value<int?> minPlayers,
      Value<int?> maxPlayers,
      Value<bool> isInCollection,
      Value<bool> isFavorite,
      Value<double?> rating,
      Value<bool> isStandalone,
      Value<String?> imagePath,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> year,
      Value<int?> minPlayers,
      Value<int?> maxPlayers,
      Value<bool> isInCollection,
      Value<bool> isFavorite,
      Value<double?> rating,
      Value<bool> isStandalone,
      Value<String?> imagePath,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpansionsGamesTable, List<ExpansionsGame>>
  _expansionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expansionsGames,
    aliasName: $_aliasNameGenerator(
      db.games.id,
      db.expansionsGames.expansionId,
    ),
  );

  $$ExpansionsGamesTableProcessedTableManager get expansions {
    final manager = $$ExpansionsGamesTableTableManager(
      $_db,
      $_db.expansionsGames,
    ).filter((f) => f.expansionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expansionsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpansionsGamesTable, List<ExpansionsGame>>
  _basesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expansionsGames,
    aliasName: $_aliasNameGenerator(db.games.id, db.expansionsGames.gameId),
  );

  $$ExpansionsGamesTableProcessedTableManager get bases {
    final manager = $$ExpansionsGamesTableTableManager(
      $_db,
      $_db.expansionsGames,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_basesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  static MultiTypedResultKey<
    $GamesCountingTemplatesTable,
    List<GamesCountingTemplate>
  >
  _gamesCountingTemplatesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamesCountingTemplates,
        aliasName: $_aliasNameGenerator(
          db.games.id,
          db.gamesCountingTemplates.gameId,
        ),
      );

  $$GamesCountingTemplatesTableProcessedTableManager
  get gamesCountingTemplatesRefs {
    final manager = $$GamesCountingTemplatesTableTableManager(
      $_db,
      $_db.gamesCountingTemplates,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gamesCountingTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GamesCountingTemplatesExpansionsTable,
    List<GamesCountingTemplatesExpansion>
  >
  _gamesCountingTemplatesExpansionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamesCountingTemplatesExpansions,
        aliasName: $_aliasNameGenerator(
          db.games.id,
          db.gamesCountingTemplatesExpansions.gameId,
        ),
      );

  $$GamesCountingTemplatesExpansionsTableProcessedTableManager
  get gamesCountingTemplatesExpansionsRefs {
    final manager = $$GamesCountingTemplatesExpansionsTableTableManager(
      $_db,
      $_db.gamesCountingTemplatesExpansions,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gamesCountingTemplatesExpansionsRefsTable($_db),
    );
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

  static MultiTypedResultKey<
    $GamingSessionsExpansionsTable,
    List<GamingSessionsExpansion>
  >
  _gamingSessionsExpansionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamingSessionsExpansions,
        aliasName: $_aliasNameGenerator(
          db.games.id,
          db.gamingSessionsExpansions.gameId,
        ),
      );

  $$GamingSessionsExpansionsTableProcessedTableManager
  get gamingSessionsExpansionsRefs {
    final manager = $$GamingSessionsExpansionsTableTableManager(
      $_db,
      $_db.gamingSessionsExpansions,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gamingSessionsExpansionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: $_aliasNameGenerator(db.games.id, db.notes.gameId),
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RatingsGamesTable, List<RatingsGame>>
  _ratingsGamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ratingsGames,
    aliasName: $_aliasNameGenerator(db.games.id, db.ratingsGames.gameId),
  );

  $$RatingsGamesTableProcessedTableManager get ratingsGamesRefs {
    final manager = $$RatingsGamesTableTableManager(
      $_db,
      $_db.ratingsGames,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ratingsGamesRefsTable($_db));
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

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStandalone => $composableBuilder(
    column: $table.isStandalone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expansions(
    Expression<bool> Function($$ExpansionsGamesTableFilterComposer f) f,
  ) {
    final $$ExpansionsGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expansionsGames,
      getReferencedColumn: (t) => t.expansionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpansionsGamesTableFilterComposer(
            $db: $db,
            $table: $db.expansionsGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bases(
    Expression<bool> Function($$ExpansionsGamesTableFilterComposer f) f,
  ) {
    final $$ExpansionsGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expansionsGames,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpansionsGamesTableFilterComposer(
            $db: $db,
            $table: $db.expansionsGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  Expression<bool> gamesCountingTemplatesRefs(
    Expression<bool> Function($$GamesCountingTemplatesTableFilterComposer f) f,
  ) {
    final $$GamesCountingTemplatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableFilterComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> gamesCountingTemplatesExpansionsRefs(
    Expression<bool> Function(
      $$GamesCountingTemplatesExpansionsTableFilterComposer f,
    )
    f,
  ) {
    final $$GamesCountingTemplatesExpansionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplatesExpansions,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesExpansionsTableFilterComposer(
                $db: $db,
                $table: $db.gamesCountingTemplatesExpansions,
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

  Expression<bool> gamingSessionsExpansionsRefs(
    Expression<bool> Function($$GamingSessionsExpansionsTableFilterComposer f)
    f,
  ) {
    final $$GamingSessionsExpansionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamingSessionsExpansions,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamingSessionsExpansionsTableFilterComposer(
                $db: $db,
                $table: $db.gamingSessionsExpansions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ratingsGamesRefs(
    Expression<bool> Function($$RatingsGamesTableFilterComposer f) f,
  ) {
    final $$RatingsGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratingsGames,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsGamesTableFilterComposer(
            $db: $db,
            $table: $db.ratingsGames,
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

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStandalone => $composableBuilder(
    column: $table.isStandalone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isStandalone => $composableBuilder(
    column: $table.isStandalone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  Expression<T> expansions<T extends Object>(
    Expression<T> Function($$ExpansionsGamesTableAnnotationComposer a) f,
  ) {
    final $$ExpansionsGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expansionsGames,
      getReferencedColumn: (t) => t.expansionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpansionsGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.expansionsGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bases<T extends Object>(
    Expression<T> Function($$ExpansionsGamesTableAnnotationComposer a) f,
  ) {
    final $$ExpansionsGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expansionsGames,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpansionsGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.expansionsGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  Expression<T> gamesCountingTemplatesRefs<T extends Object>(
    Expression<T> Function($$GamesCountingTemplatesTableAnnotationComposer a) f,
  ) {
    final $$GamesCountingTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> gamesCountingTemplatesExpansionsRefs<T extends Object>(
    Expression<T> Function(
      $$GamesCountingTemplatesExpansionsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$GamesCountingTemplatesExpansionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplatesExpansions,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesExpansionsTableAnnotationComposer(
                $db: $db,
                $table: $db.gamesCountingTemplatesExpansions,
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

  Expression<T> gamingSessionsExpansionsRefs<T extends Object>(
    Expression<T> Function($$GamingSessionsExpansionsTableAnnotationComposer a)
    f,
  ) {
    final $$GamingSessionsExpansionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamingSessionsExpansions,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamingSessionsExpansionsTableAnnotationComposer(
                $db: $db,
                $table: $db.gamingSessionsExpansions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ratingsGamesRefs<T extends Object>(
    Expression<T> Function($$RatingsGamesTableAnnotationComposer a) f,
  ) {
    final $$RatingsGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratingsGames,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.ratingsGames,
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
            bool expansions,
            bool bases,
            bool gamesArtistsRefs,
            bool gamesCountingTemplatesRefs,
            bool gamesCountingTemplatesExpansionsRefs,
            bool gamesDesignersRefs,
            bool gamesTagsRefs,
            bool gamingSessionsRefs,
            bool gamingSessionsExpansionsRefs,
            bool notesRefs,
            bool ratingsGamesRefs,
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
                Value<bool> isInCollection = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isStandalone = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                name: name,
                description: description,
                year: year,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                isInCollection: isInCollection,
                isFavorite: isFavorite,
                rating: rating,
                isStandalone: isStandalone,
                imagePath: imagePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> year = const Value.absent(),
                Value<int?> minPlayers = const Value.absent(),
                Value<int?> maxPlayers = const Value.absent(),
                Value<bool> isInCollection = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<bool> isStandalone = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                name: name,
                description: description,
                year: year,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                isInCollection: isInCollection,
                isFavorite: isFavorite,
                rating: rating,
                isStandalone: isStandalone,
                imagePath: imagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                expansions = false,
                bases = false,
                gamesArtistsRefs = false,
                gamesCountingTemplatesRefs = false,
                gamesCountingTemplatesExpansionsRefs = false,
                gamesDesignersRefs = false,
                gamesTagsRefs = false,
                gamingSessionsRefs = false,
                gamingSessionsExpansionsRefs = false,
                notesRefs = false,
                ratingsGamesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (expansions) db.expansionsGames,
                    if (bases) db.expansionsGames,
                    if (gamesArtistsRefs) db.gamesArtists,
                    if (gamesCountingTemplatesRefs) db.gamesCountingTemplates,
                    if (gamesCountingTemplatesExpansionsRefs)
                      db.gamesCountingTemplatesExpansions,
                    if (gamesDesignersRefs) db.gamesDesigners,
                    if (gamesTagsRefs) db.gamesTags,
                    if (gamingSessionsRefs) db.gamingSessions,
                    if (gamingSessionsExpansionsRefs)
                      db.gamingSessionsExpansions,
                    if (notesRefs) db.notes,
                    if (ratingsGamesRefs) db.ratingsGames,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expansions)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          ExpansionsGame
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._expansionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).expansions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expansionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bases)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          ExpansionsGame
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences._basesTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).bases,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
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
                      if (gamesCountingTemplatesRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamesCountingTemplate
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamesCountingTemplatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesCountingTemplatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gamesCountingTemplatesExpansionsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamesCountingTemplatesExpansion
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamesCountingTemplatesExpansionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesCountingTemplatesExpansionsRefs,
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
                      if (gamingSessionsExpansionsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamingSessionsExpansion
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamingSessionsExpansionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamingSessionsExpansionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<Game, $GamesTable, Note>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ratingsGamesRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          RatingsGame
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._ratingsGamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).ratingsGamesRefs,
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
        bool expansions,
        bool bases,
        bool gamesArtistsRefs,
        bool gamesCountingTemplatesRefs,
        bool gamesCountingTemplatesExpansionsRefs,
        bool gamesDesignersRefs,
        bool gamesTagsRefs,
        bool gamingSessionsRefs,
        bool gamingSessionsExpansionsRefs,
        bool notesRefs,
        bool ratingsGamesRefs,
      })
    >;
typedef $$ExpansionsGamesTableCreateCompanionBuilder =
    ExpansionsGamesCompanion Function({
      required int expansionId,
      required int gameId,
      Value<int> rowid,
    });
typedef $$ExpansionsGamesTableUpdateCompanionBuilder =
    ExpansionsGamesCompanion Function({
      Value<int> expansionId,
      Value<int> gameId,
      Value<int> rowid,
    });

final class $$ExpansionsGamesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExpansionsGamesTable, ExpansionsGame> {
  $$ExpansionsGamesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _expansionIdTable(_$AppDatabase db) =>
      db.games.createAlias(
        $_aliasNameGenerator(db.expansionsGames.expansionId, db.games.id),
      );

  $$GamesTableProcessedTableManager get expansionId {
    final $_column = $_itemColumn<int>('expansion_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expansionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.expansionsGames.gameId, db.games.id),
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
}

class $$ExpansionsGamesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpansionsGamesTable> {
  $$ExpansionsGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableFilterComposer get expansionId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expansionId,
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
}

class $$ExpansionsGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpansionsGamesTable> {
  $$ExpansionsGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableOrderingComposer get expansionId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expansionId,
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

class $$ExpansionsGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpansionsGamesTable> {
  $$ExpansionsGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesTableAnnotationComposer get expansionId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expansionId,
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
}

class $$ExpansionsGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpansionsGamesTable,
          ExpansionsGame,
          $$ExpansionsGamesTableFilterComposer,
          $$ExpansionsGamesTableOrderingComposer,
          $$ExpansionsGamesTableAnnotationComposer,
          $$ExpansionsGamesTableCreateCompanionBuilder,
          $$ExpansionsGamesTableUpdateCompanionBuilder,
          (ExpansionsGame, $$ExpansionsGamesTableReferences),
          ExpansionsGame,
          PrefetchHooks Function({bool expansionId, bool gameId})
        > {
  $$ExpansionsGamesTableTableManager(
    _$AppDatabase db,
    $ExpansionsGamesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpansionsGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpansionsGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpansionsGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> expansionId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpansionsGamesCompanion(
                expansionId: expansionId,
                gameId: gameId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int expansionId,
                required int gameId,
                Value<int> rowid = const Value.absent(),
              }) => ExpansionsGamesCompanion.insert(
                expansionId: expansionId,
                gameId: gameId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpansionsGamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expansionId = false, gameId = false}) {
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
                    if (expansionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expansionId,
                                referencedTable:
                                    $$ExpansionsGamesTableReferences
                                        ._expansionIdTable(db),
                                referencedColumn:
                                    $$ExpansionsGamesTableReferences
                                        ._expansionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$ExpansionsGamesTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$ExpansionsGamesTableReferences
                                        ._gameIdTable(db)
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

typedef $$ExpansionsGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpansionsGamesTable,
      ExpansionsGame,
      $$ExpansionsGamesTableFilterComposer,
      $$ExpansionsGamesTableOrderingComposer,
      $$ExpansionsGamesTableAnnotationComposer,
      $$ExpansionsGamesTableCreateCompanionBuilder,
      $$ExpansionsGamesTableUpdateCompanionBuilder,
      (ExpansionsGame, $$ExpansionsGamesTableReferences),
      ExpansionsGame,
      PrefetchHooks Function({bool expansionId, bool gameId})
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
typedef $$GamesCountingTemplatesTableCreateCompanionBuilder =
    GamesCountingTemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> data,
      required int gameId,
      required int countingTemplateId,
    });
typedef $$GamesCountingTemplatesTableUpdateCompanionBuilder =
    GamesCountingTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> data,
      Value<int> gameId,
      Value<int> countingTemplateId,
    });

final class $$GamesCountingTemplatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GamesCountingTemplatesTable,
          GamesCountingTemplate
        > {
  $$GamesCountingTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamesCountingTemplates.gameId, db.games.id),
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

  static $CountingTemplatesTable _countingTemplateIdTable(_$AppDatabase db) =>
      db.countingTemplates.createAlias(
        $_aliasNameGenerator(
          db.gamesCountingTemplates.countingTemplateId,
          db.countingTemplates.id,
        ),
      );

  $$CountingTemplatesTableProcessedTableManager get countingTemplateId {
    final $_column = $_itemColumn<int>('counting_template_id')!;

    final manager = $$CountingTemplatesTableTableManager(
      $_db,
      $_db.countingTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_countingTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $GamesCountingTemplatesExpansionsTable,
    List<GamesCountingTemplatesExpansion>
  >
  _gamesCountingTemplatesExpansionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamesCountingTemplatesExpansions,
        aliasName: $_aliasNameGenerator(
          db.gamesCountingTemplates.id,
          db.gamesCountingTemplatesExpansions.gamesCountingTemplateId,
        ),
      );

  $$GamesCountingTemplatesExpansionsTableProcessedTableManager
  get gamesCountingTemplatesExpansionsRefs {
    final manager =
        $$GamesCountingTemplatesExpansionsTableTableManager(
          $_db,
          $_db.gamesCountingTemplatesExpansions,
        ).filter(
          (f) =>
              f.gamesCountingTemplateId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _gamesCountingTemplatesExpansionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesCountingTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $GamesCountingTemplatesTable> {
  $$GamesCountingTemplatesTableFilterComposer({
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

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
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

  $$CountingTemplatesTableFilterComposer get countingTemplateId {
    final $$CountingTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.countingTemplateId,
      referencedTable: $db.countingTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CountingTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.countingTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gamesCountingTemplatesExpansionsRefs(
    Expression<bool> Function(
      $$GamesCountingTemplatesExpansionsTableFilterComposer f,
    )
    f,
  ) {
    final $$GamesCountingTemplatesExpansionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplatesExpansions,
          getReferencedColumn: (t) => t.gamesCountingTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesExpansionsTableFilterComposer(
                $db: $db,
                $table: $db.gamesCountingTemplatesExpansions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GamesCountingTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesCountingTemplatesTable> {
  $$GamesCountingTemplatesTableOrderingComposer({
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

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
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

  $$CountingTemplatesTableOrderingComposer get countingTemplateId {
    final $$CountingTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.countingTemplateId,
      referencedTable: $db.countingTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CountingTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.countingTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesCountingTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesCountingTemplatesTable> {
  $$GamesCountingTemplatesTableAnnotationComposer({
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

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

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

  $$CountingTemplatesTableAnnotationComposer get countingTemplateId {
    final $$CountingTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.countingTemplateId,
          referencedTable: $db.countingTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CountingTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.countingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> gamesCountingTemplatesExpansionsRefs<T extends Object>(
    Expression<T> Function(
      $$GamesCountingTemplatesExpansionsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$GamesCountingTemplatesExpansionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamesCountingTemplatesExpansions,
          getReferencedColumn: (t) => t.gamesCountingTemplateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesExpansionsTableAnnotationComposer(
                $db: $db,
                $table: $db.gamesCountingTemplatesExpansions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GamesCountingTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesCountingTemplatesTable,
          GamesCountingTemplate,
          $$GamesCountingTemplatesTableFilterComposer,
          $$GamesCountingTemplatesTableOrderingComposer,
          $$GamesCountingTemplatesTableAnnotationComposer,
          $$GamesCountingTemplatesTableCreateCompanionBuilder,
          $$GamesCountingTemplatesTableUpdateCompanionBuilder,
          (GamesCountingTemplate, $$GamesCountingTemplatesTableReferences),
          GamesCountingTemplate,
          PrefetchHooks Function({
            bool gameId,
            bool countingTemplateId,
            bool gamesCountingTemplatesExpansionsRefs,
          })
        > {
  $$GamesCountingTemplatesTableTableManager(
    _$AppDatabase db,
    $GamesCountingTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesCountingTemplatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GamesCountingTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GamesCountingTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> countingTemplateId = const Value.absent(),
              }) => GamesCountingTemplatesCompanion(
                id: id,
                name: name,
                data: data,
                gameId: gameId,
                countingTemplateId: countingTemplateId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> data = const Value.absent(),
                required int gameId,
                required int countingTemplateId,
              }) => GamesCountingTemplatesCompanion.insert(
                id: id,
                name: name,
                data: data,
                gameId: gameId,
                countingTemplateId: countingTemplateId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamesCountingTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                gameId = false,
                countingTemplateId = false,
                gamesCountingTemplatesExpansionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamesCountingTemplatesExpansionsRefs)
                      db.gamesCountingTemplatesExpansions,
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
                                        $$GamesCountingTemplatesTableReferences
                                            ._gameIdTable(db),
                                    referencedColumn:
                                        $$GamesCountingTemplatesTableReferences
                                            ._gameIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (countingTemplateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.countingTemplateId,
                                    referencedTable:
                                        $$GamesCountingTemplatesTableReferences
                                            ._countingTemplateIdTable(db),
                                    referencedColumn:
                                        $$GamesCountingTemplatesTableReferences
                                            ._countingTemplateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamesCountingTemplatesExpansionsRefs)
                        await $_getPrefetchedData<
                          GamesCountingTemplate,
                          $GamesCountingTemplatesTable,
                          GamesCountingTemplatesExpansion
                        >(
                          currentTable: table,
                          referencedTable:
                              $$GamesCountingTemplatesTableReferences
                                  ._gamesCountingTemplatesExpansionsRefsTable(
                                    db,
                                  ),
                          managerFromTypedResult: (p0) =>
                              $$GamesCountingTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesCountingTemplatesExpansionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gamesCountingTemplateId == item.id,
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

typedef $$GamesCountingTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesCountingTemplatesTable,
      GamesCountingTemplate,
      $$GamesCountingTemplatesTableFilterComposer,
      $$GamesCountingTemplatesTableOrderingComposer,
      $$GamesCountingTemplatesTableAnnotationComposer,
      $$GamesCountingTemplatesTableCreateCompanionBuilder,
      $$GamesCountingTemplatesTableUpdateCompanionBuilder,
      (GamesCountingTemplate, $$GamesCountingTemplatesTableReferences),
      GamesCountingTemplate,
      PrefetchHooks Function({
        bool gameId,
        bool countingTemplateId,
        bool gamesCountingTemplatesExpansionsRefs,
      })
    >;
typedef $$GamesCountingTemplatesExpansionsTableCreateCompanionBuilder =
    GamesCountingTemplatesExpansionsCompanion Function({
      required int gamesCountingTemplateId,
      required int gameId,
      Value<int> rowid,
    });
typedef $$GamesCountingTemplatesExpansionsTableUpdateCompanionBuilder =
    GamesCountingTemplatesExpansionsCompanion Function({
      Value<int> gamesCountingTemplateId,
      Value<int> gameId,
      Value<int> rowid,
    });

final class $$GamesCountingTemplatesExpansionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GamesCountingTemplatesExpansionsTable,
          GamesCountingTemplatesExpansion
        > {
  $$GamesCountingTemplatesExpansionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesCountingTemplatesTable _gamesCountingTemplateIdTable(
    _$AppDatabase db,
  ) => db.gamesCountingTemplates.createAlias(
    $_aliasNameGenerator(
      db.gamesCountingTemplatesExpansions.gamesCountingTemplateId,
      db.gamesCountingTemplates.id,
    ),
  );

  $$GamesCountingTemplatesTableProcessedTableManager
  get gamesCountingTemplateId {
    final $_column = $_itemColumn<int>('games_counting_template_id')!;

    final manager = $$GamesCountingTemplatesTableTableManager(
      $_db,
      $_db.gamesCountingTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _gamesCountingTemplateIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(
      db.gamesCountingTemplatesExpansions.gameId,
      db.games.id,
    ),
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
}

class $$GamesCountingTemplatesExpansionsTableFilterComposer
    extends Composer<_$AppDatabase, $GamesCountingTemplatesExpansionsTable> {
  $$GamesCountingTemplatesExpansionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesCountingTemplatesTableFilterComposer get gamesCountingTemplateId {
    final $$GamesCountingTemplatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.gamesCountingTemplateId,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableFilterComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

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
}

class $$GamesCountingTemplatesExpansionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesCountingTemplatesExpansionsTable> {
  $$GamesCountingTemplatesExpansionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesCountingTemplatesTableOrderingComposer get gamesCountingTemplateId {
    final $$GamesCountingTemplatesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.gamesCountingTemplateId,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableOrderingComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

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

class $$GamesCountingTemplatesExpansionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesCountingTemplatesExpansionsTable> {
  $$GamesCountingTemplatesExpansionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GamesCountingTemplatesTableAnnotationComposer get gamesCountingTemplateId {
    final $$GamesCountingTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.gamesCountingTemplateId,
          referencedTable: $db.gamesCountingTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamesCountingTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.gamesCountingTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

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
}

class $$GamesCountingTemplatesExpansionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesCountingTemplatesExpansionsTable,
          GamesCountingTemplatesExpansion,
          $$GamesCountingTemplatesExpansionsTableFilterComposer,
          $$GamesCountingTemplatesExpansionsTableOrderingComposer,
          $$GamesCountingTemplatesExpansionsTableAnnotationComposer,
          $$GamesCountingTemplatesExpansionsTableCreateCompanionBuilder,
          $$GamesCountingTemplatesExpansionsTableUpdateCompanionBuilder,
          (
            GamesCountingTemplatesExpansion,
            $$GamesCountingTemplatesExpansionsTableReferences,
          ),
          GamesCountingTemplatesExpansion,
          PrefetchHooks Function({bool gamesCountingTemplateId, bool gameId})
        > {
  $$GamesCountingTemplatesExpansionsTableTableManager(
    _$AppDatabase db,
    $GamesCountingTemplatesExpansionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesCountingTemplatesExpansionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GamesCountingTemplatesExpansionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GamesCountingTemplatesExpansionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> gamesCountingTemplateId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCountingTemplatesExpansionsCompanion(
                gamesCountingTemplateId: gamesCountingTemplateId,
                gameId: gameId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gamesCountingTemplateId,
                required int gameId,
                Value<int> rowid = const Value.absent(),
              }) => GamesCountingTemplatesExpansionsCompanion.insert(
                gamesCountingTemplateId: gamesCountingTemplateId,
                gameId: gameId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamesCountingTemplatesExpansionsTableReferences(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamesCountingTemplateId = false, gameId = false}) {
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
                    if (gamesCountingTemplateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gamesCountingTemplateId,
                                referencedTable:
                                    $$GamesCountingTemplatesExpansionsTableReferences
                                        ._gamesCountingTemplateIdTable(db),
                                referencedColumn:
                                    $$GamesCountingTemplatesExpansionsTableReferences
                                        ._gamesCountingTemplateIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$GamesCountingTemplatesExpansionsTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$GamesCountingTemplatesExpansionsTableReferences
                                        ._gameIdTable(db)
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

typedef $$GamesCountingTemplatesExpansionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesCountingTemplatesExpansionsTable,
      GamesCountingTemplatesExpansion,
      $$GamesCountingTemplatesExpansionsTableFilterComposer,
      $$GamesCountingTemplatesExpansionsTableOrderingComposer,
      $$GamesCountingTemplatesExpansionsTableAnnotationComposer,
      $$GamesCountingTemplatesExpansionsTableCreateCompanionBuilder,
      $$GamesCountingTemplatesExpansionsTableUpdateCompanionBuilder,
      (
        GamesCountingTemplatesExpansion,
        $$GamesCountingTemplatesExpansionsTableReferences,
      ),
      GamesCountingTemplatesExpansion,
      PrefetchHooks Function({bool gamesCountingTemplateId, bool gameId})
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

  static MultiTypedResultKey<$RatingsTable, List<Rating>> _ratingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ratings,
    aliasName: $_aliasNameGenerator(db.tags.id, db.ratings.tagId),
  );

  $$RatingsTableProcessedTableManager get ratingsRefs {
    final manager = $$RatingsTableTableManager(
      $_db,
      $_db.ratings,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ratingsRefsTable($_db));
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

  Expression<bool> ratingsRefs(
    Expression<bool> Function($$RatingsTableFilterComposer f) f,
  ) {
    final $$RatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableFilterComposer(
            $db: $db,
            $table: $db.ratings,
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

  Expression<T> ratingsRefs<T extends Object>(
    Expression<T> Function($$RatingsTableAnnotationComposer a) f,
  ) {
    final $$RatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratings,
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
          PrefetchHooks Function({bool gamesTagsRefs, bool ratingsRefs})
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
          prefetchHooksCallback:
              ({gamesTagsRefs = false, ratingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamesTagsRefs) db.gamesTags,
                    if (ratingsRefs) db.ratings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamesTagsRefs)
                        await $_getPrefetchedData<Tag, $TagsTable, GamesTag>(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._gamesTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).gamesTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ratingsRefs)
                        await $_getPrefetchedData<Tag, $TagsTable, Rating>(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._ratingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TagsTableReferences(db, table, p0).ratingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
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
      PrefetchHooks Function({bool gamesTagsRefs, bool ratingsRefs})
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
      required DateTime startedAt,
      required DateTime finishedAt,
      Value<bool> isFinished,
      Value<String?> comment,
      Value<int?> gameType,
      Value<String?> data,
      Value<int?> rootSessionId,
    });
typedef $$GamingSessionsTableUpdateCompanionBuilder =
    GamingSessionsCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<DateTime> startedAt,
      Value<DateTime> finishedAt,
      Value<bool> isFinished,
      Value<String?> comment,
      Value<int?> gameType,
      Value<String?> data,
      Value<int?> rootSessionId,
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

  static $GamingSessionsTable _rootSessionIdTable(_$AppDatabase db) =>
      db.gamingSessions.createAlias(
        $_aliasNameGenerator(
          db.gamingSessions.rootSessionId,
          db.gamingSessions.id,
        ),
      );

  $$GamingSessionsTableProcessedTableManager? get rootSessionId {
    final $_column = $_itemColumn<int>('root_session_id');
    if ($_column == null) return null;
    final manager = $$GamingSessionsTableTableManager(
      $_db,
      $_db.gamingSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $GamingSessionsExpansionsTable,
    List<GamingSessionsExpansion>
  >
  _gamingSessionsExpansionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.gamingSessionsExpansions,
        aliasName: $_aliasNameGenerator(
          db.gamingSessions.id,
          db.gamingSessionsExpansions.gamingSessionId,
        ),
      );

  $$GamingSessionsExpansionsTableProcessedTableManager
  get gamingSessionsExpansionsRefs {
    final manager = $$GamingSessionsExpansionsTableTableManager(
      $_db,
      $_db.gamingSessionsExpansions,
    ).filter((f) => f.gamingSessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _gamingSessionsExpansionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
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

  $$GamingSessionsTableFilterComposer get rootSessionId {
    final $$GamingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootSessionId,
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

  Expression<bool> gamingSessionsExpansionsRefs(
    Expression<bool> Function($$GamingSessionsExpansionsTableFilterComposer f)
    f,
  ) {
    final $$GamingSessionsExpansionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamingSessionsExpansions,
          getReferencedColumn: (t) => t.gamingSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamingSessionsExpansionsTableFilterComposer(
                $db: $db,
                $table: $db.gamingSessionsExpansions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
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

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
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

  $$GamingSessionsTableOrderingComposer get rootSessionId {
    final $$GamingSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootSessionId,
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

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

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

  $$GamingSessionsTableAnnotationComposer get rootSessionId {
    final $$GamingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootSessionId,
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

  Expression<T> gamingSessionsExpansionsRefs<T extends Object>(
    Expression<T> Function($$GamingSessionsExpansionsTableAnnotationComposer a)
    f,
  ) {
    final $$GamingSessionsExpansionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.gamingSessionsExpansions,
          getReferencedColumn: (t) => t.gamingSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GamingSessionsExpansionsTableAnnotationComposer(
                $db: $db,
                $table: $db.gamingSessionsExpansions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
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
          PrefetchHooks Function({
            bool gameId,
            bool rootSessionId,
            bool gamingSessionsExpansionsRefs,
            bool gamingSessionsGamersRefs,
          })
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
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> gameType = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<int?> rootSessionId = const Value.absent(),
              }) => GamingSessionsCompanion(
                id: id,
                gameId: gameId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                isFinished: isFinished,
                comment: comment,
                gameType: gameType,
                data: data,
                rootSessionId: rootSessionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required DateTime startedAt,
                required DateTime finishedAt,
                Value<bool> isFinished = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int?> gameType = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<int?> rootSessionId = const Value.absent(),
              }) => GamingSessionsCompanion.insert(
                id: id,
                gameId: gameId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                isFinished: isFinished,
                comment: comment,
                gameType: gameType,
                data: data,
                rootSessionId: rootSessionId,
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
              ({
                gameId = false,
                rootSessionId = false,
                gamingSessionsExpansionsRefs = false,
                gamingSessionsGamersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamingSessionsExpansionsRefs)
                      db.gamingSessionsExpansions,
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
                        if (rootSessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.rootSessionId,
                                    referencedTable:
                                        $$GamingSessionsTableReferences
                                            ._rootSessionIdTable(db),
                                    referencedColumn:
                                        $$GamingSessionsTableReferences
                                            ._rootSessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamingSessionsExpansionsRefs)
                        await $_getPrefetchedData<
                          GamingSession,
                          $GamingSessionsTable,
                          GamingSessionsExpansion
                        >(
                          currentTable: table,
                          referencedTable: $$GamingSessionsTableReferences
                              ._gamingSessionsExpansionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamingSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).gamingSessionsExpansionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gamingSessionId == item.id,
                              ),
                          typedResults: items,
                        ),
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
      PrefetchHooks Function({
        bool gameId,
        bool rootSessionId,
        bool gamingSessionsExpansionsRefs,
        bool gamingSessionsGamersRefs,
      })
    >;
typedef $$GamingSessionsExpansionsTableCreateCompanionBuilder =
    GamingSessionsExpansionsCompanion Function({
      required int gamingSessionId,
      required int gameId,
      Value<int> rowid,
    });
typedef $$GamingSessionsExpansionsTableUpdateCompanionBuilder =
    GamingSessionsExpansionsCompanion Function({
      Value<int> gamingSessionId,
      Value<int> gameId,
      Value<int> rowid,
    });

final class $$GamingSessionsExpansionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GamingSessionsExpansionsTable,
          GamingSessionsExpansion
        > {
  $$GamingSessionsExpansionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamingSessionsTable _gamingSessionIdTable(_$AppDatabase db) =>
      db.gamingSessions.createAlias(
        $_aliasNameGenerator(
          db.gamingSessionsExpansions.gamingSessionId,
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

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamingSessionsExpansions.gameId, db.games.id),
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
}

class $$GamingSessionsExpansionsTableFilterComposer
    extends Composer<_$AppDatabase, $GamingSessionsExpansionsTable> {
  $$GamingSessionsExpansionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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
}

class $$GamingSessionsExpansionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GamingSessionsExpansionsTable> {
  $$GamingSessionsExpansionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

class $$GamingSessionsExpansionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamingSessionsExpansionsTable> {
  $$GamingSessionsExpansionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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
}

class $$GamingSessionsExpansionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamingSessionsExpansionsTable,
          GamingSessionsExpansion,
          $$GamingSessionsExpansionsTableFilterComposer,
          $$GamingSessionsExpansionsTableOrderingComposer,
          $$GamingSessionsExpansionsTableAnnotationComposer,
          $$GamingSessionsExpansionsTableCreateCompanionBuilder,
          $$GamingSessionsExpansionsTableUpdateCompanionBuilder,
          (GamingSessionsExpansion, $$GamingSessionsExpansionsTableReferences),
          GamingSessionsExpansion,
          PrefetchHooks Function({bool gamingSessionId, bool gameId})
        > {
  $$GamingSessionsExpansionsTableTableManager(
    _$AppDatabase db,
    $GamingSessionsExpansionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamingSessionsExpansionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GamingSessionsExpansionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GamingSessionsExpansionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> gamingSessionId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamingSessionsExpansionsCompanion(
                gamingSessionId: gamingSessionId,
                gameId: gameId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gamingSessionId,
                required int gameId,
                Value<int> rowid = const Value.absent(),
              }) => GamingSessionsExpansionsCompanion.insert(
                gamingSessionId: gamingSessionId,
                gameId: gameId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamingSessionsExpansionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamingSessionId = false, gameId = false}) {
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
                                    $$GamingSessionsExpansionsTableReferences
                                        ._gamingSessionIdTable(db),
                                referencedColumn:
                                    $$GamingSessionsExpansionsTableReferences
                                        ._gamingSessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$GamingSessionsExpansionsTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$GamingSessionsExpansionsTableReferences
                                        ._gameIdTable(db)
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

typedef $$GamingSessionsExpansionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamingSessionsExpansionsTable,
      GamingSessionsExpansion,
      $$GamingSessionsExpansionsTableFilterComposer,
      $$GamingSessionsExpansionsTableOrderingComposer,
      $$GamingSessionsExpansionsTableAnnotationComposer,
      $$GamingSessionsExpansionsTableCreateCompanionBuilder,
      $$GamingSessionsExpansionsTableUpdateCompanionBuilder,
      (GamingSessionsExpansion, $$GamingSessionsExpansionsTableReferences),
      GamingSessionsExpansion,
      PrefetchHooks Function({bool gamingSessionId, bool gameId})
    >;
typedef $$GamingSessionsGamersTableCreateCompanionBuilder =
    GamingSessionsGamersCompanion Function({
      required int gamingSessionId,
      required int gamerId,
      Value<int?> score,
      Value<int?> place,
      Value<int?> turnOrder,
      Value<int?> team,
      Value<String?> data,
      Value<int> rowid,
    });
typedef $$GamingSessionsGamersTableUpdateCompanionBuilder =
    GamingSessionsGamersCompanion Function({
      Value<int> gamingSessionId,
      Value<int> gamerId,
      Value<int?> score,
      Value<int?> place,
      Value<int?> turnOrder,
      Value<int?> team,
      Value<String?> data,
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

  ColumnFilters<int> get team => $composableBuilder(
    column: $table.team,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
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

  ColumnOrderings<int> get team => $composableBuilder(
    column: $table.team,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
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

  GeneratedColumn<int> get team =>
      $composableBuilder(column: $table.team, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

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
                Value<int?> team = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamingSessionsGamersCompanion(
                gamingSessionId: gamingSessionId,
                gamerId: gamerId,
                score: score,
                place: place,
                turnOrder: turnOrder,
                team: team,
                data: data,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gamingSessionId,
                required int gamerId,
                Value<int?> score = const Value.absent(),
                Value<int?> place = const Value.absent(),
                Value<int?> turnOrder = const Value.absent(),
                Value<int?> team = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamingSessionsGamersCompanion.insert(
                gamingSessionId: gamingSessionId,
                gamerId: gamerId,
                score: score,
                place: place,
                turnOrder: turnOrder,
                team: team,
                data: data,
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
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required int gameId,
      required String title,
      Value<String?> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<int> gameId,
      Value<String> title,
      Value<String?> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.notes.gameId, db.games.id));

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
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

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
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({bool gameId})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                gameId: gameId,
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gameId,
                required String title,
                Value<String?> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                gameId: gameId,
                title: title,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
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
                                referencedTable: $$NotesTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$NotesTableReferences
                                    ._gameIdTable(db)
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

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$RatingsTableCreateCompanionBuilder =
    RatingsCompanion Function({
      Value<int> id,
      required int year,
      Value<int?> month,
      Value<bool> isActual,
      required String data,
      Value<int?> artistId,
      Value<int?> designerId,
      Value<int?> tagId,
    });
typedef $$RatingsTableUpdateCompanionBuilder =
    RatingsCompanion Function({
      Value<int> id,
      Value<int> year,
      Value<int?> month,
      Value<bool> isActual,
      Value<String> data,
      Value<int?> artistId,
      Value<int?> designerId,
      Value<int?> tagId,
    });

final class $$RatingsTableReferences
    extends BaseReferences<_$AppDatabase, $RatingsTable, Rating> {
  $$RatingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ArtistsTable _artistIdTable(_$AppDatabase db) => db.artists
      .createAlias($_aliasNameGenerator(db.ratings.artistId, db.artists.id));

  $$ArtistsTableProcessedTableManager? get artistId {
    final $_column = $_itemColumn<int>('artist_id');
    if ($_column == null) return null;
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

  static $DesignersTable _designerIdTable(_$AppDatabase db) =>
      db.designers.createAlias(
        $_aliasNameGenerator(db.ratings.designerId, db.designers.id),
      );

  $$DesignersTableProcessedTableManager? get designerId {
    final $_column = $_itemColumn<int>('designer_id');
    if ($_column == null) return null;
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

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias($_aliasNameGenerator(db.ratings.tagId, db.tags.id));

  $$TagsTableProcessedTableManager? get tagId {
    final $_column = $_itemColumn<int>('tag_id');
    if ($_column == null) return null;
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

  static MultiTypedResultKey<$RatingsGamesTable, List<RatingsGame>>
  _ratingsGamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ratingsGames,
    aliasName: $_aliasNameGenerator(db.ratings.id, db.ratingsGames.ratingId),
  );

  $$RatingsGamesTableProcessedTableManager get ratingsGamesRefs {
    final manager = $$RatingsGamesTableTableManager(
      $_db,
      $_db.ratingsGames,
    ).filter((f) => f.ratingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ratingsGamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RatingsTableFilterComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableFilterComposer({
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

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActual => $composableBuilder(
    column: $table.isActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

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

  Expression<bool> ratingsGamesRefs(
    Expression<bool> Function($$RatingsGamesTableFilterComposer f) f,
  ) {
    final $$RatingsGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratingsGames,
      getReferencedColumn: (t) => t.ratingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsGamesTableFilterComposer(
            $db: $db,
            $table: $db.ratingsGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RatingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableOrderingComposer({
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

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActual => $composableBuilder(
    column: $table.isActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

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

class $$RatingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<bool> get isActual =>
      $composableBuilder(column: $table.isActual, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

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

  Expression<T> ratingsGamesRefs<T extends Object>(
    Expression<T> Function($$RatingsGamesTableAnnotationComposer a) f,
  ) {
    final $$RatingsGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ratingsGames,
      getReferencedColumn: (t) => t.ratingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.ratingsGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RatingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatingsTable,
          Rating,
          $$RatingsTableFilterComposer,
          $$RatingsTableOrderingComposer,
          $$RatingsTableAnnotationComposer,
          $$RatingsTableCreateCompanionBuilder,
          $$RatingsTableUpdateCompanionBuilder,
          (Rating, $$RatingsTableReferences),
          Rating,
          PrefetchHooks Function({
            bool artistId,
            bool designerId,
            bool tagId,
            bool ratingsGamesRefs,
          })
        > {
  $$RatingsTableTableManager(_$AppDatabase db, $RatingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<bool> isActual = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int?> artistId = const Value.absent(),
                Value<int?> designerId = const Value.absent(),
                Value<int?> tagId = const Value.absent(),
              }) => RatingsCompanion(
                id: id,
                year: year,
                month: month,
                isActual: isActual,
                data: data,
                artistId: artistId,
                designerId: designerId,
                tagId: tagId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int year,
                Value<int?> month = const Value.absent(),
                Value<bool> isActual = const Value.absent(),
                required String data,
                Value<int?> artistId = const Value.absent(),
                Value<int?> designerId = const Value.absent(),
                Value<int?> tagId = const Value.absent(),
              }) => RatingsCompanion.insert(
                id: id,
                year: year,
                month: month,
                isActual: isActual,
                data: data,
                artistId: artistId,
                designerId: designerId,
                tagId: tagId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RatingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                artistId = false,
                designerId = false,
                tagId = false,
                ratingsGamesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ratingsGamesRefs) db.ratingsGames,
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
                        if (artistId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.artistId,
                                    referencedTable: $$RatingsTableReferences
                                        ._artistIdTable(db),
                                    referencedColumn: $$RatingsTableReferences
                                        ._artistIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (designerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.designerId,
                                    referencedTable: $$RatingsTableReferences
                                        ._designerIdTable(db),
                                    referencedColumn: $$RatingsTableReferences
                                        ._designerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (tagId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tagId,
                                    referencedTable: $$RatingsTableReferences
                                        ._tagIdTable(db),
                                    referencedColumn: $$RatingsTableReferences
                                        ._tagIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ratingsGamesRefs)
                        await $_getPrefetchedData<
                          Rating,
                          $RatingsTable,
                          RatingsGame
                        >(
                          currentTable: table,
                          referencedTable: $$RatingsTableReferences
                              ._ratingsGamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RatingsTableReferences(
                                db,
                                table,
                                p0,
                              ).ratingsGamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ratingId == item.id,
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

typedef $$RatingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatingsTable,
      Rating,
      $$RatingsTableFilterComposer,
      $$RatingsTableOrderingComposer,
      $$RatingsTableAnnotationComposer,
      $$RatingsTableCreateCompanionBuilder,
      $$RatingsTableUpdateCompanionBuilder,
      (Rating, $$RatingsTableReferences),
      Rating,
      PrefetchHooks Function({
        bool artistId,
        bool designerId,
        bool tagId,
        bool ratingsGamesRefs,
      })
    >;
typedef $$RatingsGamesTableCreateCompanionBuilder =
    RatingsGamesCompanion Function({
      required int ratingId,
      required int gameId,
      Value<double?> score,
      Value<int?> place,
      Value<int> rowid,
    });
typedef $$RatingsGamesTableUpdateCompanionBuilder =
    RatingsGamesCompanion Function({
      Value<int> ratingId,
      Value<int> gameId,
      Value<double?> score,
      Value<int?> place,
      Value<int> rowid,
    });

final class $$RatingsGamesTableReferences
    extends BaseReferences<_$AppDatabase, $RatingsGamesTable, RatingsGame> {
  $$RatingsGamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RatingsTable _ratingIdTable(_$AppDatabase db) =>
      db.ratings.createAlias(
        $_aliasNameGenerator(db.ratingsGames.ratingId, db.ratings.id),
      );

  $$RatingsTableProcessedTableManager get ratingId {
    final $_column = $_itemColumn<int>('rating_id')!;

    final manager = $$RatingsTableTableManager(
      $_db,
      $_db.ratings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ratingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.ratingsGames.gameId, db.games.id),
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
}

class $$RatingsGamesTableFilterComposer
    extends Composer<_$AppDatabase, $RatingsGamesTable> {
  $$RatingsGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  $$RatingsTableFilterComposer get ratingId {
    final $$RatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ratingId,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableFilterComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$RatingsGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $RatingsGamesTable> {
  $$RatingsGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  $$RatingsTableOrderingComposer get ratingId {
    final $$RatingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ratingId,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableOrderingComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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

class $$RatingsGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatingsGamesTable> {
  $$RatingsGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  $$RatingsTableAnnotationComposer get ratingId {
    final $$RatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ratingId,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

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
}

class $$RatingsGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatingsGamesTable,
          RatingsGame,
          $$RatingsGamesTableFilterComposer,
          $$RatingsGamesTableOrderingComposer,
          $$RatingsGamesTableAnnotationComposer,
          $$RatingsGamesTableCreateCompanionBuilder,
          $$RatingsGamesTableUpdateCompanionBuilder,
          (RatingsGame, $$RatingsGamesTableReferences),
          RatingsGame,
          PrefetchHooks Function({bool ratingId, bool gameId})
        > {
  $$RatingsGamesTableTableManager(_$AppDatabase db, $RatingsGamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatingsGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatingsGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatingsGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ratingId = const Value.absent(),
                Value<int> gameId = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<int?> place = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatingsGamesCompanion(
                ratingId: ratingId,
                gameId: gameId,
                score: score,
                place: place,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ratingId,
                required int gameId,
                Value<double?> score = const Value.absent(),
                Value<int?> place = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatingsGamesCompanion.insert(
                ratingId: ratingId,
                gameId: gameId,
                score: score,
                place: place,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RatingsGamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ratingId = false, gameId = false}) {
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
                    if (ratingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ratingId,
                                referencedTable: $$RatingsGamesTableReferences
                                    ._ratingIdTable(db),
                                referencedColumn: $$RatingsGamesTableReferences
                                    ._ratingIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$RatingsGamesTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$RatingsGamesTableReferences
                                    ._gameIdTable(db)
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

typedef $$RatingsGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatingsGamesTable,
      RatingsGame,
      $$RatingsGamesTableFilterComposer,
      $$RatingsGamesTableOrderingComposer,
      $$RatingsGamesTableAnnotationComposer,
      $$RatingsGamesTableCreateCompanionBuilder,
      $$RatingsGamesTableUpdateCompanionBuilder,
      (RatingsGame, $$RatingsGamesTableReferences),
      RatingsGame,
      PrefetchHooks Function({bool ratingId, bool gameId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ArtistsTableTableManager get artists =>
      $$ArtistsTableTableManager(_db, _db.artists);
  $$CountingTemplatesTableTableManager get countingTemplates =>
      $$CountingTemplatesTableTableManager(_db, _db.countingTemplates);
  $$DesignersTableTableManager get designers =>
      $$DesignersTableTableManager(_db, _db.designers);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$ExpansionsGamesTableTableManager get expansionsGames =>
      $$ExpansionsGamesTableTableManager(_db, _db.expansionsGames);
  $$GamesArtistsTableTableManager get gamesArtists =>
      $$GamesArtistsTableTableManager(_db, _db.gamesArtists);
  $$GamesCountingTemplatesTableTableManager get gamesCountingTemplates =>
      $$GamesCountingTemplatesTableTableManager(
        _db,
        _db.gamesCountingTemplates,
      );
  $$GamesCountingTemplatesExpansionsTableTableManager
  get gamesCountingTemplatesExpansions =>
      $$GamesCountingTemplatesExpansionsTableTableManager(
        _db,
        _db.gamesCountingTemplatesExpansions,
      );
  $$GamesDesignersTableTableManager get gamesDesigners =>
      $$GamesDesignersTableTableManager(_db, _db.gamesDesigners);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$GamesTagsTableTableManager get gamesTags =>
      $$GamesTagsTableTableManager(_db, _db.gamesTags);
  $$GamersTableTableManager get gamers =>
      $$GamersTableTableManager(_db, _db.gamers);
  $$GamingSessionsTableTableManager get gamingSessions =>
      $$GamingSessionsTableTableManager(_db, _db.gamingSessions);
  $$GamingSessionsExpansionsTableTableManager get gamingSessionsExpansions =>
      $$GamingSessionsExpansionsTableTableManager(
        _db,
        _db.gamingSessionsExpansions,
      );
  $$GamingSessionsGamersTableTableManager get gamingSessionsGamers =>
      $$GamingSessionsGamersTableTableManager(_db, _db.gamingSessionsGamers);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db, _db.ratings);
  $$RatingsGamesTableTableManager get ratingsGames =>
      $$RatingsGamesTableTableManager(_db, _db.ratingsGames);
}
