/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Companies type in your schema. */
@immutable
class Companies extends Model {
  static const classType = const _CompaniesModelType();
  final String id;
  final String? _Name;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Name {
    return _Name;
  }
  
  const Companies._internal({required this.id, Name}): _Name = Name;
  
  factory Companies({String? id, String? Name}) {
    return Companies._internal(
      id: id == null ? UUID.getUUID() : id,
      Name: Name);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Companies &&
      id == other.id &&
      _Name == other._Name;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Companies {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Name=" + "$_Name");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Companies copyWith({String? id, String? Name}) {
    return Companies(
      id: id ?? this.id,
      Name: Name ?? this.Name);
  }
  
  Companies.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Name = json['Name'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Name': _Name
  };

  static final QueryField ID = QueryField(fieldName: "companies.id");
  static final QueryField NAME = QueryField(fieldName: "Name");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Companies";
    modelSchemaDefinition.pluralName = "Companies";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Companies.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CompaniesModelType extends ModelType<Companies> {
  const _CompaniesModelType();
  
  @override
  Companies fromJson(Map<String, dynamic> jsonData) {
    return Companies.fromJson(jsonData);
  }
}