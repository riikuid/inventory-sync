// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Department> instance, {
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
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final String id;
  final String name;
  final String code;
  const Department({required this.id, required this.name, required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
    );
  }

  factory Department.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
    };
  }

  Department copyWith({String? id, String? name, String? code}) => Department(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
  );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> code;
  final Value<int> rowid;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    required String id,
    required String name,
    required String code,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       code = Value(code);
  static Insertable<Department> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? code,
    Value<int>? rowid,
  }) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
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
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionsTable extends Sections with TableInfo<$SectionsTable, Section> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentCodeMeta = const VerificationMeta(
    'departmentCode',
  );
  @override
  late final GeneratedColumn<String> departmentCode = GeneratedColumn<String>(
    'department_code',
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    departmentId,
    departmentCode,
    name,
    code,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Section> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('department_code')) {
      context.handle(
        _departmentCodeMeta,
        departmentCode.isAcceptableOrUnknown(
          data['department_code']!,
          _departmentCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Section map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Section(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      departmentCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
    );
  }

  @override
  $SectionsTable createAlias(String alias) {
    return $SectionsTable(attachedDatabase, alias);
  }
}

class Section extends DataClass implements Insertable<Section> {
  final String id;
  final String departmentId;
  final String departmentCode;
  final String name;
  final String code;
  const Section({
    required this.id,
    required this.departmentId,
    required this.departmentCode,
    required this.name,
    required this.code,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['department_id'] = Variable<String>(departmentId);
    map['department_code'] = Variable<String>(departmentCode);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    return map;
  }

  SectionsCompanion toCompanion(bool nullToAbsent) {
    return SectionsCompanion(
      id: Value(id),
      departmentId: Value(departmentId),
      departmentCode: Value(departmentCode),
      name: Value(name),
      code: Value(code),
    );
  }

  factory Section.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Section(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      departmentCode: serializer.fromJson<String>(json['departmentCode']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String>(departmentId),
      'departmentCode': serializer.toJson<String>(departmentCode),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
    };
  }

  Section copyWith({
    String? id,
    String? departmentId,
    String? departmentCode,
    String? name,
    String? code,
  }) => Section(
    id: id ?? this.id,
    departmentId: departmentId ?? this.departmentId,
    departmentCode: departmentCode ?? this.departmentCode,
    name: name ?? this.name,
    code: code ?? this.code,
  );
  Section copyWithCompanion(SectionsCompanion data) {
    return Section(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      departmentCode: data.departmentCode.present
          ? data.departmentCode.value
          : this.departmentCode,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Section(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('departmentCode: $departmentCode, ')
          ..write('name: $name, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, departmentId, departmentCode, name, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Section &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.departmentCode == this.departmentCode &&
          other.name == this.name &&
          other.code == this.code);
}

class SectionsCompanion extends UpdateCompanion<Section> {
  final Value<String> id;
  final Value<String> departmentId;
  final Value<String> departmentCode;
  final Value<String> name;
  final Value<String> code;
  final Value<int> rowid;
  const SectionsCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.departmentCode = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionsCompanion.insert({
    required String id,
    required String departmentId,
    required String departmentCode,
    required String name,
    required String code,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       departmentId = Value(departmentId),
       departmentCode = Value(departmentCode),
       name = Value(name),
       code = Value(code);
  static Insertable<Section> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? departmentCode,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (departmentCode != null) 'department_code': departmentCode,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? departmentId,
    Value<String>? departmentCode,
    Value<String>? name,
    Value<String>? code,
    Value<int>? rowid,
  }) {
    return SectionsCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      departmentCode: departmentCode ?? this.departmentCode,
      name: name ?? this.name,
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (departmentCode.present) {
      map['department_code'] = Variable<String>(departmentCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionsCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('departmentCode: $departmentCode, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WarehousesTable extends Warehouses
    with TableInfo<$WarehousesTable, Warehouse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WarehousesTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'warehouses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Warehouse> instance, {
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
  Warehouse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Warehouse(
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
  $WarehousesTable createAlias(String alias) {
    return $WarehousesTable(attachedDatabase, alias);
  }
}

class Warehouse extends DataClass implements Insertable<Warehouse> {
  final String id;
  final String name;
  const Warehouse({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  WarehousesCompanion toCompanion(bool nullToAbsent) {
    return WarehousesCompanion(id: Value(id), name: Value(name));
  }

  factory Warehouse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Warehouse(
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

  Warehouse copyWith({String? id, String? name}) =>
      Warehouse(id: id ?? this.id, name: name ?? this.name);
  Warehouse copyWithCompanion(WarehousesCompanion data) {
    return Warehouse(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Warehouse(')
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
      (other is Warehouse && other.id == this.id && other.name == this.name);
}

class WarehousesCompanion extends UpdateCompanion<Warehouse> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const WarehousesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WarehousesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Warehouse> custom({
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

  WarehousesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return WarehousesCompanion(
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
    return (StringBuffer('WarehousesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionWarehousesTable extends SectionWarehouses
    with TableInfo<$SectionWarehousesTable, SectionWarehouse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionWarehousesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warehouseIdMeta = const VerificationMeta(
    'warehouseId',
  );
  @override
  late final GeneratedColumn<String> warehouseId = GeneratedColumn<String>(
    'warehouse_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sectionId, warehouseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'section_warehouses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionWarehouse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('warehouse_id')) {
      context.handle(
        _warehouseIdMeta,
        warehouseId.isAcceptableOrUnknown(
          data['warehouse_id']!,
          _warehouseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warehouseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sectionId, warehouseId};
  @override
  SectionWarehouse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionWarehouse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      warehouseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warehouse_id'],
      )!,
    );
  }

  @override
  $SectionWarehousesTable createAlias(String alias) {
    return $SectionWarehousesTable(attachedDatabase, alias);
  }
}

class SectionWarehouse extends DataClass
    implements Insertable<SectionWarehouse> {
  final String id;
  final String sectionId;
  final String warehouseId;
  const SectionWarehouse({
    required this.id,
    required this.sectionId,
    required this.warehouseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['section_id'] = Variable<String>(sectionId);
    map['warehouse_id'] = Variable<String>(warehouseId);
    return map;
  }

  SectionWarehousesCompanion toCompanion(bool nullToAbsent) {
    return SectionWarehousesCompanion(
      id: Value(id),
      sectionId: Value(sectionId),
      warehouseId: Value(warehouseId),
    );
  }

  factory SectionWarehouse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionWarehouse(
      id: serializer.fromJson<String>(json['id']),
      sectionId: serializer.fromJson<String>(json['sectionId']),
      warehouseId: serializer.fromJson<String>(json['warehouseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sectionId': serializer.toJson<String>(sectionId),
      'warehouseId': serializer.toJson<String>(warehouseId),
    };
  }

  SectionWarehouse copyWith({
    String? id,
    String? sectionId,
    String? warehouseId,
  }) => SectionWarehouse(
    id: id ?? this.id,
    sectionId: sectionId ?? this.sectionId,
    warehouseId: warehouseId ?? this.warehouseId,
  );
  SectionWarehouse copyWithCompanion(SectionWarehousesCompanion data) {
    return SectionWarehouse(
      id: data.id.present ? data.id.value : this.id,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      warehouseId: data.warehouseId.present
          ? data.warehouseId.value
          : this.warehouseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionWarehouse(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('warehouseId: $warehouseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sectionId, warehouseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionWarehouse &&
          other.id == this.id &&
          other.sectionId == this.sectionId &&
          other.warehouseId == this.warehouseId);
}

class SectionWarehousesCompanion extends UpdateCompanion<SectionWarehouse> {
  final Value<String> id;
  final Value<String> sectionId;
  final Value<String> warehouseId;
  final Value<int> rowid;
  const SectionWarehousesCompanion({
    this.id = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionWarehousesCompanion.insert({
    required String id,
    required String sectionId,
    required String warehouseId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sectionId = Value(sectionId),
       warehouseId = Value(warehouseId);
  static Insertable<SectionWarehouse> custom({
    Expression<String>? id,
    Expression<String>? sectionId,
    Expression<String>? warehouseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sectionId != null) 'section_id': sectionId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionWarehousesCompanion copyWith({
    Value<String>? id,
    Value<String>? sectionId,
    Value<String>? warehouseId,
    Value<int>? rowid,
  }) {
    return SectionWarehousesCompanion(
      id: id ?? this.id,
      sectionId: sectionId ?? this.sectionId,
      warehouseId: warehouseId ?? this.warehouseId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<String>(warehouseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionWarehousesCompanion(')
          ..write('id: $id, ')
          ..write('sectionId: $sectionId, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RacksTable extends Racks with TableInfo<$RacksTable, Rack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RacksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _warehouseIdMeta = const VerificationMeta(
    'warehouseId',
  );
  @override
  late final GeneratedColumn<String> warehouseId = GeneratedColumn<String>(
    'warehouse_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, warehouseId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'racks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rack> instance, {
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
    if (data.containsKey('warehouse_id')) {
      context.handle(
        _warehouseIdMeta,
        warehouseId.isAcceptableOrUnknown(
          data['warehouse_id']!,
          _warehouseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warehouseIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      warehouseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warehouse_id'],
      )!,
    );
  }

  @override
  $RacksTable createAlias(String alias) {
    return $RacksTable(attachedDatabase, alias);
  }
}

class Rack extends DataClass implements Insertable<Rack> {
  final String id;
  final String name;
  final String warehouseId;
  const Rack({required this.id, required this.name, required this.warehouseId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['warehouse_id'] = Variable<String>(warehouseId);
    return map;
  }

  RacksCompanion toCompanion(bool nullToAbsent) {
    return RacksCompanion(
      id: Value(id),
      name: Value(name),
      warehouseId: Value(warehouseId),
    );
  }

  factory Rack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rack(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      warehouseId: serializer.fromJson<String>(json['warehouseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'warehouseId': serializer.toJson<String>(warehouseId),
    };
  }

  Rack copyWith({String? id, String? name, String? warehouseId}) => Rack(
    id: id ?? this.id,
    name: name ?? this.name,
    warehouseId: warehouseId ?? this.warehouseId,
  );
  Rack copyWithCompanion(RacksCompanion data) {
    return Rack(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      warehouseId: data.warehouseId.present
          ? data.warehouseId.value
          : this.warehouseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rack(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('warehouseId: $warehouseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, warehouseId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rack &&
          other.id == this.id &&
          other.name == this.name &&
          other.warehouseId == this.warehouseId);

  void operator [](String other) {}
}

class RacksCompanion extends UpdateCompanion<Rack> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> warehouseId;
  final Value<int> rowid;
  const RacksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.warehouseId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RacksCompanion.insert({
    required String id,
    required String name,
    required String warehouseId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       warehouseId = Value(warehouseId);
  static Insertable<Rack> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? warehouseId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RacksCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? warehouseId,
    Value<int>? rowid,
  }) {
    return RacksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      warehouseId: warehouseId ?? this.warehouseId,
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
    if (warehouseId.present) {
      map['warehouse_id'] = Variable<String>(warehouseId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RacksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('warehouseId: $warehouseId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryParentIdMeta = const VerificationMeta(
    'categoryParentId',
  );
  @override
  late final GeneratedColumn<String> categoryParentId = GeneratedColumn<String>(
    'category_parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, code, categoryParentId];
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
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('category_parent_id')) {
      context.handle(
        _categoryParentIdMeta,
        categoryParentId.isAcceptableOrUnknown(
          data['category_parent_id']!,
          _categoryParentIdMeta,
        ),
      );
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
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      categoryParentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_parent_id'],
      ),
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
  final String code;
  final String? categoryParentId;
  const Category({
    required this.id,
    required this.name,
    required this.code,
    this.categoryParentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || categoryParentId != null) {
      map['category_parent_id'] = Variable<String>(categoryParentId);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      categoryParentId: categoryParentId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryParentId),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      categoryParentId: serializer.fromJson<String?>(json['categoryParentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'categoryParentId': serializer.toJson<String?>(categoryParentId),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? code,
    Value<String?> categoryParentId = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
    categoryParentId: categoryParentId.present
        ? categoryParentId.value
        : this.categoryParentId,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      categoryParentId: data.categoryParentId.present
          ? data.categoryParentId.value
          : this.categoryParentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('categoryParentId: $categoryParentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, code, categoryParentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.categoryParentId == this.categoryParentId);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> code;
  final Value<String?> categoryParentId;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.categoryParentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required String code,
    this.categoryParentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       code = Value(code);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? categoryParentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (categoryParentId != null) 'category_parent_id': categoryParentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? code,
    Value<String?>? categoryParentId,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      categoryParentId: categoryParentId ?? this.categoryParentId,
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
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (categoryParentId.present) {
      map['category_parent_id'] = Variable<String>(categoryParentId.value);
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
          ..write('code: $code, ')
          ..write('categoryParentId: $categoryParentId, ')
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
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
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
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
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
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
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
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Product({
    required this.id,
    required this.name,
    this.description,
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
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
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
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
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
      description: serializer.fromJson<String?>(json['description']),
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
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
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
          ..write('description: $description, ')
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
    description,
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
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
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
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
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
          ..write('description: $description, ')
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
  static const VerificationMeta _defaultRackIdMeta = const VerificationMeta(
    'defaultRackId',
  );
  @override
  late final GeneratedColumn<String> defaultRackId = GeneratedColumn<String>(
    'default_rack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _machinePurchaseMeta = const VerificationMeta(
    'machinePurchase',
  );
  @override
  late final GeneratedColumn<String> machinePurchase = GeneratedColumn<String>(
    'machine_purchase',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _specificationMeta = const VerificationMeta(
    'specification',
  );
  @override
  late final GeneratedColumn<String> specification = GeneratedColumn<String>(
    'specification',
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
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultRackId,
    productId,
    categoryId,
    companyCode,
    machinePurchase,
    specification,
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
    if (data.containsKey('default_rack_id')) {
      context.handle(
        _defaultRackIdMeta,
        defaultRackId.isAcceptableOrUnknown(
          data['default_rack_id']!,
          _defaultRackIdMeta,
        ),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
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
    if (data.containsKey('machine_purchase')) {
      context.handle(
        _machinePurchaseMeta,
        machinePurchase.isAcceptableOrUnknown(
          data['machine_purchase']!,
          _machinePurchaseMeta,
        ),
      );
    }
    if (data.containsKey('specification')) {
      context.handle(
        _specificationMeta,
        specification.isAcceptableOrUnknown(
          data['specification']!,
          _specificationMeta,
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
      defaultRackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_rack_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      companyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_code'],
      )!,
      machinePurchase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_purchase'],
      ),
      specification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specification'],
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
  final String? defaultRackId;
  final String productId;
  final String? categoryId;
  final String companyCode;
  final String? machinePurchase;
  final String? specification;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const CompanyItem({
    required this.id,
    this.defaultRackId,
    required this.productId,
    this.categoryId,
    required this.companyCode,
    this.machinePurchase,
    this.specification,
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
    if (!nullToAbsent || defaultRackId != null) {
      map['default_rack_id'] = Variable<String>(defaultRackId);
    }
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['company_code'] = Variable<String>(companyCode);
    if (!nullToAbsent || machinePurchase != null) {
      map['machine_purchase'] = Variable<String>(machinePurchase);
    }
    if (!nullToAbsent || specification != null) {
      map['specification'] = Variable<String>(specification);
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
      defaultRackId: defaultRackId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultRackId),
      productId: Value(productId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      companyCode: Value(companyCode),
      machinePurchase: machinePurchase == null && nullToAbsent
          ? const Value.absent()
          : Value(machinePurchase),
      specification: specification == null && nullToAbsent
          ? const Value.absent()
          : Value(specification),
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
      defaultRackId: serializer.fromJson<String?>(json['defaultRackId']),
      productId: serializer.fromJson<String>(json['productId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      companyCode: serializer.fromJson<String>(json['companyCode']),
      machinePurchase: serializer.fromJson<String?>(json['machinePurchase']),
      specification: serializer.fromJson<String?>(json['specification']),
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
      'defaultRackId': serializer.toJson<String?>(defaultRackId),
      'productId': serializer.toJson<String>(productId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'companyCode': serializer.toJson<String>(companyCode),
      'machinePurchase': serializer.toJson<String?>(machinePurchase),
      'specification': serializer.toJson<String?>(specification),
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
    Value<String?> defaultRackId = const Value.absent(),
    String? productId,
    Value<String?> categoryId = const Value.absent(),
    String? companyCode,
    Value<String?> machinePurchase = const Value.absent(),
    Value<String?> specification = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => CompanyItem(
    id: id ?? this.id,
    defaultRackId: defaultRackId.present
        ? defaultRackId.value
        : this.defaultRackId,
    productId: productId ?? this.productId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    companyCode: companyCode ?? this.companyCode,
    machinePurchase: machinePurchase.present
        ? machinePurchase.value
        : this.machinePurchase,
    specification: specification.present
        ? specification.value
        : this.specification,
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
      defaultRackId: data.defaultRackId.present
          ? data.defaultRackId.value
          : this.defaultRackId,
      productId: data.productId.present ? data.productId.value : this.productId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      companyCode: data.companyCode.present
          ? data.companyCode.value
          : this.companyCode,
      machinePurchase: data.machinePurchase.present
          ? data.machinePurchase.value
          : this.machinePurchase,
      specification: data.specification.present
          ? data.specification.value
          : this.specification,
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
          ..write('defaultRackId: $defaultRackId, ')
          ..write('productId: $productId, ')
          ..write('categoryId: $categoryId, ')
          ..write('companyCode: $companyCode, ')
          ..write('machinePurchase: $machinePurchase, ')
          ..write('specification: $specification, ')
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
    defaultRackId,
    productId,
    categoryId,
    companyCode,
    machinePurchase,
    specification,
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
          other.defaultRackId == this.defaultRackId &&
          other.productId == this.productId &&
          other.categoryId == this.categoryId &&
          other.companyCode == this.companyCode &&
          other.machinePurchase == this.machinePurchase &&
          other.specification == this.specification &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class CompanyItemsCompanion extends UpdateCompanion<CompanyItem> {
  final Value<String> id;
  final Value<String?> defaultRackId;
  final Value<String> productId;
  final Value<String?> categoryId;
  final Value<String> companyCode;
  final Value<String?> machinePurchase;
  final Value<String?> specification;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const CompanyItemsCompanion({
    this.id = const Value.absent(),
    this.defaultRackId = const Value.absent(),
    this.productId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.companyCode = const Value.absent(),
    this.machinePurchase = const Value.absent(),
    this.specification = const Value.absent(),
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
    this.defaultRackId = const Value.absent(),
    required String productId,
    this.categoryId = const Value.absent(),
    required String companyCode,
    this.machinePurchase = const Value.absent(),
    this.specification = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       companyCode = Value(companyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CompanyItem> custom({
    Expression<String>? id,
    Expression<String>? defaultRackId,
    Expression<String>? productId,
    Expression<String>? categoryId,
    Expression<String>? companyCode,
    Expression<String>? machinePurchase,
    Expression<String>? specification,
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
      if (defaultRackId != null) 'default_rack_id': defaultRackId,
      if (productId != null) 'product_id': productId,
      if (categoryId != null) 'category_id': categoryId,
      if (companyCode != null) 'company_code': companyCode,
      if (machinePurchase != null) 'machine_purchase': machinePurchase,
      if (specification != null) 'specification': specification,
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
    Value<String?>? defaultRackId,
    Value<String>? productId,
    Value<String?>? categoryId,
    Value<String>? companyCode,
    Value<String?>? machinePurchase,
    Value<String?>? specification,
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
      defaultRackId: defaultRackId ?? this.defaultRackId,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      companyCode: companyCode ?? this.companyCode,
      machinePurchase: machinePurchase ?? this.machinePurchase,
      specification: specification ?? this.specification,
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
    if (defaultRackId.present) {
      map['default_rack_id'] = Variable<String>(defaultRackId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (companyCode.present) {
      map['company_code'] = Variable<String>(companyCode.value);
    }
    if (machinePurchase.present) {
      map['machine_purchase'] = Variable<String>(machinePurchase.value);
    }
    if (specification.present) {
      map['specification'] = Variable<String>(specification.value);
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
          ..write('defaultRackId: $defaultRackId, ')
          ..write('productId: $productId, ')
          ..write('categoryId: $categoryId, ')
          ..write('companyCode: $companyCode, ')
          ..write('machinePurchase: $machinePurchase, ')
          ..write('specification: $specification, ')
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
  static const VerificationMeta _rackIdMeta = const VerificationMeta('rackId');
  @override
  late final GeneratedColumn<String> rackId = GeneratedColumn<String>(
    'rack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
    'uom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _specificationMeta = const VerificationMeta(
    'specification',
  );
  @override
  late final GeneratedColumn<String> specification = GeneratedColumn<String>(
    'specification',
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
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyItemId,
    rackId,
    brandId,
    name,
    uom,
    manufCode,
    specification,
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
    if (data.containsKey('rack_id')) {
      context.handle(
        _rackIdMeta,
        rackId.isAcceptableOrUnknown(data['rack_id']!, _rackIdMeta),
      );
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
    if (data.containsKey('uom')) {
      context.handle(
        _uomMeta,
        uom.isAcceptableOrUnknown(data['uom']!, _uomMeta),
      );
    } else if (isInserting) {
      context.missing(_uomMeta);
    }
    if (data.containsKey('manuf_code')) {
      context.handle(
        _manufCodeMeta,
        manufCode.isAcceptableOrUnknown(data['manuf_code']!, _manufCodeMeta),
      );
    }
    if (data.containsKey('specification')) {
      context.handle(
        _specificationMeta,
        specification.isAcceptableOrUnknown(
          data['specification']!,
          _specificationMeta,
        ),
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
      rackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rack_id'],
      ),
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      uom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom'],
      )!,
      manufCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manuf_code'],
      ),
      specification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specification'],
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
  $VariantsTable createAlias(String alias) {
    return $VariantsTable(attachedDatabase, alias);
  }
}

class Variant extends DataClass implements Insertable<Variant> {
  final String id;
  final String companyItemId;
  final String? rackId;
  final String? brandId;
  final String name;
  final String uom;
  final String? manufCode;
  final String? specification;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Variant({
    required this.id,
    required this.companyItemId,
    this.rackId,
    this.brandId,
    required this.name,
    required this.uom,
    this.manufCode,
    this.specification,
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
    if (!nullToAbsent || rackId != null) {
      map['rack_id'] = Variable<String>(rackId);
    }
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    map['name'] = Variable<String>(name);
    map['uom'] = Variable<String>(uom);
    if (!nullToAbsent || manufCode != null) {
      map['manuf_code'] = Variable<String>(manufCode);
    }
    if (!nullToAbsent || specification != null) {
      map['specification'] = Variable<String>(specification);
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

  VariantsCompanion toCompanion(bool nullToAbsent) {
    return VariantsCompanion(
      id: Value(id),
      companyItemId: Value(companyItemId),
      rackId: rackId == null && nullToAbsent
          ? const Value.absent()
          : Value(rackId),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      name: Value(name),
      uom: Value(uom),
      manufCode: manufCode == null && nullToAbsent
          ? const Value.absent()
          : Value(manufCode),
      specification: specification == null && nullToAbsent
          ? const Value.absent()
          : Value(specification),
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
      rackId: serializer.fromJson<String?>(json['rackId']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      name: serializer.fromJson<String>(json['name']),
      uom: serializer.fromJson<String>(json['uom']),
      manufCode: serializer.fromJson<String?>(json['manufCode']),
      specification: serializer.fromJson<String?>(json['specification']),
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
      'rackId': serializer.toJson<String?>(rackId),
      'brandId': serializer.toJson<String?>(brandId),
      'name': serializer.toJson<String>(name),
      'uom': serializer.toJson<String>(uom),
      'manufCode': serializer.toJson<String?>(manufCode),
      'specification': serializer.toJson<String?>(specification),
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
    Value<String?> rackId = const Value.absent(),
    Value<String?> brandId = const Value.absent(),
    String? name,
    String? uom,
    Value<String?> manufCode = const Value.absent(),
    Value<String?> specification = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Variant(
    id: id ?? this.id,
    companyItemId: companyItemId ?? this.companyItemId,
    rackId: rackId.present ? rackId.value : this.rackId,
    brandId: brandId.present ? brandId.value : this.brandId,
    name: name ?? this.name,
    uom: uom ?? this.uom,
    manufCode: manufCode.present ? manufCode.value : this.manufCode,
    specification: specification.present
        ? specification.value
        : this.specification,
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
      rackId: data.rackId.present ? data.rackId.value : this.rackId,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      name: data.name.present ? data.name.value : this.name,
      uom: data.uom.present ? data.uom.value : this.uom,
      manufCode: data.manufCode.present ? data.manufCode.value : this.manufCode,
      specification: data.specification.present
          ? data.specification.value
          : this.specification,
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
          ..write('rackId: $rackId, ')
          ..write('brandId: $brandId, ')
          ..write('name: $name, ')
          ..write('uom: $uom, ')
          ..write('manufCode: $manufCode, ')
          ..write('specification: $specification, ')
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
    rackId,
    brandId,
    name,
    uom,
    manufCode,
    specification,
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
          other.rackId == this.rackId &&
          other.brandId == this.brandId &&
          other.name == this.name &&
          other.uom == this.uom &&
          other.manufCode == this.manufCode &&
          other.specification == this.specification &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class VariantsCompanion extends UpdateCompanion<Variant> {
  final Value<String> id;
  final Value<String> companyItemId;
  final Value<String?> rackId;
  final Value<String?> brandId;
  final Value<String> name;
  final Value<String> uom;
  final Value<String?> manufCode;
  final Value<String?> specification;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const VariantsCompanion({
    this.id = const Value.absent(),
    this.companyItemId = const Value.absent(),
    this.rackId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.name = const Value.absent(),
    this.uom = const Value.absent(),
    this.manufCode = const Value.absent(),
    this.specification = const Value.absent(),
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
    this.rackId = const Value.absent(),
    this.brandId = const Value.absent(),
    required String name,
    required String uom,
    this.manufCode = const Value.absent(),
    this.specification = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       companyItemId = Value(companyItemId),
       name = Value(name),
       uom = Value(uom),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Variant> custom({
    Expression<String>? id,
    Expression<String>? companyItemId,
    Expression<String>? rackId,
    Expression<String>? brandId,
    Expression<String>? name,
    Expression<String>? uom,
    Expression<String>? manufCode,
    Expression<String>? specification,
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
      if (rackId != null) 'rack_id': rackId,
      if (brandId != null) 'brand_id': brandId,
      if (name != null) 'name': name,
      if (uom != null) 'uom': uom,
      if (manufCode != null) 'manuf_code': manufCode,
      if (specification != null) 'specification': specification,
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
    Value<String?>? rackId,
    Value<String?>? brandId,
    Value<String>? name,
    Value<String>? uom,
    Value<String?>? manufCode,
    Value<String?>? specification,
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
      rackId: rackId ?? this.rackId,
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      uom: uom ?? this.uom,
      manufCode: manufCode ?? this.manufCode,
      specification: specification ?? this.specification,
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
    if (rackId.present) {
      map['rack_id'] = Variable<String>(rackId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (manufCode.present) {
      map['manuf_code'] = Variable<String>(manufCode.value);
    }
    if (specification.present) {
      map['specification'] = Variable<String>(specification.value);
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
          ..write('rackId: $rackId, ')
          ..write('brandId: $brandId, ')
          ..write('name: $name, ')
          ..write('uom: $uom, ')
          ..write('manufCode: $manufCode, ')
          ..write('specification: $specification, ')
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
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
    sortOrder,
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
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
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
      ),
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
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
  final String? localPath;
  final String? remoteUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const VariantPhoto({
    required this.id,
    required this.variantId,
    this.localPath,
    this.remoteUrl,
    required this.sortOrder,
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
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    map['sort_order'] = Variable<int>(sortOrder);
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
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      sortOrder: Value(sortOrder),
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
      localPath: serializer.fromJson<String?>(json['localPath']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
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
      'localPath': serializer.toJson<String?>(localPath),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'sortOrder': serializer.toJson<int>(sortOrder),
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
    Value<String?> localPath = const Value.absent(),
    Value<String?> remoteUrl = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => VariantPhoto(
    id: id ?? this.id,
    variantId: variantId ?? this.variantId,
    localPath: localPath.present ? localPath.value : this.localPath,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    sortOrder: sortOrder ?? this.sortOrder,
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
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
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
          ..write('sortOrder: $sortOrder, ')
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
    sortOrder,
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
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class VariantPhotosCompanion extends UpdateCompanion<VariantPhoto> {
  final Value<String> id;
  final Value<String> variantId;
  final Value<String?> localPath;
  final Value<String?> remoteUrl;
  final Value<int> sortOrder;
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
    this.sortOrder = const Value.absent(),
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
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       variantId = Value(variantId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VariantPhoto> custom({
    Expression<String>? id,
    Expression<String>? variantId,
    Expression<String>? localPath,
    Expression<String>? remoteUrl,
    Expression<int>? sortOrder,
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
      if (sortOrder != null) 'sort_order': sortOrder,
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
    Value<String?>? localPath,
    Value<String?>? remoteUrl,
    Value<int>? sortOrder,
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
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
          ..write('sortOrder: $sortOrder, ')
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
  static const VerificationMeta _specificationMeta = const VerificationMeta(
    'specification',
  );
  @override
  late final GeneratedColumn<String> specification = GeneratedColumn<String>(
    'specification',
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
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    type,
    brandId,
    manufCode,
    specification,
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
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
    if (data.containsKey('specification')) {
      context.handle(
        _specificationMeta,
        specification.isAcceptableOrUnknown(
          data['specification']!,
          _specificationMeta,
        ),
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
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      ),
      manufCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manuf_code'],
      ),
      specification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specification'],
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
  $ComponentsTable createAlias(String alias) {
    return $ComponentsTable(attachedDatabase, alias);
  }
}

class Component extends DataClass implements Insertable<Component> {
  final String id;
  final String productId;
  final String name;
  final int type;
  final String? brandId;
  final String? manufCode;
  final String? specification;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Component({
    required this.id,
    required this.productId,
    required this.name,
    required this.type,
    this.brandId,
    this.manufCode,
    this.specification,
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
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<String>(brandId);
    }
    if (!nullToAbsent || manufCode != null) {
      map['manuf_code'] = Variable<String>(manufCode);
    }
    if (!nullToAbsent || specification != null) {
      map['specification'] = Variable<String>(specification);
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

  ComponentsCompanion toCompanion(bool nullToAbsent) {
    return ComponentsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      type: Value(type),
      brandId: brandId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandId),
      manufCode: manufCode == null && nullToAbsent
          ? const Value.absent()
          : Value(manufCode),
      specification: specification == null && nullToAbsent
          ? const Value.absent()
          : Value(specification),
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
      type: serializer.fromJson<int>(json['type']),
      brandId: serializer.fromJson<String?>(json['brandId']),
      manufCode: serializer.fromJson<String?>(json['manufCode']),
      specification: serializer.fromJson<String?>(json['specification']),
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
      'type': serializer.toJson<int>(type),
      'brandId': serializer.toJson<String?>(brandId),
      'manufCode': serializer.toJson<String?>(manufCode),
      'specification': serializer.toJson<String?>(specification),
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
    int? type,
    Value<String?> brandId = const Value.absent(),
    Value<String?> manufCode = const Value.absent(),
    Value<String?> specification = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Component(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    type: type ?? this.type,
    brandId: brandId.present ? brandId.value : this.brandId,
    manufCode: manufCode.present ? manufCode.value : this.manufCode,
    specification: specification.present
        ? specification.value
        : this.specification,
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
      type: data.type.present ? data.type.value : this.type,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      manufCode: data.manufCode.present ? data.manufCode.value : this.manufCode,
      specification: data.specification.present
          ? data.specification.value
          : this.specification,
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
          ..write('type: $type, ')
          ..write('brandId: $brandId, ')
          ..write('manufCode: $manufCode, ')
          ..write('specification: $specification, ')
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
    type,
    brandId,
    manufCode,
    specification,
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
          other.type == this.type &&
          other.brandId == this.brandId &&
          other.manufCode == this.manufCode &&
          other.specification == this.specification &&
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
  final Value<int> type;
  final Value<String?> brandId;
  final Value<String?> manufCode;
  final Value<String?> specification;
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
    this.type = const Value.absent(),
    this.brandId = const Value.absent(),
    this.manufCode = const Value.absent(),
    this.specification = const Value.absent(),
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
    this.type = const Value.absent(),
    this.brandId = const Value.absent(),
    this.manufCode = const Value.absent(),
    this.specification = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Component> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? brandId,
    Expression<String>? manufCode,
    Expression<String>? specification,
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
      if (type != null) 'type': type,
      if (brandId != null) 'brand_id': brandId,
      if (manufCode != null) 'manuf_code': manufCode,
      if (specification != null) 'specification': specification,
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
    Value<int>? type,
    Value<String?>? brandId,
    Value<String?>? manufCode,
    Value<String?>? specification,
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
      type: type ?? this.type,
      brandId: brandId ?? this.brandId,
      manufCode: manufCode ?? this.manufCode,
      specification: specification ?? this.specification,
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
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (manufCode.present) {
      map['manuf_code'] = Variable<String>(manufCode.value);
    }
    if (specification.present) {
      map['specification'] = Variable<String>(specification.value);
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
          ..write('type: $type, ')
          ..write('brandId: $brandId, ')
          ..write('manufCode: $manufCode, ')
          ..write('specification: $specification, ')
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

class $ComponentPhotosTable extends ComponentPhotos
    with TableInfo<$ComponentPhotosTable, ComponentPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
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
    componentId,
    localPath,
    remoteUrl,
    sortOrder,
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
  static const String $name = 'component_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComponentPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('remote_url')) {
      context.handle(
        _remoteUrlMeta,
        remoteUrl.isAcceptableOrUnknown(data['remote_url']!, _remoteUrlMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
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
  ComponentPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComponentPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      remoteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_url'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
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
  $ComponentPhotosTable createAlias(String alias) {
    return $ComponentPhotosTable(attachedDatabase, alias);
  }
}

class ComponentPhoto extends DataClass implements Insertable<ComponentPhoto> {
  final String id;
  final String componentId;
  final String? localPath;
  final String? remoteUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const ComponentPhoto({
    required this.id,
    required this.componentId,
    this.localPath,
    this.remoteUrl,
    required this.sortOrder,
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
    map['component_id'] = Variable<String>(componentId);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  ComponentPhotosCompanion toCompanion(bool nullToAbsent) {
    return ComponentPhotosCompanion(
      id: Value(id),
      componentId: Value(componentId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastModifiedAt: Value(lastModifiedAt),
      needSync: Value(needSync),
    );
  }

  factory ComponentPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComponentPhoto(
      id: serializer.fromJson<String>(json['id']),
      componentId: serializer.fromJson<String>(json['componentId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      remoteUrl: serializer.fromJson<String?>(json['remoteUrl']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
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
      'componentId': serializer.toJson<String>(componentId),
      'localPath': serializer.toJson<String?>(localPath),
      'remoteUrl': serializer.toJson<String?>(remoteUrl),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  ComponentPhoto copyWith({
    String? id,
    String? componentId,
    Value<String?> localPath = const Value.absent(),
    Value<String?> remoteUrl = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => ComponentPhoto(
    id: id ?? this.id,
    componentId: componentId ?? this.componentId,
    localPath: localPath.present ? localPath.value : this.localPath,
    remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    needSync: needSync ?? this.needSync,
  );
  ComponentPhoto copyWithCompanion(ComponentPhotosCompanion data) {
    return ComponentPhoto(
      id: data.id.present ? data.id.value : this.id,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
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
    return (StringBuffer('ComponentPhoto(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('sortOrder: $sortOrder, ')
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
    componentId,
    localPath,
    remoteUrl,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
    needSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComponentPhoto &&
          other.id == this.id &&
          other.componentId == this.componentId &&
          other.localPath == this.localPath &&
          other.remoteUrl == this.remoteUrl &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class ComponentPhotosCompanion extends UpdateCompanion<ComponentPhoto> {
  final Value<String> id;
  final Value<String> componentId;
  final Value<String?> localPath;
  final Value<String?> remoteUrl;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const ComponentPhotosCompanion({
    this.id = const Value.absent(),
    this.componentId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComponentPhotosCompanion.insert({
    required String id,
    required String componentId,
    this.localPath = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       componentId = Value(componentId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ComponentPhoto> custom({
    Expression<String>? id,
    Expression<String>? componentId,
    Expression<String>? localPath,
    Expression<String>? remoteUrl,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? lastModifiedAt,
    Expression<bool>? needSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (componentId != null) 'component_id': componentId,
      if (localPath != null) 'local_path': localPath,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComponentPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? componentId,
    Value<String?>? localPath,
    Value<String?>? remoteUrl,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return ComponentPhotosCompanion(
      id: id ?? this.id,
      componentId: componentId ?? this.componentId,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('ComponentPhotosCompanion(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('localPath: $localPath, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('sortOrder: $sortOrder, ')
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
  static const VerificationMeta _quantityNeededMeta = const VerificationMeta(
    'quantityNeeded',
  );
  @override
  late final GeneratedColumn<int> quantityNeeded = GeneratedColumn<int>(
    'quantity_needed',
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
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    variantId,
    componentId,
    quantityNeeded,
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
    if (data.containsKey('quantity_needed')) {
      context.handle(
        _quantityNeededMeta,
        quantityNeeded.isAcceptableOrUnknown(
          data['quantity_needed']!,
          _quantityNeededMeta,
        ),
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
      quantityNeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_needed'],
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
  $VariantComponentsTable createAlias(String alias) {
    return $VariantComponentsTable(attachedDatabase, alias);
  }
}

class VariantComponent extends DataClass
    implements Insertable<VariantComponent> {
  final String id;
  final String variantId;
  final String componentId;
  final int quantityNeeded;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const VariantComponent({
    required this.id,
    required this.variantId,
    required this.componentId,
    required this.quantityNeeded,
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
    map['component_id'] = Variable<String>(componentId);
    map['quantity_needed'] = Variable<int>(quantityNeeded);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['last_modified_at'] = Variable<DateTime>(lastModifiedAt);
    map['need_sync'] = Variable<bool>(needSync);
    return map;
  }

  VariantComponentsCompanion toCompanion(bool nullToAbsent) {
    return VariantComponentsCompanion(
      id: Value(id),
      variantId: Value(variantId),
      componentId: Value(componentId),
      quantityNeeded: Value(quantityNeeded),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
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
      quantityNeeded: serializer.fromJson<int>(json['quantityNeeded']),
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
      'componentId': serializer.toJson<String>(componentId),
      'quantityNeeded': serializer.toJson<int>(quantityNeeded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  VariantComponent copyWith({
    String? id,
    String? variantId,
    String? componentId,
    int? quantityNeeded,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => VariantComponent(
    id: id ?? this.id,
    variantId: variantId ?? this.variantId,
    componentId: componentId ?? this.componentId,
    quantityNeeded: quantityNeeded ?? this.quantityNeeded,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
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
      quantityNeeded: data.quantityNeeded.present
          ? data.quantityNeeded.value
          : this.quantityNeeded,
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
    return (StringBuffer('VariantComponent(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('quantityNeeded: $quantityNeeded, ')
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
    componentId,
    quantityNeeded,
    createdAt,
    updatedAt,
    deletedAt,
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
          other.quantityNeeded == this.quantityNeeded &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class VariantComponentsCompanion extends UpdateCompanion<VariantComponent> {
  final Value<String> id;
  final Value<String> variantId;
  final Value<String> componentId;
  final Value<int> quantityNeeded;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const VariantComponentsCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.quantityNeeded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VariantComponentsCompanion.insert({
    required String id,
    required String variantId,
    required String componentId,
    this.quantityNeeded = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       variantId = Value(variantId),
       componentId = Value(componentId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VariantComponent> custom({
    Expression<String>? id,
    Expression<String>? variantId,
    Expression<String>? componentId,
    Expression<int>? quantityNeeded,
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
      if (componentId != null) 'component_id': componentId,
      if (quantityNeeded != null) 'quantity_needed': quantityNeeded,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VariantComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? variantId,
    Value<String>? componentId,
    Value<int>? quantityNeeded,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return VariantComponentsCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      componentId: componentId ?? this.componentId,
      quantityNeeded: quantityNeeded ?? this.quantityNeeded,
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
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (quantityNeeded.present) {
      map['quantity_needed'] = Variable<int>(quantityNeeded.value);
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
    return (StringBuffer('VariantComponentsCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('quantityNeeded: $quantityNeeded, ')
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
  static const VerificationMeta _rackIdMeta = const VerificationMeta('rackId');
  @override
  late final GeneratedColumn<String> rackId = GeneratedColumn<String>(
    'rack_id',
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
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    variantId,
    componentId,
    parentUnitId,
    rackId,
    qrValue,
    status,
    printCount,
    lastPrintedAt,
    lastPrintedBy,
    createdBy,
    updatedBy,
    syncedAt,
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
    if (data.containsKey('rack_id')) {
      context.handle(
        _rackIdMeta,
        rackId.isAcceptableOrUnknown(data['rack_id']!, _rackIdMeta),
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
    if (data.containsKey('last_printed_by')) {
      context.handle(
        _lastPrintedByMeta,
        lastPrintedBy.isAcceptableOrUnknown(
          data['last_printed_by']!,
          _lastPrintedByMeta,
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
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
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
      rackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rack_id'],
      ),
      qrValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_value'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      printCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}print_count'],
      )!,
      lastPrintedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_printed_at'],
      ),
      lastPrintedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_printed_by'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
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
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final String id;
  final String? variantId;
  final String? componentId;
  final String? parentUnitId;
  final String? rackId;
  final String qrValue;
  final int status;
  final int printCount;
  final DateTime? lastPrintedAt;
  final String? lastPrintedBy;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime lastModifiedAt;
  final bool needSync;
  const Unit({
    required this.id,
    this.variantId,
    this.componentId,
    this.parentUnitId,
    this.rackId,
    required this.qrValue,
    required this.status,
    required this.printCount,
    this.lastPrintedAt,
    this.lastPrintedBy,
    this.createdBy,
    this.updatedBy,
    this.syncedAt,
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
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    if (!nullToAbsent || componentId != null) {
      map['component_id'] = Variable<String>(componentId);
    }
    if (!nullToAbsent || parentUnitId != null) {
      map['parent_unit_id'] = Variable<String>(parentUnitId);
    }
    if (!nullToAbsent || rackId != null) {
      map['rack_id'] = Variable<String>(rackId);
    }
    map['qr_value'] = Variable<String>(qrValue);
    map['status'] = Variable<int>(status);
    map['print_count'] = Variable<int>(printCount);
    if (!nullToAbsent || lastPrintedAt != null) {
      map['last_printed_at'] = Variable<DateTime>(lastPrintedAt);
    }
    if (!nullToAbsent || lastPrintedBy != null) {
      map['last_printed_by'] = Variable<String>(lastPrintedBy);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
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
      rackId: rackId == null && nullToAbsent
          ? const Value.absent()
          : Value(rackId),
      qrValue: Value(qrValue),
      status: Value(status),
      printCount: Value(printCount),
      lastPrintedAt: lastPrintedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPrintedAt),
      lastPrintedBy: lastPrintedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPrintedBy),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      lastModifiedAt: Value(lastModifiedAt),
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
      rackId: serializer.fromJson<String?>(json['rackId']),
      qrValue: serializer.fromJson<String>(json['qrValue']),
      status: serializer.fromJson<int>(json['status']),
      printCount: serializer.fromJson<int>(json['printCount']),
      lastPrintedAt: serializer.fromJson<DateTime?>(json['lastPrintedAt']),
      lastPrintedBy: serializer.fromJson<String?>(json['lastPrintedBy']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
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
      'variantId': serializer.toJson<String?>(variantId),
      'componentId': serializer.toJson<String?>(componentId),
      'parentUnitId': serializer.toJson<String?>(parentUnitId),
      'rackId': serializer.toJson<String?>(rackId),
      'qrValue': serializer.toJson<String>(qrValue),
      'status': serializer.toJson<int>(status),
      'printCount': serializer.toJson<int>(printCount),
      'lastPrintedAt': serializer.toJson<DateTime?>(lastPrintedAt),
      'lastPrintedBy': serializer.toJson<String?>(lastPrintedBy),
      'createdBy': serializer.toJson<String?>(createdBy),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModifiedAt': serializer.toJson<DateTime>(lastModifiedAt),
      'needSync': serializer.toJson<bool>(needSync),
    };
  }

  Unit copyWith({
    String? id,
    Value<String?> variantId = const Value.absent(),
    Value<String?> componentId = const Value.absent(),
    Value<String?> parentUnitId = const Value.absent(),
    Value<String?> rackId = const Value.absent(),
    String? qrValue,
    int? status,
    int? printCount,
    Value<DateTime?> lastPrintedAt = const Value.absent(),
    Value<String?> lastPrintedBy = const Value.absent(),
    Value<String?> createdBy = const Value.absent(),
    Value<String?> updatedBy = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? lastModifiedAt,
    bool? needSync,
  }) => Unit(
    id: id ?? this.id,
    variantId: variantId.present ? variantId.value : this.variantId,
    componentId: componentId.present ? componentId.value : this.componentId,
    parentUnitId: parentUnitId.present ? parentUnitId.value : this.parentUnitId,
    rackId: rackId.present ? rackId.value : this.rackId,
    qrValue: qrValue ?? this.qrValue,
    status: status ?? this.status,
    printCount: printCount ?? this.printCount,
    lastPrintedAt: lastPrintedAt.present
        ? lastPrintedAt.value
        : this.lastPrintedAt,
    lastPrintedBy: lastPrintedBy.present
        ? lastPrintedBy.value
        : this.lastPrintedBy,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
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
      rackId: data.rackId.present ? data.rackId.value : this.rackId,
      qrValue: data.qrValue.present ? data.qrValue.value : this.qrValue,
      status: data.status.present ? data.status.value : this.status,
      printCount: data.printCount.present
          ? data.printCount.value
          : this.printCount,
      lastPrintedAt: data.lastPrintedAt.present
          ? data.lastPrintedAt.value
          : this.lastPrintedAt,
      lastPrintedBy: data.lastPrintedBy.present
          ? data.lastPrintedBy.value
          : this.lastPrintedBy,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
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
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('parentUnitId: $parentUnitId, ')
          ..write('rackId: $rackId, ')
          ..write('qrValue: $qrValue, ')
          ..write('status: $status, ')
          ..write('printCount: $printCount, ')
          ..write('lastPrintedAt: $lastPrintedAt, ')
          ..write('lastPrintedBy: $lastPrintedBy, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncedAt: $syncedAt, ')
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
    componentId,
    parentUnitId,
    rackId,
    qrValue,
    status,
    printCount,
    lastPrintedAt,
    lastPrintedBy,
    createdBy,
    updatedBy,
    syncedAt,
    createdAt,
    updatedAt,
    deletedAt,
    lastModifiedAt,
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
          other.rackId == this.rackId &&
          other.qrValue == this.qrValue &&
          other.status == this.status &&
          other.printCount == this.printCount &&
          other.lastPrintedAt == this.lastPrintedAt &&
          other.lastPrintedBy == this.lastPrintedBy &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModifiedAt == this.lastModifiedAt &&
          other.needSync == this.needSync);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<String> id;
  final Value<String?> variantId;
  final Value<String?> componentId;
  final Value<String?> parentUnitId;
  final Value<String?> rackId;
  final Value<String> qrValue;
  final Value<int> status;
  final Value<int> printCount;
  final Value<DateTime?> lastPrintedAt;
  final Value<String?> lastPrintedBy;
  final Value<String?> createdBy;
  final Value<String?> updatedBy;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> lastModifiedAt;
  final Value<bool> needSync;
  final Value<int> rowid;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.parentUnitId = const Value.absent(),
    this.rackId = const Value.absent(),
    this.qrValue = const Value.absent(),
    this.status = const Value.absent(),
    this.printCount = const Value.absent(),
    this.lastPrintedAt = const Value.absent(),
    this.lastPrintedBy = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnitsCompanion.insert({
    required String id,
    this.variantId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.parentUnitId = const Value.absent(),
    this.rackId = const Value.absent(),
    required String qrValue,
    this.status = const Value.absent(),
    this.printCount = const Value.absent(),
    this.lastPrintedAt = const Value.absent(),
    this.lastPrintedBy = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.lastModifiedAt = const Value.absent(),
    this.needSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       qrValue = Value(qrValue),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Unit> custom({
    Expression<String>? id,
    Expression<String>? variantId,
    Expression<String>? componentId,
    Expression<String>? parentUnitId,
    Expression<String>? rackId,
    Expression<String>? qrValue,
    Expression<int>? status,
    Expression<int>? printCount,
    Expression<DateTime>? lastPrintedAt,
    Expression<String>? lastPrintedBy,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<DateTime>? syncedAt,
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
      if (componentId != null) 'component_id': componentId,
      if (parentUnitId != null) 'parent_unit_id': parentUnitId,
      if (rackId != null) 'rack_id': rackId,
      if (qrValue != null) 'qr_value': qrValue,
      if (status != null) 'status': status,
      if (printCount != null) 'print_count': printCount,
      if (lastPrintedAt != null) 'last_printed_at': lastPrintedAt,
      if (lastPrintedBy != null) 'last_printed_by': lastPrintedBy,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt,
      if (needSync != null) 'need_sync': needSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnitsCompanion copyWith({
    Value<String>? id,
    Value<String?>? variantId,
    Value<String?>? componentId,
    Value<String?>? parentUnitId,
    Value<String?>? rackId,
    Value<String>? qrValue,
    Value<int>? status,
    Value<int>? printCount,
    Value<DateTime?>? lastPrintedAt,
    Value<String?>? lastPrintedBy,
    Value<String?>? createdBy,
    Value<String?>? updatedBy,
    Value<DateTime?>? syncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? lastModifiedAt,
    Value<bool>? needSync,
    Value<int>? rowid,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      componentId: componentId ?? this.componentId,
      parentUnitId: parentUnitId ?? this.parentUnitId,
      rackId: rackId ?? this.rackId,
      qrValue: qrValue ?? this.qrValue,
      status: status ?? this.status,
      printCount: printCount ?? this.printCount,
      lastPrintedAt: lastPrintedAt ?? this.lastPrintedAt,
      lastPrintedBy: lastPrintedBy ?? this.lastPrintedBy,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      syncedAt: syncedAt ?? this.syncedAt,
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
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (parentUnitId.present) {
      map['parent_unit_id'] = Variable<String>(parentUnitId.value);
    }
    if (rackId.present) {
      map['rack_id'] = Variable<String>(rackId.value);
    }
    if (qrValue.present) {
      map['qr_value'] = Variable<String>(qrValue.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (printCount.present) {
      map['print_count'] = Variable<int>(printCount.value);
    }
    if (lastPrintedAt.present) {
      map['last_printed_at'] = Variable<DateTime>(lastPrintedAt.value);
    }
    if (lastPrintedBy.present) {
      map['last_printed_by'] = Variable<String>(lastPrintedBy.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
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
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('componentId: $componentId, ')
          ..write('parentUnitId: $parentUnitId, ')
          ..write('rackId: $rackId, ')
          ..write('qrValue: $qrValue, ')
          ..write('status: $status, ')
          ..write('printCount: $printCount, ')
          ..write('lastPrintedAt: $lastPrintedAt, ')
          ..write('lastPrintedBy: $lastPrintedBy, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncedAt: $syncedAt, ')
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

class $DashboardItemsCacheTable extends DashboardItemsCache
    with TableInfo<$DashboardItemsCacheTable, DashboardItemsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardItemsCacheTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultRackNameMeta = const VerificationMeta(
    'defaultRackName',
  );
  @override
  late final GeneratedColumn<String> defaultRackName = GeneratedColumn<String>(
    'default_rack_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalUnitsMeta = const VerificationMeta(
    'totalUnits',
  );
  @override
  late final GeneratedColumn<int> totalUnits = GeneratedColumn<int>(
    'total_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalVariantsMeta = const VerificationMeta(
    'totalVariants',
  );
  @override
  late final GeneratedColumn<int> totalVariants = GeneratedColumn<int>(
    'total_variants',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _displayPriorityMeta = const VerificationMeta(
    'displayPriority',
  );
  @override
  late final GeneratedColumn<int> displayPriority = GeneratedColumn<int>(
    'display_priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    companyItemId,
    companyCode,
    productName,
    categoryName,
    defaultRackName,
    totalUnits,
    totalVariants,
    lastUpdatedAt,
    displayPriority,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_items_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<DashboardItemsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('default_rack_name')) {
      context.handle(
        _defaultRackNameMeta,
        defaultRackName.isAcceptableOrUnknown(
          data['default_rack_name']!,
          _defaultRackNameMeta,
        ),
      );
    }
    if (data.containsKey('total_units')) {
      context.handle(
        _totalUnitsMeta,
        totalUnits.isAcceptableOrUnknown(data['total_units']!, _totalUnitsMeta),
      );
    }
    if (data.containsKey('total_variants')) {
      context.handle(
        _totalVariantsMeta,
        totalVariants.isAcceptableOrUnknown(
          data['total_variants']!,
          _totalVariantsMeta,
        ),
      );
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('display_priority')) {
      context.handle(
        _displayPriorityMeta,
        displayPriority.isAcceptableOrUnknown(
          data['display_priority']!,
          _displayPriorityMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {companyItemId};
  @override
  DashboardItemsCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardItemsCacheData(
      companyItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_item_id'],
      )!,
      companyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_code'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      defaultRackName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_rack_name'],
      ),
      totalUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_units'],
      )!,
      totalVariants: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_variants'],
      )!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      displayPriority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_priority'],
      )!,
    );
  }

  @override
  $DashboardItemsCacheTable createAlias(String alias) {
    return $DashboardItemsCacheTable(attachedDatabase, alias);
  }
}

class DashboardItemsCacheData extends DataClass
    implements Insertable<DashboardItemsCacheData> {
  final String companyItemId;
  final String companyCode;
  final String productName;
  final String? categoryName;
  final String? defaultRackName;
  final int totalUnits;
  final int totalVariants;
  final DateTime lastUpdatedAt;
  final int displayPriority;
  const DashboardItemsCacheData({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    this.categoryName,
    this.defaultRackName,
    required this.totalUnits,
    required this.totalVariants,
    required this.lastUpdatedAt,
    required this.displayPriority,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['company_item_id'] = Variable<String>(companyItemId);
    map['company_code'] = Variable<String>(companyCode);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || defaultRackName != null) {
      map['default_rack_name'] = Variable<String>(defaultRackName);
    }
    map['total_units'] = Variable<int>(totalUnits);
    map['total_variants'] = Variable<int>(totalVariants);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    map['display_priority'] = Variable<int>(displayPriority);
    return map;
  }

  DashboardItemsCacheCompanion toCompanion(bool nullToAbsent) {
    return DashboardItemsCacheCompanion(
      companyItemId: Value(companyItemId),
      companyCode: Value(companyCode),
      productName: Value(productName),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      defaultRackName: defaultRackName == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultRackName),
      totalUnits: Value(totalUnits),
      totalVariants: Value(totalVariants),
      lastUpdatedAt: Value(lastUpdatedAt),
      displayPriority: Value(displayPriority),
    );
  }

  factory DashboardItemsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardItemsCacheData(
      companyItemId: serializer.fromJson<String>(json['companyItemId']),
      companyCode: serializer.fromJson<String>(json['companyCode']),
      productName: serializer.fromJson<String>(json['productName']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      defaultRackName: serializer.fromJson<String?>(json['defaultRackName']),
      totalUnits: serializer.fromJson<int>(json['totalUnits']),
      totalVariants: serializer.fromJson<int>(json['totalVariants']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      displayPriority: serializer.fromJson<int>(json['displayPriority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'companyItemId': serializer.toJson<String>(companyItemId),
      'companyCode': serializer.toJson<String>(companyCode),
      'productName': serializer.toJson<String>(productName),
      'categoryName': serializer.toJson<String?>(categoryName),
      'defaultRackName': serializer.toJson<String?>(defaultRackName),
      'totalUnits': serializer.toJson<int>(totalUnits),
      'totalVariants': serializer.toJson<int>(totalVariants),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'displayPriority': serializer.toJson<int>(displayPriority),
    };
  }

  DashboardItemsCacheData copyWith({
    String? companyItemId,
    String? companyCode,
    String? productName,
    Value<String?> categoryName = const Value.absent(),
    Value<String?> defaultRackName = const Value.absent(),
    int? totalUnits,
    int? totalVariants,
    DateTime? lastUpdatedAt,
    int? displayPriority,
  }) => DashboardItemsCacheData(
    companyItemId: companyItemId ?? this.companyItemId,
    companyCode: companyCode ?? this.companyCode,
    productName: productName ?? this.productName,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    defaultRackName: defaultRackName.present
        ? defaultRackName.value
        : this.defaultRackName,
    totalUnits: totalUnits ?? this.totalUnits,
    totalVariants: totalVariants ?? this.totalVariants,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    displayPriority: displayPriority ?? this.displayPriority,
  );
  DashboardItemsCacheData copyWithCompanion(DashboardItemsCacheCompanion data) {
    return DashboardItemsCacheData(
      companyItemId: data.companyItemId.present
          ? data.companyItemId.value
          : this.companyItemId,
      companyCode: data.companyCode.present
          ? data.companyCode.value
          : this.companyCode,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      defaultRackName: data.defaultRackName.present
          ? data.defaultRackName.value
          : this.defaultRackName,
      totalUnits: data.totalUnits.present
          ? data.totalUnits.value
          : this.totalUnits,
      totalVariants: data.totalVariants.present
          ? data.totalVariants.value
          : this.totalVariants,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      displayPriority: data.displayPriority.present
          ? data.displayPriority.value
          : this.displayPriority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardItemsCacheData(')
          ..write('companyItemId: $companyItemId, ')
          ..write('companyCode: $companyCode, ')
          ..write('productName: $productName, ')
          ..write('categoryName: $categoryName, ')
          ..write('defaultRackName: $defaultRackName, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('totalVariants: $totalVariants, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('displayPriority: $displayPriority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    companyItemId,
    companyCode,
    productName,
    categoryName,
    defaultRackName,
    totalUnits,
    totalVariants,
    lastUpdatedAt,
    displayPriority,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardItemsCacheData &&
          other.companyItemId == this.companyItemId &&
          other.companyCode == this.companyCode &&
          other.productName == this.productName &&
          other.categoryName == this.categoryName &&
          other.defaultRackName == this.defaultRackName &&
          other.totalUnits == this.totalUnits &&
          other.totalVariants == this.totalVariants &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.displayPriority == this.displayPriority);
}

class DashboardItemsCacheCompanion
    extends UpdateCompanion<DashboardItemsCacheData> {
  final Value<String> companyItemId;
  final Value<String> companyCode;
  final Value<String> productName;
  final Value<String?> categoryName;
  final Value<String?> defaultRackName;
  final Value<int> totalUnits;
  final Value<int> totalVariants;
  final Value<DateTime> lastUpdatedAt;
  final Value<int> displayPriority;
  final Value<int> rowid;
  const DashboardItemsCacheCompanion({
    this.companyItemId = const Value.absent(),
    this.companyCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.defaultRackName = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.totalVariants = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.displayPriority = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardItemsCacheCompanion.insert({
    required String companyItemId,
    required String companyCode,
    required String productName,
    this.categoryName = const Value.absent(),
    this.defaultRackName = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.totalVariants = const Value.absent(),
    required DateTime lastUpdatedAt,
    this.displayPriority = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyItemId = Value(companyItemId),
       companyCode = Value(companyCode),
       productName = Value(productName),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<DashboardItemsCacheData> custom({
    Expression<String>? companyItemId,
    Expression<String>? companyCode,
    Expression<String>? productName,
    Expression<String>? categoryName,
    Expression<String>? defaultRackName,
    Expression<int>? totalUnits,
    Expression<int>? totalVariants,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? displayPriority,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (companyItemId != null) 'company_item_id': companyItemId,
      if (companyCode != null) 'company_code': companyCode,
      if (productName != null) 'product_name': productName,
      if (categoryName != null) 'category_name': categoryName,
      if (defaultRackName != null) 'default_rack_name': defaultRackName,
      if (totalUnits != null) 'total_units': totalUnits,
      if (totalVariants != null) 'total_variants': totalVariants,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (displayPriority != null) 'display_priority': displayPriority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardItemsCacheCompanion copyWith({
    Value<String>? companyItemId,
    Value<String>? companyCode,
    Value<String>? productName,
    Value<String?>? categoryName,
    Value<String?>? defaultRackName,
    Value<int>? totalUnits,
    Value<int>? totalVariants,
    Value<DateTime>? lastUpdatedAt,
    Value<int>? displayPriority,
    Value<int>? rowid,
  }) {
    return DashboardItemsCacheCompanion(
      companyItemId: companyItemId ?? this.companyItemId,
      companyCode: companyCode ?? this.companyCode,
      productName: productName ?? this.productName,
      categoryName: categoryName ?? this.categoryName,
      defaultRackName: defaultRackName ?? this.defaultRackName,
      totalUnits: totalUnits ?? this.totalUnits,
      totalVariants: totalVariants ?? this.totalVariants,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      displayPriority: displayPriority ?? this.displayPriority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (companyItemId.present) {
      map['company_item_id'] = Variable<String>(companyItemId.value);
    }
    if (companyCode.present) {
      map['company_code'] = Variable<String>(companyCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (defaultRackName.present) {
      map['default_rack_name'] = Variable<String>(defaultRackName.value);
    }
    if (totalUnits.present) {
      map['total_units'] = Variable<int>(totalUnits.value);
    }
    if (totalVariants.present) {
      map['total_variants'] = Variable<int>(totalVariants.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (displayPriority.present) {
      map['display_priority'] = Variable<int>(displayPriority.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardItemsCacheCompanion(')
          ..write('companyItemId: $companyItemId, ')
          ..write('companyCode: $companyCode, ')
          ..write('productName: $productName, ')
          ..write('categoryName: $categoryName, ')
          ..write('defaultRackName: $defaultRackName, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('totalVariants: $totalVariants, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('displayPriority: $displayPriority, ')
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
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $SectionsTable sections = $SectionsTable(this);
  late final $WarehousesTable warehouses = $WarehousesTable(this);
  late final $SectionWarehousesTable sectionWarehouses =
      $SectionWarehousesTable(this);
  late final $RacksTable racks = $RacksTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CompanyItemsTable companyItems = $CompanyItemsTable(this);
  late final $VariantsTable variants = $VariantsTable(this);
  late final $VariantPhotosTable variantPhotos = $VariantPhotosTable(this);
  late final $ComponentsTable components = $ComponentsTable(this);
  late final $ComponentPhotosTable componentPhotos = $ComponentPhotosTable(
    this,
  );
  late final $VariantComponentsTable variantComponents =
      $VariantComponentsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $DashboardItemsCacheTable dashboardItemsCache =
      $DashboardItemsCacheTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final BrandDao brandDao = BrandDao(this as AppDatabase);
  late final RackDao rackDao = RackDao(this as AppDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  late final CompanyItemDao companyItemDao = CompanyItemDao(
    this as AppDatabase,
  );
  late final VariantDao variantDao = VariantDao(this as AppDatabase);
  late final VariantPhotoDao variantPhotoDao = VariantPhotoDao(
    this as AppDatabase,
  );
  late final ComponentDao componentDao = ComponentDao(this as AppDatabase);
  late final ComponentPhotoDao componentPhotoDao = ComponentPhotoDao(
    this as AppDatabase,
  );
  late final VariantComponentDao variantComponentDao = VariantComponentDao(
    this as AppDatabase,
  );
  late final UnitDao unitDao = UnitDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    departments,
    sections,
    warehouses,
    sectionWarehouses,
    racks,
    categories,
    brands,
    products,
    companyItems,
    variants,
    variantPhotos,
    components,
    componentPhotos,
    variantComponents,
    units,
    dashboardItemsCache,
    syncMetadata,
  ];
}

typedef $$DepartmentsTableCreateCompanionBuilder =
    DepartmentsCompanion Function({
      required String id,
      required String name,
      required String code,
      Value<int> rowid,
    });
typedef $$DepartmentsTableUpdateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> code,
      Value<int> rowid,
    });

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$DepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentsTable,
          Department,
          $$DepartmentsTableFilterComposer,
          $$DepartmentsTableOrderingComposer,
          $$DepartmentsTableAnnotationComposer,
          $$DepartmentsTableCreateCompanionBuilder,
          $$DepartmentsTableUpdateCompanionBuilder,
          (
            Department,
            BaseReferences<_$AppDatabase, $DepartmentsTable, Department>,
          ),
          Department,
          PrefetchHooks Function()
        > {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion(
                id: id,
                name: name,
                code: code,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String code,
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion.insert(
                id: id,
                name: name,
                code: code,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentsTable,
      Department,
      $$DepartmentsTableFilterComposer,
      $$DepartmentsTableOrderingComposer,
      $$DepartmentsTableAnnotationComposer,
      $$DepartmentsTableCreateCompanionBuilder,
      $$DepartmentsTableUpdateCompanionBuilder,
      (
        Department,
        BaseReferences<_$AppDatabase, $DepartmentsTable, Department>,
      ),
      Department,
      PrefetchHooks Function()
    >;
typedef $$SectionsTableCreateCompanionBuilder =
    SectionsCompanion Function({
      required String id,
      required String departmentId,
      required String departmentCode,
      required String name,
      required String code,
      Value<int> rowid,
    });
typedef $$SectionsTableUpdateCompanionBuilder =
    SectionsCompanion Function({
      Value<String> id,
      Value<String> departmentId,
      Value<String> departmentCode,
      Value<String> name,
      Value<String> code,
      Value<int> rowid,
    });

class $$SectionsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableFilterComposer({
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

  ColumnFilters<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departmentCode => $composableBuilder(
    column: $table.departmentCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableOrderingComposer({
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

  ColumnOrderings<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departmentCode => $composableBuilder(
    column: $table.departmentCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionsTable> {
  $$SectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departmentCode => $composableBuilder(
    column: $table.departmentCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$SectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionsTable,
          Section,
          $$SectionsTableFilterComposer,
          $$SectionsTableOrderingComposer,
          $$SectionsTableAnnotationComposer,
          $$SectionsTableCreateCompanionBuilder,
          $$SectionsTableUpdateCompanionBuilder,
          (Section, BaseReferences<_$AppDatabase, $SectionsTable, Section>),
          Section,
          PrefetchHooks Function()
        > {
  $$SectionsTableTableManager(_$AppDatabase db, $SectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> departmentCode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion(
                id: id,
                departmentId: departmentId,
                departmentCode: departmentCode,
                name: name,
                code: code,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String departmentId,
                required String departmentCode,
                required String name,
                required String code,
                Value<int> rowid = const Value.absent(),
              }) => SectionsCompanion.insert(
                id: id,
                departmentId: departmentId,
                departmentCode: departmentCode,
                name: name,
                code: code,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionsTable,
      Section,
      $$SectionsTableFilterComposer,
      $$SectionsTableOrderingComposer,
      $$SectionsTableAnnotationComposer,
      $$SectionsTableCreateCompanionBuilder,
      $$SectionsTableUpdateCompanionBuilder,
      (Section, BaseReferences<_$AppDatabase, $SectionsTable, Section>),
      Section,
      PrefetchHooks Function()
    >;
typedef $$WarehousesTableCreateCompanionBuilder =
    WarehousesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$WarehousesTableUpdateCompanionBuilder =
    WarehousesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$WarehousesTableFilterComposer
    extends Composer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableFilterComposer({
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

class $$WarehousesTableOrderingComposer
    extends Composer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableOrderingComposer({
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

class $$WarehousesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableAnnotationComposer({
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

class $$WarehousesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WarehousesTable,
          Warehouse,
          $$WarehousesTableFilterComposer,
          $$WarehousesTableOrderingComposer,
          $$WarehousesTableAnnotationComposer,
          $$WarehousesTableCreateCompanionBuilder,
          $$WarehousesTableUpdateCompanionBuilder,
          (
            Warehouse,
            BaseReferences<_$AppDatabase, $WarehousesTable, Warehouse>,
          ),
          Warehouse,
          PrefetchHooks Function()
        > {
  $$WarehousesTableTableManager(_$AppDatabase db, $WarehousesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WarehousesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WarehousesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WarehousesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WarehousesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) =>
                  WarehousesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WarehousesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WarehousesTable,
      Warehouse,
      $$WarehousesTableFilterComposer,
      $$WarehousesTableOrderingComposer,
      $$WarehousesTableAnnotationComposer,
      $$WarehousesTableCreateCompanionBuilder,
      $$WarehousesTableUpdateCompanionBuilder,
      (Warehouse, BaseReferences<_$AppDatabase, $WarehousesTable, Warehouse>),
      Warehouse,
      PrefetchHooks Function()
    >;
typedef $$SectionWarehousesTableCreateCompanionBuilder =
    SectionWarehousesCompanion Function({
      required String id,
      required String sectionId,
      required String warehouseId,
      Value<int> rowid,
    });
typedef $$SectionWarehousesTableUpdateCompanionBuilder =
    SectionWarehousesCompanion Function({
      Value<String> id,
      Value<String> sectionId,
      Value<String> warehouseId,
      Value<int> rowid,
    });

class $$SectionWarehousesTableFilterComposer
    extends Composer<_$AppDatabase, $SectionWarehousesTable> {
  $$SectionWarehousesTableFilterComposer({
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

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SectionWarehousesTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionWarehousesTable> {
  $$SectionWarehousesTableOrderingComposer({
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

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SectionWarehousesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionWarehousesTable> {
  $$SectionWarehousesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => column,
  );
}

class $$SectionWarehousesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionWarehousesTable,
          SectionWarehouse,
          $$SectionWarehousesTableFilterComposer,
          $$SectionWarehousesTableOrderingComposer,
          $$SectionWarehousesTableAnnotationComposer,
          $$SectionWarehousesTableCreateCompanionBuilder,
          $$SectionWarehousesTableUpdateCompanionBuilder,
          (
            SectionWarehouse,
            BaseReferences<
              _$AppDatabase,
              $SectionWarehousesTable,
              SectionWarehouse
            >,
          ),
          SectionWarehouse,
          PrefetchHooks Function()
        > {
  $$SectionWarehousesTableTableManager(
    _$AppDatabase db,
    $SectionWarehousesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionWarehousesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionWarehousesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionWarehousesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sectionId = const Value.absent(),
                Value<String> warehouseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionWarehousesCompanion(
                id: id,
                sectionId: sectionId,
                warehouseId: warehouseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sectionId,
                required String warehouseId,
                Value<int> rowid = const Value.absent(),
              }) => SectionWarehousesCompanion.insert(
                id: id,
                sectionId: sectionId,
                warehouseId: warehouseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SectionWarehousesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionWarehousesTable,
      SectionWarehouse,
      $$SectionWarehousesTableFilterComposer,
      $$SectionWarehousesTableOrderingComposer,
      $$SectionWarehousesTableAnnotationComposer,
      $$SectionWarehousesTableCreateCompanionBuilder,
      $$SectionWarehousesTableUpdateCompanionBuilder,
      (
        SectionWarehouse,
        BaseReferences<
          _$AppDatabase,
          $SectionWarehousesTable,
          SectionWarehouse
        >,
      ),
      SectionWarehouse,
      PrefetchHooks Function()
    >;
typedef $$RacksTableCreateCompanionBuilder =
    RacksCompanion Function({
      required String id,
      required String name,
      required String warehouseId,
      Value<int> rowid,
    });
typedef $$RacksTableUpdateCompanionBuilder =
    RacksCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> warehouseId,
      Value<int> rowid,
    });

class $$RacksTableFilterComposer extends Composer<_$AppDatabase, $RacksTable> {
  $$RacksTableFilterComposer({
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

  ColumnFilters<String> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RacksTableOrderingComposer
    extends Composer<_$AppDatabase, $RacksTable> {
  $$RacksTableOrderingComposer({
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

  ColumnOrderings<String> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RacksTable> {
  $$RacksTableAnnotationComposer({
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

  GeneratedColumn<String> get warehouseId => $composableBuilder(
    column: $table.warehouseId,
    builder: (column) => column,
  );
}

class $$RacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RacksTable,
          Rack,
          $$RacksTableFilterComposer,
          $$RacksTableOrderingComposer,
          $$RacksTableAnnotationComposer,
          $$RacksTableCreateCompanionBuilder,
          $$RacksTableUpdateCompanionBuilder,
          (Rack, BaseReferences<_$AppDatabase, $RacksTable, Rack>),
          Rack,
          PrefetchHooks Function()
        > {
  $$RacksTableTableManager(_$AppDatabase db, $RacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> warehouseId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RacksCompanion(
                id: id,
                name: name,
                warehouseId: warehouseId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String warehouseId,
                Value<int> rowid = const Value.absent(),
              }) => RacksCompanion.insert(
                id: id,
                name: name,
                warehouseId: warehouseId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RacksTable,
      Rack,
      $$RacksTableFilterComposer,
      $$RacksTableOrderingComposer,
      $$RacksTableAnnotationComposer,
      $$RacksTableCreateCompanionBuilder,
      $$RacksTableUpdateCompanionBuilder,
      (Rack, BaseReferences<_$AppDatabase, $RacksTable, Rack>),
      Rack,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      required String code,
      Value<String?> categoryParentId,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> code,
      Value<String?> categoryParentId,
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryParentId => $composableBuilder(
    column: $table.categoryParentId,
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryParentId => $composableBuilder(
    column: $table.categoryParentId,
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

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get categoryParentId => $composableBuilder(
    column: $table.categoryParentId,
    builder: (column) => column,
  );
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
                Value<String> code = const Value.absent(),
                Value<String?> categoryParentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                code: code,
                categoryParentId: categoryParentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String code,
                Value<String?> categoryParentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                code: code,
                categoryParentId: categoryParentId,
                rowid: rowid,
              ),
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
      Value<DateTime> lastModifiedAt,
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
                Value<DateTime> lastModifiedAt = const Value.absent(),
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
      Value<String?> description,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

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
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                description: description,
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
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                description: description,
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
      Value<String?> defaultRackId,
      required String productId,
      Value<String?> categoryId,
      required String companyCode,
      Value<String?> machinePurchase,
      Value<String?> specification,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$CompanyItemsTableUpdateCompanionBuilder =
    CompanyItemsCompanion Function({
      Value<String> id,
      Value<String?> defaultRackId,
      Value<String> productId,
      Value<String?> categoryId,
      Value<String> companyCode,
      Value<String?> machinePurchase,
      Value<String?> specification,
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

  ColumnFilters<String> get defaultRackId => $composableBuilder(
    column: $table.defaultRackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machinePurchase => $composableBuilder(
    column: $table.machinePurchase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specification => $composableBuilder(
    column: $table.specification,
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

  ColumnOrderings<String> get defaultRackId => $composableBuilder(
    column: $table.defaultRackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machinePurchase => $composableBuilder(
    column: $table.machinePurchase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specification => $composableBuilder(
    column: $table.specification,
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

  GeneratedColumn<String> get defaultRackId => $composableBuilder(
    column: $table.defaultRackId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get machinePurchase => $composableBuilder(
    column: $table.machinePurchase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get specification => $composableBuilder(
    column: $table.specification,
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
                Value<String?> defaultRackId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> companyCode = const Value.absent(),
                Value<String?> machinePurchase = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompanyItemsCompanion(
                id: id,
                defaultRackId: defaultRackId,
                productId: productId,
                categoryId: categoryId,
                companyCode: companyCode,
                machinePurchase: machinePurchase,
                specification: specification,
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
                Value<String?> defaultRackId = const Value.absent(),
                required String productId,
                Value<String?> categoryId = const Value.absent(),
                required String companyCode,
                Value<String?> machinePurchase = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompanyItemsCompanion.insert(
                id: id,
                defaultRackId: defaultRackId,
                productId: productId,
                categoryId: categoryId,
                companyCode: companyCode,
                machinePurchase: machinePurchase,
                specification: specification,
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
      Value<String?> rackId,
      Value<String?> brandId,
      required String name,
      required String uom,
      Value<String?> manufCode,
      Value<String?> specification,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$VariantsTableUpdateCompanionBuilder =
    VariantsCompanion Function({
      Value<String> id,
      Value<String> companyItemId,
      Value<String?> rackId,
      Value<String?> brandId,
      Value<String> name,
      Value<String> uom,
      Value<String?> manufCode,
      Value<String?> specification,
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

  ColumnFilters<String> get rackId => $composableBuilder(
    column: $table.rackId,
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

  ColumnFilters<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufCode => $composableBuilder(
    column: $table.manufCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specification => $composableBuilder(
    column: $table.specification,
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

  ColumnOrderings<String> get rackId => $composableBuilder(
    column: $table.rackId,
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

  ColumnOrderings<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufCode => $composableBuilder(
    column: $table.manufCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specification => $composableBuilder(
    column: $table.specification,
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

  GeneratedColumn<String> get rackId =>
      $composableBuilder(column: $table.rackId, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<String> get manufCode =>
      $composableBuilder(column: $table.manufCode, builder: (column) => column);

  GeneratedColumn<String> get specification => $composableBuilder(
    column: $table.specification,
    builder: (column) => column,
  );

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
                Value<String?> rackId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> uom = const Value.absent(),
                Value<String?> manufCode = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantsCompanion(
                id: id,
                companyItemId: companyItemId,
                rackId: rackId,
                brandId: brandId,
                name: name,
                uom: uom,
                manufCode: manufCode,
                specification: specification,
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
                Value<String?> rackId = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                required String name,
                required String uom,
                Value<String?> manufCode = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantsCompanion.insert(
                id: id,
                companyItemId: companyItemId,
                rackId: rackId,
                brandId: brandId,
                name: name,
                uom: uom,
                manufCode: manufCode,
                specification: specification,
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
      Value<String?> localPath,
      Value<String?> remoteUrl,
      Value<int> sortOrder,
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
      Value<String?> localPath,
      Value<String?> remoteUrl,
      Value<int> sortOrder,
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

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
                Value<String?> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
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
                sortOrder: sortOrder,
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
                Value<String?> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
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
                sortOrder: sortOrder,
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
      Value<int> type,
      Value<String?> brandId,
      Value<String?> manufCode,
      Value<String?> specification,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$ComponentsTableUpdateCompanionBuilder =
    ComponentsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> name,
      Value<int> type,
      Value<String?> brandId,
      Value<String?> manufCode,
      Value<String?> specification,
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

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
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

  ColumnFilters<String> get specification => $composableBuilder(
    column: $table.specification,
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

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
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

  ColumnOrderings<String> get specification => $composableBuilder(
    column: $table.specification,
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

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get manufCode =>
      $composableBuilder(column: $table.manufCode, builder: (column) => column);

  GeneratedColumn<String> get specification => $composableBuilder(
    column: $table.specification,
    builder: (column) => column,
  );

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
                Value<int> type = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> manufCode = const Value.absent(),
                Value<String?> specification = const Value.absent(),
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
                type: type,
                brandId: brandId,
                manufCode: manufCode,
                specification: specification,
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
                Value<int> type = const Value.absent(),
                Value<String?> brandId = const Value.absent(),
                Value<String?> manufCode = const Value.absent(),
                Value<String?> specification = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                type: type,
                brandId: brandId,
                manufCode: manufCode,
                specification: specification,
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
typedef $$ComponentPhotosTableCreateCompanionBuilder =
    ComponentPhotosCompanion Function({
      required String id,
      required String componentId,
      Value<String?> localPath,
      Value<String?> remoteUrl,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$ComponentPhotosTableUpdateCompanionBuilder =
    ComponentPhotosCompanion Function({
      Value<String> id,
      Value<String> componentId,
      Value<String?> localPath,
      Value<String?> remoteUrl,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });

class $$ComponentPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentPhotosTable> {
  $$ComponentPhotosTableFilterComposer({
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

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

class $$ComponentPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentPhotosTable> {
  $$ComponentPhotosTableOrderingComposer({
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

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

class $$ComponentPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentPhotosTable> {
  $$ComponentPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remoteUrl =>
      $composableBuilder(column: $table.remoteUrl, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

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

class $$ComponentPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComponentPhotosTable,
          ComponentPhoto,
          $$ComponentPhotosTableFilterComposer,
          $$ComponentPhotosTableOrderingComposer,
          $$ComponentPhotosTableAnnotationComposer,
          $$ComponentPhotosTableCreateCompanionBuilder,
          $$ComponentPhotosTableUpdateCompanionBuilder,
          (
            ComponentPhoto,
            BaseReferences<
              _$AppDatabase,
              $ComponentPhotosTable,
              ComponentPhoto
            >,
          ),
          ComponentPhoto,
          PrefetchHooks Function()
        > {
  $$ComponentPhotosTableTableManager(
    _$AppDatabase db,
    $ComponentPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentPhotosCompanion(
                id: id,
                componentId: componentId,
                localPath: localPath,
                remoteUrl: remoteUrl,
                sortOrder: sortOrder,
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
                required String componentId,
                Value<String?> localPath = const Value.absent(),
                Value<String?> remoteUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentPhotosCompanion.insert(
                id: id,
                componentId: componentId,
                localPath: localPath,
                remoteUrl: remoteUrl,
                sortOrder: sortOrder,
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

typedef $$ComponentPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComponentPhotosTable,
      ComponentPhoto,
      $$ComponentPhotosTableFilterComposer,
      $$ComponentPhotosTableOrderingComposer,
      $$ComponentPhotosTableAnnotationComposer,
      $$ComponentPhotosTableCreateCompanionBuilder,
      $$ComponentPhotosTableUpdateCompanionBuilder,
      (
        ComponentPhoto,
        BaseReferences<_$AppDatabase, $ComponentPhotosTable, ComponentPhoto>,
      ),
      ComponentPhoto,
      PrefetchHooks Function()
    >;
typedef $$VariantComponentsTableCreateCompanionBuilder =
    VariantComponentsCompanion Function({
      required String id,
      required String variantId,
      required String componentId,
      Value<int> quantityNeeded,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$VariantComponentsTableUpdateCompanionBuilder =
    VariantComponentsCompanion Function({
      Value<String> id,
      Value<String> variantId,
      Value<String> componentId,
      Value<int> quantityNeeded,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
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

  ColumnFilters<int> get quantityNeeded => $composableBuilder(
    column: $table.quantityNeeded,
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

  ColumnOrderings<int> get quantityNeeded => $composableBuilder(
    column: $table.quantityNeeded,
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

  GeneratedColumn<int> get quantityNeeded => $composableBuilder(
    column: $table.quantityNeeded,
    builder: (column) => column,
  );

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
                Value<int> quantityNeeded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantComponentsCompanion(
                id: id,
                variantId: variantId,
                componentId: componentId,
                quantityNeeded: quantityNeeded,
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
                required String componentId,
                Value<int> quantityNeeded = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantComponentsCompanion.insert(
                id: id,
                variantId: variantId,
                componentId: componentId,
                quantityNeeded: quantityNeeded,
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
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      required String id,
      Value<String?> variantId,
      Value<String?> componentId,
      Value<String?> parentUnitId,
      Value<String?> rackId,
      required String qrValue,
      Value<int> status,
      Value<int> printCount,
      Value<DateTime?> lastPrintedAt,
      Value<String?> lastPrintedBy,
      Value<String?> createdBy,
      Value<String?> updatedBy,
      Value<DateTime?> syncedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
      Value<bool> needSync,
      Value<int> rowid,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<String> id,
      Value<String?> variantId,
      Value<String?> componentId,
      Value<String?> parentUnitId,
      Value<String?> rackId,
      Value<String> qrValue,
      Value<int> status,
      Value<int> printCount,
      Value<DateTime?> lastPrintedAt,
      Value<String?> lastPrintedBy,
      Value<String?> createdBy,
      Value<String?> updatedBy,
      Value<DateTime?> syncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> lastModifiedAt,
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

  ColumnFilters<String> get rackId => $composableBuilder(
    column: $table.rackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrValue => $composableBuilder(
    column: $table.qrValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
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

  ColumnFilters<String> get lastPrintedBy => $composableBuilder(
    column: $table.lastPrintedBy,
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

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
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

  ColumnOrderings<String> get rackId => $composableBuilder(
    column: $table.rackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrValue => $composableBuilder(
    column: $table.qrValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<String> get lastPrintedBy => $composableBuilder(
    column: $table.lastPrintedBy,
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

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
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

  GeneratedColumn<String> get rackId =>
      $composableBuilder(column: $table.rackId, builder: (column) => column);

  GeneratedColumn<String> get qrValue =>
      $composableBuilder(column: $table.qrValue, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get printCount => $composableBuilder(
    column: $table.printCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastPrintedBy => $composableBuilder(
    column: $table.lastPrintedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

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
                Value<String?> rackId = const Value.absent(),
                Value<String> qrValue = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> printCount = const Value.absent(),
                Value<DateTime?> lastPrintedAt = const Value.absent(),
                Value<String?> lastPrintedBy = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                variantId: variantId,
                componentId: componentId,
                parentUnitId: parentUnitId,
                rackId: rackId,
                qrValue: qrValue,
                status: status,
                printCount: printCount,
                lastPrintedAt: lastPrintedAt,
                lastPrintedBy: lastPrintedBy,
                createdBy: createdBy,
                updatedBy: updatedBy,
                syncedAt: syncedAt,
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
                Value<String?> variantId = const Value.absent(),
                Value<String?> componentId = const Value.absent(),
                Value<String?> parentUnitId = const Value.absent(),
                Value<String?> rackId = const Value.absent(),
                required String qrValue,
                Value<int> status = const Value.absent(),
                Value<int> printCount = const Value.absent(),
                Value<DateTime?> lastPrintedAt = const Value.absent(),
                Value<String?> lastPrintedBy = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> lastModifiedAt = const Value.absent(),
                Value<bool> needSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                variantId: variantId,
                componentId: componentId,
                parentUnitId: parentUnitId,
                rackId: rackId,
                qrValue: qrValue,
                status: status,
                printCount: printCount,
                lastPrintedAt: lastPrintedAt,
                lastPrintedBy: lastPrintedBy,
                createdBy: createdBy,
                updatedBy: updatedBy,
                syncedAt: syncedAt,
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
typedef $$DashboardItemsCacheTableCreateCompanionBuilder =
    DashboardItemsCacheCompanion Function({
      required String companyItemId,
      required String companyCode,
      required String productName,
      Value<String?> categoryName,
      Value<String?> defaultRackName,
      Value<int> totalUnits,
      Value<int> totalVariants,
      required DateTime lastUpdatedAt,
      Value<int> displayPriority,
      Value<int> rowid,
    });
typedef $$DashboardItemsCacheTableUpdateCompanionBuilder =
    DashboardItemsCacheCompanion Function({
      Value<String> companyItemId,
      Value<String> companyCode,
      Value<String> productName,
      Value<String?> categoryName,
      Value<String?> defaultRackName,
      Value<int> totalUnits,
      Value<int> totalVariants,
      Value<DateTime> lastUpdatedAt,
      Value<int> displayPriority,
      Value<int> rowid,
    });

class $$DashboardItemsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardItemsCacheTable> {
  $$DashboardItemsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultRackName => $composableBuilder(
    column: $table.defaultRackName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVariants => $composableBuilder(
    column: $table.totalVariants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayPriority => $composableBuilder(
    column: $table.displayPriority,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DashboardItemsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardItemsCacheTable> {
  $$DashboardItemsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultRackName => $composableBuilder(
    column: $table.defaultRackName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVariants => $composableBuilder(
    column: $table.totalVariants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayPriority => $composableBuilder(
    column: $table.displayPriority,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DashboardItemsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardItemsCacheTable> {
  $$DashboardItemsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get companyItemId => $composableBuilder(
    column: $table.companyItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyCode => $composableBuilder(
    column: $table.companyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultRackName => $composableBuilder(
    column: $table.defaultRackName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVariants => $composableBuilder(
    column: $table.totalVariants,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayPriority => $composableBuilder(
    column: $table.displayPriority,
    builder: (column) => column,
  );
}

class $$DashboardItemsCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardItemsCacheTable,
          DashboardItemsCacheData,
          $$DashboardItemsCacheTableFilterComposer,
          $$DashboardItemsCacheTableOrderingComposer,
          $$DashboardItemsCacheTableAnnotationComposer,
          $$DashboardItemsCacheTableCreateCompanionBuilder,
          $$DashboardItemsCacheTableUpdateCompanionBuilder,
          (
            DashboardItemsCacheData,
            BaseReferences<
              _$AppDatabase,
              $DashboardItemsCacheTable,
              DashboardItemsCacheData
            >,
          ),
          DashboardItemsCacheData,
          PrefetchHooks Function()
        > {
  $$DashboardItemsCacheTableTableManager(
    _$AppDatabase db,
    $DashboardItemsCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardItemsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DashboardItemsCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DashboardItemsCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> companyItemId = const Value.absent(),
                Value<String> companyCode = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> defaultRackName = const Value.absent(),
                Value<int> totalUnits = const Value.absent(),
                Value<int> totalVariants = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<int> displayPriority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardItemsCacheCompanion(
                companyItemId: companyItemId,
                companyCode: companyCode,
                productName: productName,
                categoryName: categoryName,
                defaultRackName: defaultRackName,
                totalUnits: totalUnits,
                totalVariants: totalVariants,
                lastUpdatedAt: lastUpdatedAt,
                displayPriority: displayPriority,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String companyItemId,
                required String companyCode,
                required String productName,
                Value<String?> categoryName = const Value.absent(),
                Value<String?> defaultRackName = const Value.absent(),
                Value<int> totalUnits = const Value.absent(),
                Value<int> totalVariants = const Value.absent(),
                required DateTime lastUpdatedAt,
                Value<int> displayPriority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DashboardItemsCacheCompanion.insert(
                companyItemId: companyItemId,
                companyCode: companyCode,
                productName: productName,
                categoryName: categoryName,
                defaultRackName: defaultRackName,
                totalUnits: totalUnits,
                totalVariants: totalVariants,
                lastUpdatedAt: lastUpdatedAt,
                displayPriority: displayPriority,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardItemsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardItemsCacheTable,
      DashboardItemsCacheData,
      $$DashboardItemsCacheTableFilterComposer,
      $$DashboardItemsCacheTableOrderingComposer,
      $$DashboardItemsCacheTableAnnotationComposer,
      $$DashboardItemsCacheTableCreateCompanionBuilder,
      $$DashboardItemsCacheTableUpdateCompanionBuilder,
      (
        DashboardItemsCacheData,
        BaseReferences<
          _$AppDatabase,
          $DashboardItemsCacheTable,
          DashboardItemsCacheData
        >,
      ),
      DashboardItemsCacheData,
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
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$SectionsTableTableManager get sections =>
      $$SectionsTableTableManager(_db, _db.sections);
  $$WarehousesTableTableManager get warehouses =>
      $$WarehousesTableTableManager(_db, _db.warehouses);
  $$SectionWarehousesTableTableManager get sectionWarehouses =>
      $$SectionWarehousesTableTableManager(_db, _db.sectionWarehouses);
  $$RacksTableTableManager get racks =>
      $$RacksTableTableManager(_db, _db.racks);
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
  $$ComponentPhotosTableTableManager get componentPhotos =>
      $$ComponentPhotosTableTableManager(_db, _db.componentPhotos);
  $$VariantComponentsTableTableManager get variantComponents =>
      $$VariantComponentsTableTableManager(_db, _db.variantComponents);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$DashboardItemsCacheTableTableManager get dashboardItemsCache =>
      $$DashboardItemsCacheTableTableManager(_db, _db.dashboardItemsCache);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
