// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  const Category({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(id: Value(id), name: Value(name));
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Category copyWith({String? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
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
      (other is Category && other.id == this.id && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandsTable extends Brands with TableInfo<$BrandsTable, Brand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, lastModifiedAt, needSync];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brands';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brand> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brand(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }
}

class Brand extends DataClass implements Insertable<Brand> {
  final String id;
  final String name;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Brand({
    required this.id,
    required this.name,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(
      id: Value(id),
      name: Value(name),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory Brand.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brand(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Brand copyWith({
    String? id,
    String? name,
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Brand(
    id: id ?? this.id,
    name: name ?? this.name,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  Brand copyWithCompanion(BrandsCompanion data) {
    return Brand(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brand(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lastModifiedAt, needSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brand &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class BrandsCompanion extends UpdateCompanion<Brand> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandsCompanion.insert({
    required String id,
    required String name,
    required DateTime lastModifiedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       lastModifiedAt = Value(lastModifiedAt);
  static Insertable<Brand> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return BrandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryId,
    description,
    isActive,
    createdAt,
    updatedAt,
    lastModifiedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String categoryId;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String>(categoryId),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    categoryId,
    description,
    isActive,
    createdAt,
    updatedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categoryId;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required String categoryId,
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime lastModifiedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastModifiedAt = Value(lastModifiedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? categoryId,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompanyItemsTable extends CompanyItems
    with TableInfo<$CompanyItemsTable, CompanyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanyItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyCodeMeta = const VerificationMeta(
    'companyCode',
  );
  @override
  late final GeneratedColumn<String> companyCode = GeneratedColumn<String>(
    'company_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSetMeta = const VerificationMeta('isSet');
  @override
  late final GeneratedColumn<bool> isSet = GeneratedColumn<bool>(
    'is_set',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_set" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hasComponentsMeta = const VerificationMeta(
    'hasComponents',
  );
  @override
  late final GeneratedColumn<bool> hasComponents = GeneratedColumn<bool>(
    'has_components',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_components" IN (0, 1))',
    ),
  );
  static const VerificationMeta _initializedAtMeta = const VerificationMeta(
    'initializedAt',
  );
  @override
  late final GeneratedColumn<DateTime> initializedAt =
      GeneratedColumn<DateTime>(
        'initialized_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _initializedByMeta = const VerificationMeta(
    'initializedBy',
  );
  @override
  late final GeneratedColumn<String> initializedBy = GeneratedColumn<String>(
    'initialized_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    companyCode,
    isSet,
    hasComponents,
    initializedAt,
    initializedBy,
    notes,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompanyItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('company_code')) {
      context.handle(
        _companyCodeMeta,
        companyCode.isAcceptableOrUnknown(
          data['company_code']!,
          _companyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyCodeMeta);
    }
    if (data.containsKey('is_set')) {
      context.handle(
        _isSetMeta,
        isSet.isAcceptableOrUnknown(data['is_set']!, _isSetMeta),
      );
    }
    if (data.containsKey('has_components')) {
      context.handle(
        _hasComponentsMeta,
        hasComponents.isAcceptableOrUnknown(
          data['has_components']!,
          _hasComponentsMeta,
        ),
      );
    }
    if (data.containsKey('initialized_at')) {
      context.handle(
        _initializedAtMeta,
        initializedAt.isAcceptableOrUnknown(
          data['initialized_at']!,
          _initializedAtMeta,
        ),
      );
    }
    if (data.containsKey('initialized_by')) {
      context.handle(
        _initializedByMeta,
        initializedBy.isAcceptableOrUnknown(
          data['initialized_by']!,
          _initializedByMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompanyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanyItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      companyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_code'],
      )!,
      isSet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_set'],
      ),
      hasComponents: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_components'],
      ),
      initializedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}initialized_at'],
      ),
      initializedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initialized_by'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $CompanyItemsTable createAlias(String alias) {
    return $CompanyItemsTable(attachedDatabase, alias);
  }
}

class CompanyItem extends DataClass implements Insertable<CompanyItem> {
  final String id;
  final String productId;
  final String companyCode;
  final bool? isSet;
  final bool? hasComponents;
  final DateTime? initializedAt;
  final String? initializedBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const CompanyItem({
    required this.id,
    required this.productId,
    required this.companyCode,
    this.isSet,
    this.hasComponents,
    this.initializedAt,
    this.initializedBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['company_code'] = Variable<String>(companyCode);
    if (!nullToAbsent || isSet != null) {
      map['is_set'] = Variable<bool>(isSet);
    }
    if (!nullToAbsent || hasComponents != null) {
      map['has_components'] = Variable<bool>(hasComponents);
    }
    if (!nullToAbsent || initializedAt != null) {
      map['initialized_at'] = Variable<DateTime>(initializedAt);
    }
    if (!nullToAbsent || initializedBy != null) {
      map['initialized_by'] = Variable<String>(initializedBy);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  CompanyItemsCompanion toCompanion(bool nullToAbsent) {
    return CompanyItemsCompanion(
      id: Value(id),
      productId: Value(productId),
      companyCode: Value(companyCode),
      isSet: isSet == null && nullToAbsent
          ? const Value.absent()
          : Value(isSet),
      hasComponents: hasComponents == null && nullToAbsent
          ? const Value.absent()
          : Value(hasComponents),
      initializedAt: initializedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(initializedAt),
      initializedBy: initializedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(initializedBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory CompanyItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanyItem(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      companyCode: serializer.fromJson<String>(json['companyCode']),
      isSet: serializer.fromJson<bool?>(json['isSet']),
      hasComponents: serializer.fromJson<bool?>(json['hasComponents']),
      initializedAt: serializer.fromJson<DateTime?>(json['initializedAt']),
      initializedBy: serializer.fromJson<String?>(json['initializedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'companyCode': serializer.toJson<String>(companyCode),
      'isSet': serializer.toJson<bool?>(isSet),
      'hasComponents': serializer.toJson<bool?>(hasComponents),
      'initializedAt': serializer.toJson<DateTime?>(initializedAt),
      'initializedBy': serializer.toJson<String?>(initializedBy),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  CompanyItem copyWith({
    String? id,
    String? productId,
    String? companyCode,
    Value<bool?> isSet = const Value.absent(),
    Value<bool?> hasComponents = const Value.absent(),
    Value<DateTime?> initializedAt = const Value.absent(),
    Value<String?> initializedBy = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => CompanyItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    companyCode: companyCode ?? this.companyCode,
    isSet: isSet.present ? isSet.value : this.isSet,
    hasComponents: hasComponents.present
        ? hasComponents.value
        : this.hasComponents,
    initializedAt: initializedAt.present
        ? initializedAt.value
        : this.initializedAt,
    initializedBy: initializedBy.present
        ? initializedBy.value
        : this.initializedBy,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  CompanyItem copyWithCompanion(CompanyItemsCompanion data) {
    return CompanyItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      companyCode: data.companyCode.present
          ? data.companyCode.value
          : this.companyCode,
      isSet: data.isSet.present ? data.isSet.value : this.isSet,
      hasComponents: data.hasComponents.present
          ? data.hasComponents.value
          : this.hasComponents,
      initializedAt: data.initializedAt.present
          ? data.initializedAt.value
          : this.initializedAt,
      initializedBy: data.initializedBy.present
          ? data.initializedBy.value
          : this.initializedBy,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompanyItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('companyCode: $companyCode, ')
          ..write('isSet: $isSet, ')
          ..write('hasComponents: $hasComponents, ')
          ..write('initializedAt: $initializedAt, ')
          ..write('initializedBy: $initializedBy, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    companyCode,
    isSet,
    hasComponents,
    initializedAt,
    initializedBy,
    notes,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompanyItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.companyCode == this.companyCode &&
          other.isSet == this.isSet &&
          other.hasComponents == this.hasComponents &&
          other.initializedAt == this.initializedAt &&
          other.initializedBy == this.initializedBy &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class CompanyItemsCompanion extends UpdateCompanion<CompanyItem> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> companyCode;
  final Value<bool?> isSet;
  final Value<bool?> hasComponents;
  final Value<DateTime?> initializedAt;
  final Value<String?> initializedBy;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const CompanyItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.companyCode = const Value.absent(),
    this.isSet = const Value.absent(),
    this.hasComponents = const Value.absent(),
    this.initializedAt = const Value.absent(),
    this.initializedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompanyItemsCompanion.insert({
    required String id,
    required String productId,
    required String companyCode,
    this.isSet = const Value.absent(),
    this.hasComponents = const Value.absent(),
    this.initializedAt = const Value.absent(),
    this.initializedBy = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required DateTime lastModifiedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       companyCode = Value(companyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastModifiedAt = Value(lastModifiedAt);
  static Insertable<CompanyItem> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? companyCode,
    Expression<bool>? isSet,
    Expression<bool>? hasComponents,
    Expression<DateTime>? initializedAt,
    Expression<String>? initializedBy,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (companyCode != null) 'company_code': companyCode,
      if (isSet != null) 'is_set': isSet,
      if (hasComponents != null) 'has_components': hasComponents,
      if (initializedAt != null) 'initialized_at': initializedAt,
      if (initializedBy != null) 'initialized_by': initializedBy,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompanyItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? companyCode,
    Value<bool?>? isSet,
    Value<bool?>? hasComponents,
    Value<DateTime?>? initializedAt,
    Value<String?>? initializedBy,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return CompanyItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      companyCode: companyCode ?? this.companyCode,
      isSet: isSet ?? this.isSet,
      hasComponents: hasComponents ?? this.hasComponents,
      initializedAt: initializedAt ?? this.initializedAt,
      initializedBy: initializedBy ?? this.initializedBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (companyCode.present) {
      map['company_code'] = Variable<String>(companyCode.value);
    }
    if (isSet.present) {
      map['is_set'] = Variable<bool>(isSet.value);
    }
    if (hasComponents.present) {
      map['has_components'] = Variable<bool>(hasComponents.value);
    }
    if (initializedAt.present) {
      map['initialized_at'] = Variable<DateTime>(initializedAt.value);
    }
    if (initializedBy.present) {
      map['initialized_by'] = Variable<String>(initializedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanyItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('companyCode: $companyCode, ')
          ..write('isSet: $isSet, ')
          ..write('hasComponents: $hasComponents, ')
          ..write('initializedAt: $initializedAt, ')
          ..write('initializedBy: $initializedBy, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VariantsTable extends Variants with TableInfo<$VariantsTable, Variant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyItemIdMeta = const VerificationMeta(
    'companyItemId',
  );
  @override
  late final GeneratedColumn<String> companyItemId = GeneratedColumn<String>(
    'company_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultLocationMeta = const VerificationMeta(
    'defaultLocation',
  );
  @override
  late final GeneratedColumn<String> defaultLocation = GeneratedColumn<String>(
    'default_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specJsonMeta = const VerificationMeta(
    'specJson',
  );
  @override
  late final GeneratedColumn<String> specJson = GeneratedColumn<String>(
    'spec_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initializedAtMeta = const VerificationMeta(
    'initializedAt',
  );
  @override
  late final GeneratedColumn<DateTime> initializedAt =
      GeneratedColumn<DateTime>(
        'initialized_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _initializedByMeta = const VerificationMeta(
    'initializedBy',
  );
  @override
  late final GeneratedColumn<String> initializedBy = GeneratedColumn<String>(
    'initialized_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyItemId,
    brandId,
    name,
    defaultLocation,
    specJson,
    initializedAt,
    initializedBy,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Variant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('company_item_id')) {
      context.handle(
        _companyItemIdMeta,
        companyItemId.isAcceptableOrUnknown(
          data['company_item_id']!,
          _companyItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyItemIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_location')) {
      context.handle(
        _defaultLocationMeta,
        defaultLocation.isAcceptableOrUnknown(
          data['default_location']!,
          _defaultLocationMeta,
        ),
      );
    }
    if (data.containsKey('spec_json')) {
      context.handle(
        _specJsonMeta,
        specJson.isAcceptableOrUnknown(data['spec_json']!, _specJsonMeta),
      );
    }
    if (data.containsKey('initialized_at')) {
      context.handle(
        _initializedAtMeta,
        initializedAt.isAcceptableOrUnknown(
          data['initialized_at']!,
          _initializedAtMeta,
        ),
      );
    }
    if (data.containsKey('initialized_by')) {
      context.handle(
        _initializedByMeta,
        initializedBy.isAcceptableOrUnknown(
          data['initialized_by']!,
          _initializedByMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Variant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Variant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      companyItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_item_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_location'],
      ),
      specJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec_json'],
      ),
      initializedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}initialized_at'],
      ),
      initializedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initialized_by'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $VariantsTable createAlias(String alias) {
    return $VariantsTable(attachedDatabase, alias);
  }
}

class Variant extends DataClass implements Insertable<Variant> {
  final String id;
  final String companyItemId;
  final String? brandId;
  final String name;
  final String? defaultLocation;
  final String? specJson;
  final DateTime? initializedAt;
  final String? initializedBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Variant({
    required this.id,
    required this.companyItemId,
    this.brandId,
    required this.name,
    this.defaultLocation,
    this.specJson,
    this.initializedAt,
    this.initializedBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['company_item_id'] = Variable<String>(companyItemId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || defaultLocation != null) {
      map['default_location'] = Variable<String>(defaultLocation);
    }
    if (!nullToAbsent || specJson != null) {
      map['spec_json'] = Variable<String>(specJson);
    }
    if (!nullToAbsent || initializedAt != null) {
      map['initialized_at'] = Variable<DateTime>(initializedAt);
    }
    if (!nullToAbsent || initializedBy != null) {
      map['initialized_by'] = Variable<String>(initializedBy);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  VariantsCompanion toCompanion(bool nullToAbsent) {
    return VariantsCompanion(
      id: Value(id),
      companyItemId: Value(companyItemId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      name: Value(name),
      defaultLocation: defaultLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultLocation),
      specJson: specJson == null && nullToAbsent
          ? const Value.absent()
          : Value(specJson),
      initializedAt: initializedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(initializedAt),
      initializedBy: initializedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(initializedBy),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory Variant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Variant(
      id: serializer.fromJson<String>(json['id']),
      companyItemId: serializer.fromJson<String>(json['companyItemId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      name: serializer.fromJson<String>(json['name']),
      defaultLocation: serializer.fromJson<String?>(json['defaultLocation']),
      specJson: serializer.fromJson<String?>(json['specJson']),
      initializedAt: serializer.fromJson<DateTime?>(json['initializedAt']),
      initializedBy: serializer.fromJson<String?>(json['initializedBy']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'companyItemId': serializer.toJson<String>(companyItemId),
      'brandId': serializer.toJson<String?>(brandId),
      'name': serializer.toJson<String>(name),
      'defaultLocation': serializer.toJson<String?>(defaultLocation),
      'specJson': serializer.toJson<String?>(specJson),
      'initializedAt': serializer.toJson<DateTime?>(initializedAt),
      'initializedBy': serializer.toJson<String?>(initializedBy),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Variant copyWith({
    String? id,
    String? companyItemId,
    Value<String?> brandId = const Value.absent(),
    String? name,
    Value<String?> defaultLocation = const Value.absent(),
    Value<String?> specJson = const Value.absent(),
    Value<DateTime?> initializedAt = const Value.absent(),
    Value<String?> initializedBy = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Variant(
    id: id ?? this.id,
    companyItemId: companyItemId ?? this.companyItemId,
    brandId: brandId.present ? brandId.value : this.brandId,
    name: name ?? this.name,
    defaultLocation: defaultLocation.present
        ? defaultLocation.value
        : this.defaultLocation,
    specJson: specJson.present ? specJson.value : this.specJson,
    initializedAt: initializedAt.present
        ? initializedAt.value
        : this.initializedAt,
    initializedBy: initializedBy.present
        ? initializedBy.value
        : this.initializedBy,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  Variant copyWithCompanion(VariantsCompanion data) {
    return Variant(
      id: data.id.present ? data.id.value : this.id,
      companyItemId: data.companyItemId.present
          ? data.companyItemId.value
          : this.companyItemId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      name: data.name.present ? data.name.value : this.name,
      defaultLocation: data.defaultLocation.present
          ? data.defaultLocation.value
          : this.defaultLocation,
      specJson: data.specJson.present ? data.specJson.value : this.specJson,
      initializedAt: data.initializedAt.present
          ? data.initializedAt.value
          : this.initializedAt,
      initializedBy: data.initializedBy.present
          ? data.initializedBy.value
          : this.initializedBy,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Variant(')
          ..write('id: $id, ')
          ..write('companyItemId: $companyItemId, ')
          ..write('brandId: $brandId, ')
          ..write('name: $name, ')
          ..write('defaultLocation: $defaultLocation, ')
          ..write('specJson: $specJson, ')
          ..write('initializedAt: $initializedAt, ')
          ..write('initializedBy: $initializedBy, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyItemId,
    brandId,
    name,
    defaultLocation,
    specJson,
    initializedAt,
    initializedBy,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant &&
          other.id == this.id &&
          other.companyItemId == this.companyItemId &&
          other.brandId == this.brandId &&
          other.name == this.name &&
          other.defaultLocation == this.defaultLocation &&
          other.specJson == this.specJson &&
          other.initializedAt == this.initializedAt &&
          other.initializedBy == this.initializedBy &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class VariantsCompanion extends UpdateCompanion<Variant> {
  final Value<String> id;
  final Value<String> companyItemId;
  final Value<String?> brandId;
  final Value<String> name;
  final Value<String?> defaultLocation;
  final Value<String?> specJson;
  final Value<DateTime?> initializedAt;
  final Value<String?> initializedBy;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const VariantsCompanion({
    this.id = const Value.absent(),
    this.companyItemId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultLocation = const Value.absent(),
    this.specJson = const Value.absent(),
    this.initializedAt = const Value.absent(),
    this.initializedBy = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VariantsCompanion.insert({
    required String id,
    required String companyItemId,
    this.brandId = const Value.absent(),
    required String name,
    this.defaultLocation = const Value.absent(),
    this.specJson = const Value.absent(),
    this.initializedAt = const Value.absent(),
    this.initializedBy = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required DateTime lastModifiedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       companyItemId = Value(companyItemId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastModifiedAt = Value(lastModifiedAt);
  static Insertable<Variant> custom({
    Expression<String>? id,
    Expression<String>? companyItemId,
    Expression<String>? brandId,
    Expression<String>? name,
    Expression<String>? defaultLocation,
    Expression<String>? specJson,
    Expression<DateTime>? initializedAt,
    Expression<String>? initializedBy,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyItemId != null) 'company_item_id': companyItemId,
      if (brandId != null) 'brand_id': brandId,
      if (name != null) 'name': name,
      if (defaultLocation != null) 'default_location': defaultLocation,
      if (specJson != null) 'spec_json': specJson,
      if (initializedAt != null) 'initialized_at': initializedAt,
      if (initializedBy != null) 'initialized_by': initializedBy,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VariantsCompanion copyWith({
    Value<String>? id,
    Value<String>? companyItemId,
    Value<String?>? brandId,
    Value<String>? name,
    Value<String?>? defaultLocation,
    Value<String?>? specJson,
    Value<DateTime?>? initializedAt,
    Value<String?>? initializedBy,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return VariantsCompanion(
      id: id ?? this.id,
      companyItemId: companyItemId ?? this.companyItemId,
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      defaultLocation: defaultLocation ?? this.defaultLocation,
      specJson: specJson ?? this.specJson,
      initializedAt: initializedAt ?? this.initializedAt,
      initializedBy: initializedBy ?? this.initializedBy,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (companyItemId.present) {
      map['company_item_id'] = Variable<String>(companyItemId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultLocation.present) {
      map['default_location'] = Variable<String>(defaultLocation.value);
    }
    if (specJson.present) {
      map['spec_json'] = Variable<String>(specJson.value);
    }
    if (initializedAt.present) {
      map['initialized_at'] = Variable<DateTime>(initializedAt.value);
    }
    if (initializedBy.present) {
      map['initialized_by'] = Variable<String>(initializedBy.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariantsCompanion(')
          ..write('id: $id, ')
          ..write('companyItemId: $companyItemId, ')
          ..write('brandId: $brandId, ')
          ..write('name: $name, ')
          ..write('defaultLocation: $defaultLocation, ')
          ..write('specJson: $specJson, ')
          ..write('initializedAt: $initializedAt, ')
          ..write('initializedBy: $initializedBy, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VariantPhotosTable extends VariantPhotos
    with TableInfo<$VariantPhotosTable, VariantPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariantPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
    'variant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteUrlMeta = const VerificationMeta(
    'remoteUrl',
  );
  @override
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
    'remote_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    variantId,
    localPath,
    remoteUrl,
    position,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variant_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<VariantPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VariantPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VariantPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $VariantPhotosTable createAlias(String alias) {
    return $VariantPhotosTable(attachedDatabase, alias);
  }
}

class VariantPhoto extends DataClass implements Insertable<VariantPhoto> {
  final String id;
  final String variantId;
  final String localPath;
  final String? remoteUrl;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const VariantPhoto({
    required this.id,
    required this.variantId,
    required this.localPath,
    this.remoteUrl,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['variant_id'] = Variable<String>(variantId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  VariantPhotosCompanion toCompanion(bool nullToAbsent) {
    return VariantPhotosCompanion(
      id: Value(id),
      variantId: Value(variantId),
      localPath: Value(localPath),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      position: Value(position),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory VariantPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VariantPhoto(
      id: serializer.fromJson<String>(json['id']),
      variantId: serializer.fromJson<String>(json['variantId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'variantId': serializer.toJson<String>(variantId),
      'localPath': serializer.toJson<String>(localPath),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  VariantPhoto copyWith({
    String? id,
    String? variantId,
    String? localPath,
    Value<String?> remoteUrl = const Value.absent(),
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => VariantPhoto(
    id: id ?? this.id,
    variantId: variantId ?? this.variantId,
    localPath: localPath ?? this.localPath,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  VariantPhoto copyWithCompanion(VariantPhotosCompanion data) {
    return VariantPhoto(
      id: data.id.present ? data.id.value : this.id,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VariantPhoto(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    variantId,
    localPath,
    remoteUrl,
    position,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VariantPhoto &&
          other.id == this.id &&
          other.variantId == this.variantId &&
          other.localPath == this.localPath &&
          other.remoteUrl == this.remoteUrl &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class VariantPhotosCompanion extends UpdateCompanion<VariantPhoto> {
  final Value<String> id;
  final Value<String> variantId;
  final Value<String> localPath;
  final Value<String?> remoteUrl;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const VariantPhotosCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VariantPhotosCompanion.insert({
    required String id,
    required String variantId,
    required String localPath,
    this.remoteUrl = const Value.absent(),
    this.position = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       variantId = Value(variantId),
       localPath = Value(localPath),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VariantPhoto> custom({
    Expression<String>? id,
    Expression<String>? variantId,
    Expression<String>? localPath,
    Expression<String>? remoteUrl,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variantId != null) 'variant_id': variantId,
      if (localPath != null) 'local_path': localPath,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VariantPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? variantId,
    Value<String>? localPath,
    Value<String?>? remoteUrl,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return VariantPhotosCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariantPhotosCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComponentsTable extends Components
    with TableInfo<$ComponentsTable, Component> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufCodeMeta = const VerificationMeta(
    'manufCode',
  );
  @override
  late final GeneratedColumn<String> manufCode = GeneratedColumn<String>(
    'manuf_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specJsonMeta = const VerificationMeta(
    'specJson',
  );
  @override
  late final GeneratedColumn<String> specJson = GeneratedColumn<String>(
    'spec_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    brandId,
    manufCode,
    specJson,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'components';
  @override
  VerificationContext validateIntegrity(
    Insertable<Component> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('manuf_code')) {
      context.handle(
        _manufCodeMeta,
        manufCode.isAcceptableOrUnknown(data['manuf_code']!, _manufCodeMeta),
      );
    }
    if (data.containsKey('spec_json')) {
      context.handle(
        _specJsonMeta,
        specJson.isAcceptableOrUnknown(data['spec_json']!, _specJsonMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Component map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Component(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      manufCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manuf_code'],
      ),
      specJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec_json'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $ComponentsTable createAlias(String alias) {
    return $ComponentsTable(attachedDatabase, alias);
  }
}

class Component extends DataClass implements Insertable<Component> {
  final String id;
  final String productId;
  final String name;
  final String? brandId;
  final String? manufCode;
  final String? specJson;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Component({
    required this.id,
    required this.productId,
    required this.name,
    this.brandId,
    this.manufCode,
    this.specJson,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || manufCode != null) {
      map['manuf_code'] = Variable<String>(manufCode);
    }
    if (!nullToAbsent || specJson != null) {
      map['spec_json'] = Variable<String>(specJson);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  ComponentsCompanion toCompanion(bool nullToAbsent) {
    return ComponentsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      manufCode: manufCode == null && nullToAbsent
          ? const Value.absent()
          : Value(manufCode),
      specJson: specJson == null && nullToAbsent
          ? const Value.absent()
          : Value(specJson),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory Component.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Component(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      manufCode: serializer.fromJson<String?>(json['manufCode']),
      specJson: serializer.fromJson<String?>(json['specJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'brandId': serializer.toJson<String?>(brandId),
      'manufCode': serializer.toJson<String?>(manufCode),
      'specJson': serializer.toJson<String?>(specJson),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Component copyWith({
    String? id,
    String? productId,
    String? name,
    Value<String?> brandId = const Value.absent(),
    Value<String?> manufCode = const Value.absent(),
    Value<String?> specJson = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Component(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    brandId: brandId.present ? brandId.value : this.brandId,
    manufCode: manufCode.present ? manufCode.value : this.manufCode,
    specJson: specJson.present ? specJson.value : this.specJson,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  Component copyWithCompanion(ComponentsCompanion data) {
    return Component(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      manufCode: data.manufCode.present ? data.manufCode.value : this.manufCode,
      specJson: data.specJson.present ? data.specJson.value : this.specJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Component(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('brandId: $brandId, ')
          ..write('manufCode: $manufCode, ')
          ..write('specJson: $specJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    name,
    brandId,
    manufCode,
    specJson,
    isActive,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Component &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.brandId == this.brandId &&
          other.manufCode == this.manufCode &&
          other.specJson == this.specJson &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class ComponentsCompanion extends UpdateCompanion<Component> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> brandId;
  final Value<String?> manufCode;
  final Value<String?> specJson;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const ComponentsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.brandId = const Value.absent(),
    this.manufCode = const Value.absent(),
    this.specJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComponentsCompanion.insert({
    required String id,
    required String productId,
    required String name,
    this.brandId = const Value.absent(),
    this.manufCode = const Value.absent(),
    this.specJson = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    required DateTime lastModifiedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastModifiedAt = Value(lastModifiedAt);
  static Insertable<Component> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? brandId,
    Expression<String>? manufCode,
    Expression<String>? specJson,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (brandId != null) 'brand_id': brandId,
      if (manufCode != null) 'manuf_code': manufCode,
      if (specJson != null) 'spec_json': specJson,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? name,
    Value<String?>? brandId,
    Value<String?>? manufCode,
    Value<String?>? specJson,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return ComponentsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brandId: brandId ?? this.brandId,
      manufCode: manufCode ?? this.manufCode,
      specJson: specJson ?? this.specJson,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (manufCode.present) {
      map['manuf_code'] = Variable<String>(manufCode.value);
    }
    if (specJson.present) {
      map['spec_json'] = Variable<String>(specJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('brandId: $brandId, ')
          ..write('manufCode: $manufCode, ')
          ..write('specJson: $specJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VariantComponentsTable extends VariantComponents
    with TableInfo<$VariantComponentsTable, VariantComponent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariantComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
    'variant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    variantId,
    componentId,
    quantity,
    createdAt,
    updatedAt,
    lastModifiedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variant_components';
  @override
  VerificationContext validateIntegrity(
    Insertable<VariantComponent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VariantComponent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VariantComponent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $VariantComponentsTable createAlias(String alias) {
    return $VariantComponentsTable(attachedDatabase, alias);
  }
}

class VariantComponent extends DataClass
    implements Insertable<VariantComponent> {
  final String id;
  final String variantId;
  final String componentId;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const VariantComponent({
    required this.id,
    required this.variantId,
    required this.componentId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.lastModifiedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['variant_id'] = Variable<String>(variantId);
    map['component_id'] = Variable<String>(componentId);
    map['quantity'] = Variable<int>(quantity);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  VariantComponentsCompanion toCompanion(bool nullToAbsent) {
    return VariantComponentsCompanion(
      id: Value(id),
      variantId: Value(variantId),
      componentId: Value(componentId),
      quantity: Value(quantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory VariantComponent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VariantComponent(
      id: serializer.fromJson<String>(json['id']),
      variantId: serializer.fromJson<String>(json['variantId']),
      componentId: serializer.fromJson<String>(json['componentId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'variantId': serializer.toJson<String>(variantId),
      'componentId': serializer.toJson<String>(componentId),
      'quantity': serializer.toJson<int>(quantity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  VariantComponent copyWith({
    String? id,
    String? variantId,
    String? componentId,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => VariantComponent(
    id: id ?? this.id,
    variantId: variantId ?? this.variantId,
    componentId: componentId ?? this.componentId,
    quantity: quantity ?? this.quantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  VariantComponent copyWithCompanion(VariantComponentsCompanion data) {
    return VariantComponent(
      id: data.id.present ? data.id.value : this.id,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VariantComponent(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('quantity: $quantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    variantId,
    componentId,
    quantity,
    createdAt,
    updatedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VariantComponent &&
          other.id == this.id &&
          other.variantId == this.variantId &&
          other.componentId == this.componentId &&
          other.quantity == this.quantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class VariantComponentsCompanion extends UpdateCompanion<VariantComponent> {
  final Value<String> id;
  final Value<String> variantId;
  final Value<String> componentId;
  final Value<int> quantity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const VariantComponentsCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VariantComponentsCompanion.insert({
    required String id,
    required String variantId,
    required String componentId,
    this.quantity = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime lastModifiedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       variantId = Value(variantId),
       componentId = Value(componentId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastModifiedAt = Value(lastModifiedAt);
  static Insertable<VariantComponent> custom({
    Expression<String>? id,
    Expression<String>? variantId,
    Expression<String>? componentId,
    Expression<int>? quantity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variantId != null) 'variant_id': variantId,
      if (componentId != null) 'component_id': componentId,
      if (quantity != null) 'quantity': quantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VariantComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? variantId,
    Value<String>? componentId,
    Value<int>? quantity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return VariantComponentsCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      componentId: componentId ?? this.componentId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariantComponentsCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('quantity: $quantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BufferStocksTable extends BufferStocks
    with TableInfo<$BufferStocksTable, BufferStock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BufferStocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyItemIdMeta = const VerificationMeta(
    'companyItemId',
  );
  @override
  late final GeneratedColumn<String> companyItemId = GeneratedColumn<String>(
    'company_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minQuantityMeta = const VerificationMeta(
    'minQuantity',
  );
  @override
  late final GeneratedColumn<int> minQuantity = GeneratedColumn<int>(
    'min_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyItemId,
    brandId,
    location,
    minQuantity,
    createdAt,
    updatedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buffer_stocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BufferStock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('company_item_id')) {
      context.handle(
        _companyItemIdMeta,
        companyItemId.isAcceptableOrUnknown(
          data['company_item_id']!,
          _companyItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyItemIdMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('min_quantity')) {
      context.handle(
        _minQuantityMeta,
        minQuantity.isAcceptableOrUnknown(
          data['min_quantity']!,
          _minQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minQuantityMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BufferStock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BufferStock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      companyItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_item_id'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      minQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_quantity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $BufferStocksTable createAlias(String alias) {
    return $BufferStocksTable(attachedDatabase, alias);
  }
}

class BufferStock extends DataClass implements Insertable<BufferStock> {
  final String id;
  final String companyItemId;
  final String? brandId;
  final String? location;
  final int minQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool needSync;
  const BufferStock({
    required this.id,
    required this.companyItemId,
    this.brandId,
    this.location,
    required this.minQuantity,
    required this.createdAt,
    required this.updatedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['company_item_id'] = Variable<String>(companyItemId);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['min_quantity'] = Variable<int>(minQuantity);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  BufferStocksCompanion toCompanion(bool nullToAbsent) {
    return BufferStocksCompanion(
      id: Value(id),
      companyItemId: Value(companyItemId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      minQuantity: Value(minQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      needSync: Value(needSync),
    );
  }

  factory BufferStock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BufferStock(
      id: serializer.fromJson<String>(json['id']),
      companyItemId: serializer.fromJson<String>(json['companyItemId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      location: serializer.fromJson<String?>(json['location']),
      minQuantity: serializer.fromJson<int>(json['minQuantity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'companyItemId': serializer.toJson<String>(companyItemId),
      'brandId': serializer.toJson<String?>(brandId),
      'location': serializer.toJson<String?>(location),
      'minQuantity': serializer.toJson<int>(minQuantity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  BufferStock copyWith({
    String? id,
    String? companyItemId,
    Value<String?> brandId = const Value.absent(),
    Value<String?> location = const Value.absent(),
    int? minQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? needSync,
  }) => BufferStock(
    id: id ?? this.id,
    companyItemId: companyItemId ?? this.companyItemId,
    brandId: brandId.present ? brandId.value : this.brandId,
    location: location.present ? location.value : this.location,
    minQuantity: minQuantity ?? this.minQuantity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    needSync: needSync ?? this.needSync,
  );
  BufferStock copyWithCompanion(BufferStocksCompanion data) {
    return BufferStock(
      id: data.id.present ? data.id.value : this.id,
      companyItemId: data.companyItemId.present
          ? data.companyItemId.value
          : this.companyItemId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      location: data.location.present ? data.location.value : this.location,
      minQuantity: data.minQuantity.present
          ? data.minQuantity.value
          : this.minQuantity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BufferStock(')
          ..write('id: $id, ')
          ..write('companyItemId: $companyItemId, ')
          ..write('brandId: $brandId, ')
          ..write('location: $location, ')
          ..write('minQuantity: $minQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyItemId,
    brandId,
    location,
    minQuantity,
    createdAt,
    updatedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BufferStock &&
          other.id == this.id &&
          other.companyItemId == this.companyItemId &&
          other.brandId == this.brandId &&
          other.location == this.location &&
          other.minQuantity == this.minQuantity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.needSync == this.needSync);
}

class BufferStocksCompanion extends UpdateCompanion<BufferStock> {
  final Value<String> id;
  final Value<String> companyItemId;
  final Value<String?> brandId;
  final Value<String?> location;
  final Value<int> minQuantity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const BufferStocksCompanion({
    this.id = const Value.absent(),
    this.companyItemId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.location = const Value.absent(),
    this.minQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BufferStocksCompanion.insert({
    required String id,
    required String companyItemId,
    this.brandId = const Value.absent(),
    this.location = const Value.absent(),
    required int minQuantity,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       companyItemId = Value(companyItemId),
       minQuantity = Value(minQuantity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BufferStock> custom({
    Expression<String>? id,
    Expression<String>? companyItemId,
    Expression<String>? brandId,
    Expression<String>? location,
    Expression<int>? minQuantity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyItemId != null) 'company_item_id': companyItemId,
      if (brandId != null) 'brand_id': brandId,
      if (location != null) 'location': location,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BufferStocksCompanion copyWith({
    Value<String>? id,
    Value<String>? companyItemId,
    Value<String?>? brandId,
    Value<String?>? location,
    Value<int>? minQuantity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return BufferStocksCompanion(
      id: id ?? this.id,
      companyItemId: companyItemId ?? this.companyItemId,
      brandId: brandId ?? this.brandId,
      location: location ?? this.location,
      minQuantity: minQuantity ?? this.minQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (companyItemId.present) {
      map['company_item_id'] = Variable<String>(companyItemId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (minQuantity.present) {
      map['min_quantity'] = Variable<int>(minQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BufferStocksCompanion(')
          ..write('id: $id, ')
          ..write('companyItemId: $companyItemId, ')
          ..write('brandId: $brandId, ')
          ..write('location: $location, ')
          ..write('minQuantity: $minQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentUnitIdMeta = const VerificationMeta(
    'parentUnitId',
  );
  @override
  late final GeneratedColumn<String> parentUnitId = GeneratedColumn<String>(
    'parent_unit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qrValueMeta = const VerificationMeta(
    'qrValue',
  );
  @override
  late final GeneratedColumn<String> qrValue = GeneratedColumn<String>(
    'qr_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printCountMeta = const VerificationMeta(
    'printCount',
  );
  @override
  late final GeneratedColumn<int> printCount = GeneratedColumn<int>(
    'print_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPrintedAtMeta = const VerificationMeta(
    'lastPrintedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPrintedAt =
      GeneratedColumn<DateTime>(
        'last_printed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPrintedByMeta = const VerificationMeta(
    'lastPrintedBy',
  );
  @override
  late final GeneratedColumn<String> lastPrintedBy = GeneratedColumn<String>(
    'last_printed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedAtMeta = const VerificationMeta(
    'lastModifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastModifiedAt =
      GeneratedColumn<DateTime>(
        'last_modified_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needSyncMeta = const VerificationMeta(
    'needSync',
  );
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
    'need_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    variantId,
    componentId,
    parentUnitId,
    qrValue,
    status,
    location,
    printCount,
    lastPrintedAt,
    createdBy,
    updatedBy,
    lastPrintedBy,
    syncedAt,
    lastModifiedAt,
    createdAt,
    updatedAt,
    deletedAt,
    needSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    }
    if (data.containsKey('parent_unit_id')) {
      context.handle(
        _parentUnitIdMeta,
        parentUnitId.isAcceptableOrUnknown(
          data['parent_unit_id']!,
          _parentUnitIdMeta,
        ),
      );
    }
    if (data.containsKey('qr_value')) {
      context.handle(
        _qrValueMeta,
        qrValue.isAcceptableOrUnknown(data['qr_value']!, _qrValueMeta),
      );
    } else if (isInserting) {
      context.missing(_qrValueMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('print_count')) {
      context.handle(
        _printCountMeta,
        printCount.isAcceptableOrUnknown(data['print_count']!, _printCountMeta),
      );
    }
    if (data.containsKey('last_printed_at')) {
      context.handle(
        _lastPrintedAtMeta,
        lastPrintedAt.isAcceptableOrUnknown(
          data['last_printed_at']!,
          _lastPrintedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('last_printed_by')) {
      context.handle(
        _lastPrintedByMeta,
        lastPrintedBy.isAcceptableOrUnknown(
          data['last_printed_by']!,
          _lastPrintedByMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('last_modified_at')) {
      context.handle(
        _lastModifiedAtMeta,
        lastModifiedAt.isAcceptableOrUnknown(
          data['last_modified_at']!,
          _lastModifiedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('need_sync')) {
      context.handle(
        _needSyncMeta,
        needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_id'],
      ),
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      ),
      parentUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_unit_id'],
      ),
      qrValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_value'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      printCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}print_count'],
      )!,
      lastPrintedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_printed_at'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      lastPrintedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_printed_by'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      lastModifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      needSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_sync'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final String? variantId;
  final String? componentId;
  final String? parentUnitId;
  final String qrValue;
  final String status;
  final String? location;
  final int printCount;
  final DateTime? lastPrintedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? lastPrintedBy;
  final DateTime? syncedAt;
  final DateTime lastModifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool needSync;
  const Unit({
    required this.id,
    this.variantId,
    this.componentId,
    this.parentUnitId,
    required this.qrValue,
    required this.status,
    this.location,
    required this.printCount,
    this.lastPrintedAt,
    this.createdBy,
    this.updatedBy,
    this.lastPrintedBy,
    this.syncedAt,
    required this.lastModifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.needSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    if (!nullToAbsent || componentId != null) {
      map['component_id'] = Variable<String>(componentId);
    }
    if (!nullToAbsent || parentUnitId != null) {
      map['parent_unit_id'] = Variable<String>(parentUnitId);
    }
    map['qr_value'] = Variable<String>(qrValue);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['print_count'] = Variable<int>(printCount);
    if (!nullToAbsent || lastPrintedAt != null) {
      map['last_printed_at'] = Variable<DateTime>(lastPrintedAt);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    if (!nullToAbsent || lastPrintedBy != null) {
      map['last_printed_by'] = Variable<String>(lastPrintedBy);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      componentId: componentId == null && nullToAbsent
          ? const Value.absent()
          : Value(componentId),
      parentUnitId: parentUnitId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentUnitId),
      qrValue: Value(qrValue),
      status: Value(status),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      printCount: Value(printCount),
      lastPrintedAt: lastPrintedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPrintedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      lastPrintedBy: lastPrintedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPrintedBy),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      lastModifiedAt: Value(lastModifiedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      needSync: Value(needSync),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<String>(json['id']),
      variantId: serializer.fromJson<String?>(json['variantId']),
      componentId: serializer.fromJson<String?>(json['componentId']),
      parentUnitId: serializer.fromJson<String?>(json['parentUnitId']),
      qrValue: serializer.fromJson<String>(json['qrValue']),
      status: serializer.fromJson<String>(json['status']),
      location: serializer.fromJson<String?>(json['location']),
      printCount: serializer.fromJson<int>(json['printCount']),
      lastPrintedAt: serializer.fromJson<DateTime?>(json['lastPrintedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      lastPrintedBy: serializer.fromJson<String?>(json['lastPrintedBy']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      lastModifiedAt: serializer.fromJson<DateTime>(json['lastModifiedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      needSync: serializer.fromJson<bool>(json['needSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'variantId': serializer.toJson<String?>(variantId),
      'componentId': serializer.toJson<String?>(componentId),
      'parentUnitId': serializer.toJson<String?>(parentUnitId),
      'qrValue': serializer.toJson<String>(qrValue),
      'status': serializer.toJson<String>(status),
      'location': serializer.toJson<String?>(location),
      'printCount': serializer.toJson<int>(printCount),
      'lastPrintedAt': serializer.toJson<DateTime?>(lastPrintedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'lastPrintedBy': serializer.toJson<String?>(lastPrintedBy),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Unit copyWith({
    String? id,
    Value<String?> variantId = const Value.absent(),
    Value<String?> componentId = const Value.absent(),
    Value<String?> parentUnitId = const Value.absent(),
    String? qrValue,
    String? status,
    Value<String?> location = const Value.absent(),
    int? printCount,
    Value<DateTime?> lastPrintedAt = const Value.absent(),
    Value<String?> createdBy = const Value.absent(),
    Value<String?> updatedBy = const Value.absent(),
    Value<String?> lastPrintedBy = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? needSync,
  }) => Unit(
    id: id ?? this.id,
    variantId: variantId.present ? variantId.value : this.variantId,
    componentId: componentId.present ? componentId.value : this.componentId,
    parentUnitId: parentUnitId.present ? parentUnitId.value : this.parentUnitId,
    qrValue: qrValue ?? this.qrValue,
    status: status ?? this.status,
    location: location.present ? location.value : this.location,
    printCount: printCount ?? this.printCount,
    lastPrintedAt: lastPrintedAt.present
        ? lastPrintedAt.value
        : this.lastPrintedAt,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    lastPrintedBy: lastPrintedBy.present
        ? lastPrintedBy.value
        : this.lastPrintedBy,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    needSync: needSync ?? this.needSync,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      parentUnitId: data.parentUnitId.present
          ? data.parentUnitId.value
          : this.parentUnitId,
      qrValue: data.qrValue.present ? data.qrValue.value : this.qrValue,
      status: data.status.present ? data.status.value : this.status,
      location: data.location.present ? data.location.value : this.location,
      printCount: data.printCount.present
          ? data.printCount.value
          : this.printCount,
      lastPrintedAt: data.lastPrintedAt.present
          ? data.lastPrintedAt.value
          : this.lastPrintedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      lastPrintedBy: data.lastPrintedBy.present
          ? data.lastPrintedBy.value
          : this.lastPrintedBy,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      lastModifiedAt: data.lastModifiedAt.present
          ? data.lastModifiedAt.value
          : this.lastModifiedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      needSync: data.needSync.present ? data.needSync.value : this.needSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('parentUnitId: $parentUnitId, ')
          ..write('qrValue: $qrValue, ')
          ..write('status: $status, ')
          ..write('location: $location, ')
          ..write('printCount: $printCount, ')
          ..write('lastPrintedAt: $lastPrintedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('lastPrintedBy: $lastPrintedBy, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needSync: $needSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    variantId,
    componentId,
    parentUnitId,
    qrValue,
    status,
    location,
    printCount,
    lastPrintedAt,
    createdBy,
    updatedBy,
    lastPrintedBy,
    syncedAt,
    lastModifiedAt,
    createdAt,
    updatedAt,
    deletedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.variantId == this.variantId &&
          other.componentId == this.componentId &&
          other.parentUnitId == this.parentUnitId &&
          other.qrValue == this.qrValue &&
          other.status == this.status &&
          other.location == this.location &&
          other.printCount == this.printCount &&
          other.lastPrintedAt == this.lastPrintedAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.lastPrintedBy == this.lastPrintedBy &&
          other.syncedAt == this.syncedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.needSync == this.needSync);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<String?> variantId;
  final Value<String?> componentId;
  final Value<String?> parentUnitId;
  final Value<String> qrValue;
  final Value<String> status;
  final Value<String?> location;
  final Value<int> printCount;
  final Value<DateTime?> lastPrintedAt;
  final Value<String?> createdBy;
  final Value<String?> updatedBy;
  final Value<String?> lastPrintedBy;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.parentUnitId = const Value.absent(),
    this.qrValue = const Value.absent(),
    this.status = const Value.absent(),
    this.location = const Value.absent(),
    this.printCount = const Value.absent(),
    this.lastPrintedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.lastPrintedBy = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    this.variantId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.parentUnitId = const Value.absent(),
    required String qrValue,
    this.status = const Value.absent(),
    this.location = const Value.absent(),
    this.printCount = const Value.absent(),
    this.lastPrintedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.lastPrintedBy = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime lastModifiedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       qrValue = Value(qrValue),
       lastModifiedAt = Value(lastModifiedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<String>? variantId,
    Expression<String>? componentId,
    Expression<String>? parentUnitId,
    Expression<String>? qrValue,
    Expression<String>? status,
    Expression<String>? location,
    Expression<int>? printCount,
    Expression<DateTime>? lastPrintedAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? lastPrintedBy,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variantId != null) 'variant_id': variantId,
      if (componentId != null) 'component_id': componentId,
      if (parentUnitId != null) 'parent_unit_id': parentUnitId,
      if (qrValue != null) 'qr_value': qrValue,
      if (status != null) 'status': status,
      if (location != null) 'location': location,
      if (printCount != null) 'print_count': printCount,
      if (lastPrintedAt != null) 'last_printed_at': lastPrintedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (lastPrintedBy != null) 'last_printed_by': lastPrintedBy,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith({
    Value<String>? id,
    Value<String?>? variantId,
    Value<String?>? componentId,
    Value<String?>? parentUnitId,
    Value<String>? qrValue,
    Value<String>? status,
    Value<String?>? location,
    Value<int>? printCount,
    Value<DateTime?>? lastPrintedAt,
    Value<String?>? createdBy,
    Value<String?>? updatedBy,
    Value<String?>? lastPrintedBy,
    Value<DateTime?>? syncedAt,
    Value<DateTime>? lastModifiedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      componentId: componentId ?? this.componentId,
      parentUnitId: parentUnitId ?? this.parentUnitId,
      qrValue: qrValue ?? this.qrValue,
      status: status ?? this.status,
      location: location ?? this.location,
      printCount: printCount ?? this.printCount,
      lastPrintedAt: lastPrintedAt ?? this.lastPrintedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      lastPrintedBy: lastPrintedBy ?? this.lastPrintedBy,
      syncedAt: syncedAt ?? this.syncedAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      needSync: needSync ?? this.needSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (parentUnitId.present) {
      map['parent_unit_id'] = Variable<String>(parentUnitId.value);
    }
    if (qrValue.present) {
      map['qr_value'] = Variable<String>(qrValue.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (printCount.present) {
      map['print_count'] = Variable<int>(printCount.value);
    }
    if (lastPrintedAt.present) {
      map['last_printed_at'] = Variable<DateTime>(lastPrintedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (lastPrintedBy.present) {
      map['last_printed_by'] = Variable<String>(lastPrintedBy.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (lastModifiedAt.present) {
      map['last_modified_at'] = Variable<DateTime>(lastModifiedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (needSync.present) {
      map['need_sync'] = Variable<bool>(needSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('parentUnitId: $parentUnitId, ')
          ..write('qrValue: $qrValue, ')
          ..write('status: $status, ')
          ..write('location: $location, ')
          ..write('printCount: $printCount, ')
          ..write('lastPrintedAt: $lastPrintedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('lastPrintedBy: $lastPrintedBy, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('lastModifiedAt: $lastModifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('needSync: $needSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String key;
  final String value;
  const SyncMetadataData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetadataData copyWith({String? key, String? value}) =>
      SyncMetadataData(key: key ?? this.key, value: value ?? this.value);
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CompanyItemsTable companyItems = $CompanyItemsTable(this);
  late final $VariantsTable variants = $VariantsTable(this);
  late final $VariantPhotosTable variantPhotos = $VariantPhotosTable(this);
  late final $ComponentsTable components = $ComponentsTable(this);
  late final $VariantComponentsTable variantComponents =
      $VariantComponentsTable(this);
  late final $BufferStocksTable bufferStocks = $BufferStocksTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final BrandDao brandDao = BrandDao(this as AppDatabase);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  late final CompanyItemDao companyItemDao = CompanyItemDao(
    this as AppDatabase,
  );
  late final VariantDao variantDao = VariantDao(this as AppDatabase);
  late final VariantPhotoDao variantPhotoDao = VariantPhotoDao(
    this as AppDatabase,
  );
  late final ComponentDao componentDao = ComponentDao(this as AppDatabase);
  late final VariantComponentDao variantComponentDao = VariantComponentDao(
    this as AppDatabase,
  );
  late final UnitDao unitDao = UnitDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    brands,
    products,
    companyItems,
    variants,
    variantPhotos,
    components,
    variantComponents,
    bufferStocks,
    units,
    syncMetadata,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) =>
                  CategoriesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$BrandsTableCreateCompanionBuilder =
    BrandsCompanion Function({
      required String id,
      required String name,
      required DateTime lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$BrandsTableUpdateCompanionBuilder =
    BrandsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$BrandsTableFilterComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrandsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$BrandsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrandsTable,
          Brand,
          $$BrandsTableFilterComposer,
          $$BrandsTableOrderingComposer,
          $$BrandsTableAnnotationComposer,
          $$BrandsTableCreateCompanionBuilder,
          $$BrandsTableUpdateCompanionBuilder,
          (Brand, BaseReferences<_$AppDatabase, $BrandsTable, Brand>),
          Brand,
          PrefetchHooks Function()
        > {
  $$BrandsTableTableManager(_$AppDatabase db, $BrandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandsCompanion(
                id: id,
                name: name,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime lastModifiedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandsCompanion.insert(
                id: id,
                name: name,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrandsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrandsTable,
      Brand,
      $$BrandsTableFilterComposer,
      $$BrandsTableOrderingComposer,
      $$BrandsTableAnnotationComposer,
      $$BrandsTableCreateCompanionBuilder,
      $$BrandsTableUpdateCompanionBuilder,
      (Brand, BaseReferences<_$AppDatabase, $BrandsTable, Brand>),
      Brand,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required String categoryId,
      Value<String?> description,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> categoryId,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String categoryId,
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime lastModifiedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$CompanyItemsTableCreateCompanionBuilder =
    CompanyItemsCompanion Function({
      required String id,
      required String productId,
      required String companyCode,
      Value<bool?> isSet,
      Value<bool?> hasComponents,
      Value<DateTime?> initializedAt,
      Value<String?> initializedBy,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required DateTime lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$CompanyItemsTableUpdateCompanionBuilder =
    CompanyItemsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> companyCode,
      Value<bool?> isSet,
      Value<bool?> hasComponents,
      Value<DateTime?> initializedAt,
      Value<String?> initializedBy,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$CompanyItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CompanyItemsTable> {
  $$CompanyItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSet => $composableBuilder(
    column: $table.isSet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasComponents => $composableBuilder(
    column: $table.hasComponents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get initializedAt => $composableBuilder(
    column: $table.initializedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initializedBy => $composableBuilder(
    column: $table.initializedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompanyItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanyItemsTable> {
  $$CompanyItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSet => $composableBuilder(
    column: $table.isSet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasComponents => $composableBuilder(
    column: $table.hasComponents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get initializedAt => $composableBuilder(
    column: $table.initializedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initializedBy => $composableBuilder(
    column: $table.initializedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompanyItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanyItemsTable> {
  $$CompanyItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSet =>
      $composableBuilder(column: $table.isSet, builder: (column) => column);

  GeneratedColumn<bool> get hasComponents => $composableBuilder(
    column: $table.hasComponents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get initializedAt => $composableBuilder(
    column: $table.initializedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initializedBy => $composableBuilder(
    column: $table.initializedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$CompanyItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompanyItemsTable,
          CompanyItem,
          $$CompanyItemsTableFilterComposer,
          $$CompanyItemsTableOrderingComposer,
          $$CompanyItemsTableAnnotationComposer,
          $$CompanyItemsTableCreateCompanionBuilder,
          $$CompanyItemsTableUpdateCompanionBuilder,
          (
            CompanyItem,
            BaseReferences<_$AppDatabase, $CompanyItemsTable, CompanyItem>,
          ),
          CompanyItem,
          PrefetchHooks Function()
        > {
  $$CompanyItemsTableTableManager(_$AppDatabase db, $CompanyItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanyItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanyItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompanyItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> companyCode = const Value.absent(),
                Value<bool?> isSet = const Value.absent(),
                Value<bool?> hasComponents = const Value.absent(),
                Value<DateTime?> initializedAt = const Value.absent(),
                Value<String?> initializedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompanyItemsCompanion(
                id: id,
                productId: productId,
                companyCode: companyCode,
                isSet: isSet,
                hasComponents: hasComponents,
                initializedAt: initializedAt,
                initializedBy: initializedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String companyCode,
                Value<bool?> isSet = const Value.absent(),
                Value<bool?> hasComponents = const Value.absent(),
                Value<DateTime?> initializedAt = const Value.absent(),
                Value<String?> initializedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime lastModifiedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompanyItemsCompanion.insert(
                id: id,
                productId: productId,
                companyCode: companyCode,
                isSet: isSet,
                hasComponents: hasComponents,
                initializedAt: initializedAt,
                initializedBy: initializedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompanyItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompanyItemsTable,
      CompanyItem,
      $$CompanyItemsTableFilterComposer,
      $$CompanyItemsTableOrderingComposer,
      $$CompanyItemsTableAnnotationComposer,
      $$CompanyItemsTableCreateCompanionBuilder,
      $$CompanyItemsTableUpdateCompanionBuilder,
      (
        CompanyItem,
        BaseReferences<_$AppDatabase, $CompanyItemsTable, CompanyItem>,
      ),
      CompanyItem,
      PrefetchHooks Function()
    >;
typedef $$VariantsTableCreateCompanionBuilder =
    VariantsCompanion Function({
      required String id,
      required String companyItemId,
      Value<String?> brandId,
      required String name,
      Value<String?> defaultLocation,
      Value<String?> specJson,
      Value<DateTime?> initializedAt,
      Value<String?> initializedBy,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required DateTime lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$VariantsTableUpdateCompanionBuilder =
    VariantsCompanion Function({
      Value<String> id,
      Value<String> companyItemId,
      Value<String?> brandId,
      Value<String> name,
      Value<String?> defaultLocation,
      Value<String?> specJson,
      Value<DateTime?> initializedAt,
      Value<String?> initializedBy,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$VariantsTableFilterComposer
    extends Composer<_$AppDatabase, $VariantsTable> {
  $$VariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultLocation => $composableBuilder(
    column: $table.defaultLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specJson => $composableBuilder(
    column: $table.specJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get initializedAt => $composableBuilder(
    column: $table.initializedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initializedBy => $composableBuilder(
    column: $table.initializedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VariantsTableOrderingComposer
    extends Composer<_$AppDatabase, $VariantsTable> {
  $$VariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultLocation => $composableBuilder(
    column: $table.defaultLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specJson => $composableBuilder(
    column: $table.specJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get initializedAt => $composableBuilder(
    column: $table.initializedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initializedBy => $composableBuilder(
    column: $table.initializedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VariantsTable> {
  $$VariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get defaultLocation => $composableBuilder(
    column: $table.defaultLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specJson =>
      $composableBuilder(column: $table.specJson, builder: (column) => column);

  GeneratedColumn<DateTime> get initializedAt => $composableBuilder(
    column: $table.initializedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initializedBy => $composableBuilder(
    column: $table.initializedBy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$VariantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VariantsTable,
          Variant,
          $$VariantsTableFilterComposer,
          $$VariantsTableOrderingComposer,
          $$VariantsTableAnnotationComposer,
          $$VariantsTableCreateCompanionBuilder,
          $$VariantsTableUpdateCompanionBuilder,
          (Variant, BaseReferences<_$AppDatabase, $VariantsTable, Variant>),
          Variant,
          PrefetchHooks Function()
        > {
  $$VariantsTableTableManager(_$AppDatabase db, $VariantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> companyItemId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> defaultLocation = const Value.absent(),
                Value<String?> specJson = const Value.absent(),
                Value<DateTime?> initializedAt = const Value.absent(),
                Value<String?> initializedBy = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantsCompanion(
                id: id,
                companyItemId: companyItemId,
                brandId: brandId,
                name: name,
                defaultLocation: defaultLocation,
                specJson: specJson,
                initializedAt: initializedAt,
                initializedBy: initializedBy,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String companyItemId,
                Value<String?> brandId = const Value.absent(),
                required String name,
                Value<String?> defaultLocation = const Value.absent(),
                Value<String?> specJson = const Value.absent(),
                Value<DateTime?> initializedAt = const Value.absent(),
                Value<String?> initializedBy = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime lastModifiedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantsCompanion.insert(
                id: id,
                companyItemId: companyItemId,
                brandId: brandId,
                name: name,
                defaultLocation: defaultLocation,
                specJson: specJson,
                initializedAt: initializedAt,
                initializedBy: initializedBy,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VariantsTable,
      Variant,
      $$VariantsTableFilterComposer,
      $$VariantsTableOrderingComposer,
      $$VariantsTableAnnotationComposer,
      $$VariantsTableCreateCompanionBuilder,
      $$VariantsTableUpdateCompanionBuilder,
      (Variant, BaseReferences<_$AppDatabase, $VariantsTable, Variant>),
      Variant,
      PrefetchHooks Function()
    >;
typedef $$VariantPhotosTableCreateCompanionBuilder =
    VariantPhotosCompanion Function({
      required String id,
      required String variantId,
      required String localPath,
      Value<String?> remoteUrl,
      Value<int> position,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$VariantPhotosTableUpdateCompanionBuilder =
    VariantPhotosCompanion Function({
      Value<String> id,
      Value<String> variantId,
      Value<String> localPath,
      Value<String?> remoteUrl,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$VariantPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $VariantPhotosTable> {
  $$VariantPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VariantPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $VariantPhotosTable> {
  $$VariantPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteUrl => $composableBuilder(
    column: $table.remoteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VariantPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $VariantPhotosTable> {
  $$VariantPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variantId =>
      $composableBuilder(column: $table.variantId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$VariantPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VariantPhotosTable,
          VariantPhoto,
          $$VariantPhotosTableFilterComposer,
          $$VariantPhotosTableOrderingComposer,
          $$VariantPhotosTableAnnotationComposer,
          $$VariantPhotosTableCreateCompanionBuilder,
          $$VariantPhotosTableUpdateCompanionBuilder,
          (
            VariantPhoto,
            BaseReferences<_$AppDatabase, $VariantPhotosTable, VariantPhoto>,
          ),
          VariantPhoto,
          PrefetchHooks Function()
        > {
  $$VariantPhotosTableTableManager(_$AppDatabase db, $VariantPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VariantPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VariantPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VariantPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> variantId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantPhotosCompanion(
                id: id,
                variantId: variantId,
                localPath: localPath,
                remoteUrl: remoteUrl,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String variantId,
                required String localPath,
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> position = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantPhotosCompanion.insert(
                id: id,
                variantId: variantId,
                localPath: localPath,
                remoteUrl: remoteUrl,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VariantPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VariantPhotosTable,
      VariantPhoto,
      $$VariantPhotosTableFilterComposer,
      $$VariantPhotosTableOrderingComposer,
      $$VariantPhotosTableAnnotationComposer,
      $$VariantPhotosTableCreateCompanionBuilder,
      $$VariantPhotosTableUpdateCompanionBuilder,
      (
        VariantPhoto,
        BaseReferences<_$AppDatabase, $VariantPhotosTable, VariantPhoto>,
      ),
      VariantPhoto,
      PrefetchHooks Function()
    >;
typedef $$ComponentsTableCreateCompanionBuilder =
    ComponentsCompanion Function({
      required String id,
      required String productId,
      required String name,
      Value<String?> brandId,
      Value<String?> manufCode,
      Value<String?> specJson,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      required DateTime lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$ComponentsTableUpdateCompanionBuilder =
    ComponentsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> name,
      Value<String?> brandId,
      Value<String?> manufCode,
      Value<String?> specJson,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$ComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufCode => $composableBuilder(
    column: $table.manufCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specJson => $composableBuilder(
    column: $table.specJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufCode => $composableBuilder(
    column: $table.manufCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specJson => $composableBuilder(
    column: $table.specJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get manufCode =>
      $composableBuilder(column: $table.manufCode, builder: (column) => column);

  GeneratedColumn<String> get specJson =>
      $composableBuilder(column: $table.specJson, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$ComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComponentsTable,
          Component,
          $$ComponentsTableFilterComposer,
          $$ComponentsTableOrderingComposer,
          $$ComponentsTableAnnotationComposer,
          $$ComponentsTableCreateCompanionBuilder,
          $$ComponentsTableUpdateCompanionBuilder,
          (
            Component,
            BaseReferences<_$AppDatabase, $ComponentsTable, Component>,
          ),
          Component,
          PrefetchHooks Function()
        > {
  $$ComponentsTableTableManager(_$AppDatabase db, $ComponentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> manufCode = const Value.absent(),
                Value<String?> specJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion(
                id: id,
                productId: productId,
                name: name,
                brandId: brandId,
                manufCode: manufCode,
                specJson: specJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String name,
                Value<String?> brandId = const Value.absent(),
                Value<String?> manufCode = const Value.absent(),
                Value<String?> specJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime lastModifiedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                brandId: brandId,
                manufCode: manufCode,
                specJson: specJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComponentsTable,
      Component,
      $$ComponentsTableFilterComposer,
      $$ComponentsTableOrderingComposer,
      $$ComponentsTableAnnotationComposer,
      $$ComponentsTableCreateCompanionBuilder,
      $$ComponentsTableUpdateCompanionBuilder,
      (Component, BaseReferences<_$AppDatabase, $ComponentsTable, Component>),
      Component,
      PrefetchHooks Function()
    >;
typedef $$VariantComponentsTableCreateCompanionBuilder =
    VariantComponentsCompanion Function({
      required String id,
      required String variantId,
      required String componentId,
      Value<int> quantity,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$VariantComponentsTableUpdateCompanionBuilder =
    VariantComponentsCompanion Function({
      Value<String> id,
      Value<String> variantId,
      Value<String> componentId,
      Value<int> quantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$VariantComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $VariantComponentsTable> {
  $$VariantComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
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

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VariantComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $VariantComponentsTable> {
  $$VariantComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
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

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VariantComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VariantComponentsTable> {
  $$VariantComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variantId =>
      $composableBuilder(column: $table.variantId, builder: (column) => column);

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$VariantComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VariantComponentsTable,
          VariantComponent,
          $$VariantComponentsTableFilterComposer,
          $$VariantComponentsTableOrderingComposer,
          $$VariantComponentsTableAnnotationComposer,
          $$VariantComponentsTableCreateCompanionBuilder,
          $$VariantComponentsTableUpdateCompanionBuilder,
          (
            VariantComponent,
            BaseReferences<
              _$AppDatabase,
              $VariantComponentsTable,
              VariantComponent
            >,
          ),
          VariantComponent,
          PrefetchHooks Function()
        > {
  $$VariantComponentsTableTableManager(
    _$AppDatabase db,
    $VariantComponentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VariantComponentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VariantComponentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VariantComponentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> variantId = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantComponentsCompanion(
                id: id,
                variantId: variantId,
                componentId: componentId,
                quantity: quantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String variantId,
                required String componentId,
                Value<int> quantity = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime lastModifiedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantComponentsCompanion.insert(
                id: id,
                variantId: variantId,
                componentId: componentId,
                quantity: quantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModifiedAt: lastModifiedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VariantComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VariantComponentsTable,
      VariantComponent,
      $$VariantComponentsTableFilterComposer,
      $$VariantComponentsTableOrderingComposer,
      $$VariantComponentsTableAnnotationComposer,
      $$VariantComponentsTableCreateCompanionBuilder,
      $$VariantComponentsTableUpdateCompanionBuilder,
      (
        VariantComponent,
        BaseReferences<
          _$AppDatabase,
          $VariantComponentsTable,
          VariantComponent
        >,
      ),
      VariantComponent,
      PrefetchHooks Function()
    >;
typedef $$BufferStocksTableCreateCompanionBuilder =
    BufferStocksCompanion Function({
      required String id,
      required String companyItemId,
      Value<String?> brandId,
      Value<String?> location,
      required int minQuantity,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$BufferStocksTableUpdateCompanionBuilder =
    BufferStocksCompanion Function({
      Value<String> id,
      Value<String> companyItemId,
      Value<String?> brandId,
      Value<String?> location,
      Value<int> minQuantity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$BufferStocksTableFilterComposer
    extends Composer<_$AppDatabase, $BufferStocksTable> {
  $$BufferStocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minQuantity => $composableBuilder(
    column: $table.minQuantity,
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

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BufferStocksTableOrderingComposer
    extends Composer<_$AppDatabase, $BufferStocksTable> {
  $$BufferStocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minQuantity => $composableBuilder(
    column: $table.minQuantity,
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

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BufferStocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BufferStocksTable> {
  $$BufferStocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get minQuantity => $composableBuilder(
    column: $table.minQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$BufferStocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BufferStocksTable,
          BufferStock,
          $$BufferStocksTableFilterComposer,
          $$BufferStocksTableOrderingComposer,
          $$BufferStocksTableAnnotationComposer,
          $$BufferStocksTableCreateCompanionBuilder,
          $$BufferStocksTableUpdateCompanionBuilder,
          (
            BufferStock,
            BaseReferences<_$AppDatabase, $BufferStocksTable, BufferStock>,
          ),
          BufferStock,
          PrefetchHooks Function()
        > {
  $$BufferStocksTableTableManager(_$AppDatabase db, $BufferStocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BufferStocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BufferStocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BufferStocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> companyItemId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> minQuantity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BufferStocksCompanion(
                id: id,
                companyItemId: companyItemId,
                brandId: brandId,
                location: location,
                minQuantity: minQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String companyItemId,
                Value<String?> brandId = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required int minQuantity,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BufferStocksCompanion.insert(
                id: id,
                companyItemId: companyItemId,
                brandId: brandId,
                location: location,
                minQuantity: minQuantity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BufferStocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BufferStocksTable,
      BufferStock,
      $$BufferStocksTableFilterComposer,
      $$BufferStocksTableOrderingComposer,
      $$BufferStocksTableAnnotationComposer,
      $$BufferStocksTableCreateCompanionBuilder,
      $$BufferStocksTableUpdateCompanionBuilder,
      (
        BufferStock,
        BaseReferences<_$AppDatabase, $BufferStocksTable, BufferStock>,
      ),
      BufferStock,
      PrefetchHooks Function()
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      required String id,
      Value<String?> variantId,
      Value<String?> componentId,
      Value<String?> parentUnitId,
      required String qrValue,
      Value<String> status,
      Value<String?> location,
      Value<int> printCount,
      Value<DateTime?> lastPrintedAt,
      Value<String?> createdBy,
      Value<String?> updatedBy,
      Value<String?> lastPrintedBy,
      Value<DateTime?> syncedAt,
      required DateTime lastModifiedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<String> id,
      Value<String?> variantId,
      Value<String?> componentId,
      Value<String?> parentUnitId,
      Value<String> qrValue,
      Value<String> status,
      Value<String?> location,
      Value<int> printCount,
      Value<DateTime?> lastPrintedAt,
      Value<String?> createdBy,
      Value<String?> updatedBy,
      Value<String?> lastPrintedBy,
      Value<DateTime?> syncedAt,
      Value<DateTime> lastModifiedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentUnitId => $composableBuilder(
    column: $table.parentUnitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrValue => $composableBuilder(
    column: $table.qrValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get printCount => $composableBuilder(
    column: $table.printCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPrintedBy => $composableBuilder(
    column: $table.lastPrintedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentUnitId => $composableBuilder(
    column: $table.parentUnitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrValue => $composableBuilder(
    column: $table.qrValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get printCount => $composableBuilder(
    column: $table.printCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPrintedBy => $composableBuilder(
    column: $table.lastPrintedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needSync => $composableBuilder(
    column: $table.needSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variantId =>
      $composableBuilder(column: $table.variantId, builder: (column) => column);

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentUnitId => $composableBuilder(
    column: $table.parentUnitId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qrValue =>
      $composableBuilder(column: $table.qrValue, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get printCount => $composableBuilder(
    column: $table.printCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get lastPrintedBy => $composableBuilder(
    column: $table.lastPrintedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModifiedAt => $composableBuilder(
    column: $table.lastModifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get needSync =>
      $composableBuilder(column: $table.needSync, builder: (column) => column);
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
          Unit,
          PrefetchHooks Function()
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> variantId = const Value.absent(),
                Value<String?> componentId = const Value.absent(),
                Value<String?> parentUnitId = const Value.absent(),
                Value<String> qrValue = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> printCount = const Value.absent(),
                Value<DateTime?> lastPrintedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<String?> lastPrintedBy = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                variantId: variantId,
                componentId: componentId,
                parentUnitId: parentUnitId,
                qrValue: qrValue,
                status: status,
                location: location,
                printCount: printCount,
                lastPrintedAt: lastPrintedAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                lastPrintedBy: lastPrintedBy,
                syncedAt: syncedAt,
                lastModifiedAt: lastModifiedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> variantId = const Value.absent(),
                Value<String?> componentId = const Value.absent(),
                Value<String?> parentUnitId = const Value.absent(),
                required String qrValue,
                Value<String> status = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> printCount = const Value.absent(),
                Value<DateTime?> lastPrintedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<String?> lastPrintedBy = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required DateTime lastModifiedAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                variantId: variantId,
                componentId: componentId,
                parentUnitId: parentUnitId,
                qrValue: qrValue,
                status: status,
                location: location,
                printCount: printCount,
                lastPrintedAt: lastPrintedAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                lastPrintedBy: lastPrintedBy,
                syncedAt: syncedAt,
                lastModifiedAt: lastModifiedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                needSync: needSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, BaseReferences<_$AppDatabase, $UnitsTable, Unit>),
      Unit,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db, _db.brands);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CompanyItemsTableTableManager get companyItems =>
      $$CompanyItemsTableTableManager(_db, _db.companyItems);
  $$VariantsTableTableManager get variants =>
      $$VariantsTableTableManager(_db, _db.variants);
  $$VariantPhotosTableTableManager get variantPhotos =>
      $$VariantPhotosTableTableManager(_db, _db.variantPhotos);
  $$ComponentsTableTableManager get components =>
      $$ComponentsTableTableManager(_db, _db.components);
  $$VariantComponentsTableTableManager get variantComponents =>
      $$VariantComponentsTableTableManager(_db, _db.variantComponents);
  $$BufferStocksTableTableManager get bufferStocks =>
      $$BufferStocksTableTableManager(_db, _db.bufferStocks);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
