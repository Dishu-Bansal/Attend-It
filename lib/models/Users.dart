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

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Users type in your schema. */
@immutable
class Users extends Model {
  static const classType = const _UsersModelType();
  final String id;
  final String? _Name;
  final String? _PhoneNumber;
  final String? _Username;
  final String? _UserID;
  final String? _Email;
  final String? _Company;
  final AccessLevel? _Access;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Name {
    return _Name;
  }
  
  String? get PhoneNumber {
    return _PhoneNumber;
  }
  
  String? get Username {
    return _Username;
  }
  
  String? get UserID {
    return _UserID;
  }
  
  String? get Email {
    return _Email;
  }
  
  String? get Company {
    return _Company;
  }
  
  AccessLevel? get Access {
    return _Access;
  }
  
  const Users._internal({required this.id, Name, PhoneNumber, Username, UserID, Email, Company, Access}): _Name = Name, _PhoneNumber = PhoneNumber, _Username = Username, _UserID = UserID, _Email = Email, _Company = Company, _Access = Access;
  
  factory Users({String? id, String? Name, String? PhoneNumber, String? Username, String? UserID, String? Email, String? Company, AccessLevel? Access}) {
    return Users._internal(
      id: id == null ? UUID.getUUID() : id,
      Name: Name,
      PhoneNumber: PhoneNumber,
      Username: Username,
      UserID: UserID,
      Email: Email,
      Company: Company,
      Access: Access);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Users &&
      id == other.id &&
      _Name == other._Name &&
      _PhoneNumber == other._PhoneNumber &&
      _Username == other._Username &&
      _UserID == other._UserID &&
      _Email == other._Email &&
      _Company == other._Company &&
      _Access == other._Access;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Users {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Name=" + "$_Name" + ", ");
    buffer.write("PhoneNumber=" + "$_PhoneNumber" + ", ");
    buffer.write("Username=" + "$_Username" + ", ");
    buffer.write("UserID=" + "$_UserID" + ", ");
    buffer.write("Email=" + "$_Email" + ", ");
    buffer.write("Company=" + "$_Company" + ", ");
    buffer.write("Access=" + (_Access != null ? enumToString(_Access)! : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Users copyWith({String? id, String? Name, String? PhoneNumber, String? Username, String? UserID, String? Email, String? Company, AccessLevel? Access}) {
    return Users(
      id: id ?? this.id,
      Name: Name ?? this.Name,
      PhoneNumber: PhoneNumber ?? this.PhoneNumber,
      Username: Username ?? this.Username,
      UserID: UserID ?? this.UserID,
      Email: Email ?? this.Email,
      Company: Company ?? this.Company,
      Access: Access ?? this.Access);
  }
  
  Users.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Name = json['Name'],
      _PhoneNumber = json['PhoneNumber'],
      _Username = json['Username'],
      _UserID = json['UserID'],
      _Email = json['Email'],
      _Company = json['Company'],
      _Access = enumFromString<AccessLevel>(json['Access'], AccessLevel.values);
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Name': _Name, 'PhoneNumber': _PhoneNumber, 'Username': _Username, 'UserID': _UserID, 'Email': _Email, 'Company': _Company, 'Access': enumToString(_Access)
  };

  static final QueryField ID = QueryField(fieldName: "users.id");
  static final QueryField NAME = QueryField(fieldName: "Name");
  static final QueryField PHONENUMBER = QueryField(fieldName: "PhoneNumber");
  static final QueryField USERNAME = QueryField(fieldName: "Username");
  static final QueryField USERID = QueryField(fieldName: "UserID");
  static final QueryField EMAIL = QueryField(fieldName: "Email");
  static final QueryField COMPANY = QueryField(fieldName: "Company");
  static final QueryField ACCESS = QueryField(fieldName: "Access");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Users";
    modelSchemaDefinition.pluralName = "Users";
    
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
      key: Users.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.PHONENUMBER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.USERNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.EMAIL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.COMPANY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.ACCESS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
  });
}

class _UsersModelType extends ModelType<Users> {
  const _UsersModelType();
  
  @override
  Users fromJson(Map<String, dynamic> jsonData) {
    return Users.fromJson(jsonData);
  }
}