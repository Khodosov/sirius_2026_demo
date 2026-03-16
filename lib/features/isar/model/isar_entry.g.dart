// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarEntryCollection on Isar {
  IsarCollection<IsarEntry> get isarEntrys => this.collection();
}

const IsarEntrySchema = CollectionSchema(
  name: r'IsarEntry',
  id: -5874933647762898511,
  properties: {
    r'numberValue': PropertySchema(
      id: 0,
      name: r'numberValue',
      type: IsarType.long,
    ),
    r'stringValue': PropertySchema(
      id: 1,
      name: r'stringValue',
      type: IsarType.string,
    )
  },
  estimateSize: _isarEntryEstimateSize,
  serialize: _isarEntrySerialize,
  deserialize: _isarEntryDeserialize,
  deserializeProp: _isarEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarEntryGetId,
  getLinks: _isarEntryGetLinks,
  attach: _isarEntryAttach,
  version: '3.1.0+1',
);

int _isarEntryEstimateSize(
  IsarEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.stringValue.length * 3;
  return bytesCount;
}

void _isarEntrySerialize(
  IsarEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.numberValue);
  writer.writeString(offsets[1], object.stringValue);
}

IsarEntry _isarEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarEntry();
  object.id = id;
  object.numberValue = reader.readLong(offsets[0]);
  object.stringValue = reader.readString(offsets[1]);
  return object;
}

P _isarEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarEntryGetId(IsarEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarEntryGetLinks(IsarEntry object) {
  return [];
}

void _isarEntryAttach(IsarCollection<dynamic> col, Id id, IsarEntry object) {
  object.id = id;
}

extension IsarEntryQueryWhereSort
    on QueryBuilder<IsarEntry, IsarEntry, QWhere> {
  QueryBuilder<IsarEntry, IsarEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarEntryQueryWhere
    on QueryBuilder<IsarEntry, IsarEntry, QWhereClause> {
  QueryBuilder<IsarEntry, IsarEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarEntryQueryFilter
    on QueryBuilder<IsarEntry, IsarEntry, QFilterCondition> {
  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> numberValueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition>
      numberValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> numberValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> numberValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> stringValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition>
      stringValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> stringValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> stringValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stringValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition>
      stringValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> stringValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> stringValueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition> stringValueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stringValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition>
      stringValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringValue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterFilterCondition>
      stringValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stringValue',
        value: '',
      ));
    });
  }
}

extension IsarEntryQueryObject
    on QueryBuilder<IsarEntry, IsarEntry, QFilterCondition> {}

extension IsarEntryQueryLinks
    on QueryBuilder<IsarEntry, IsarEntry, QFilterCondition> {}

extension IsarEntryQuerySortBy on QueryBuilder<IsarEntry, IsarEntry, QSortBy> {
  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> sortByNumberValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberValue', Sort.asc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> sortByNumberValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberValue', Sort.desc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> sortByStringValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.asc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> sortByStringValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.desc);
    });
  }
}

extension IsarEntryQuerySortThenBy
    on QueryBuilder<IsarEntry, IsarEntry, QSortThenBy> {
  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> thenByNumberValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberValue', Sort.asc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> thenByNumberValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberValue', Sort.desc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> thenByStringValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.asc);
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QAfterSortBy> thenByStringValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.desc);
    });
  }
}

extension IsarEntryQueryWhereDistinct
    on QueryBuilder<IsarEntry, IsarEntry, QDistinct> {
  QueryBuilder<IsarEntry, IsarEntry, QDistinct> distinctByNumberValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberValue');
    });
  }

  QueryBuilder<IsarEntry, IsarEntry, QDistinct> distinctByStringValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stringValue', caseSensitive: caseSensitive);
    });
  }
}

extension IsarEntryQueryProperty
    on QueryBuilder<IsarEntry, IsarEntry, QQueryProperty> {
  QueryBuilder<IsarEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarEntry, int, QQueryOperations> numberValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberValue');
    });
  }

  QueryBuilder<IsarEntry, String, QQueryOperations> stringValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stringValue');
    });
  }
}
