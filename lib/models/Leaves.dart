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


/** This is an auto generated class representing the Leaves type in your schema. */
@immutable
class Leaves extends Model {
  static const classType = const _LeavesModelType();
  final String id;
  final String? _From;
  final String? _To;
  final String? _LeaveReason;
  final String? _RejectReason;
  final LeaveStatus? _Status;
  final LeaveType? _Type;
  final String? _UserID;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get From {
    return _From;
  }
  
  String? get To {
    return _To;
  }
  
  String? get LeaveReason {
    return _LeaveReason;
  }
  
  String? get RejectReason {
    return _RejectReason;
  }
  
  LeaveStatus? get Status {
    return _Status;
  }
  
  LeaveType? get Type {
    return _Type;
  }
  
  String? get UserID {
    return _UserID;
  }
  
  const Leaves._internal({required this.id, From, To, LeaveReason, RejectReason, Status, Type, UserID}): _From = From, _To = To, _LeaveReason = LeaveReason, _RejectReason = RejectReason, _Status = Status, _Type = Type, _UserID = UserID;
  
  factory Leaves({String? id, String? From, String? To, String? LeaveReason, String? RejectReason, LeaveStatus? Status, LeaveType? Type, String? UserID}) {
    return Leaves._internal(
      id: id == null ? UUID.getUUID() : id,
      From: From,
      To: To,
      LeaveReason: LeaveReason,
      RejectReason: RejectReason,
      Status: Status,
      Type: Type,
      UserID: UserID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Leaves &&
      id == other.id &&
      _From == other._From &&
      _To == other._To &&
      _LeaveReason == other._LeaveReason &&
      _RejectReason == other._RejectReason &&
      _Status == other._Status &&
      _Type == other._Type &&
      _UserID == other._UserID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Leaves {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("From=" + "$_From" + ", ");
    buffer.write("To=" + "$_To" + ", ");
    buffer.write("LeaveReason=" + "$_LeaveReason" + ", ");
    buffer.write("RejectReason=" + "$_RejectReason" + ", ");
    buffer.write("Status=" + (_Status != null ? enumToString(_Status)! : "null") + ", ");
    buffer.write("Type=" + (_Type != null ? enumToString(_Type)! : "null") + ", ");
    buffer.write("UserID=" + "$_UserID");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Leaves copyWith({String? id, String? From, String? To, String? LeaveReason, String? RejectReason, LeaveStatus? Status, LeaveType? Type, String? UserID}) {
    return Leaves(
      id: id ?? this.id,
      From: From ?? this.From,
      To: To ?? this.To,
      LeaveReason: LeaveReason ?? this.LeaveReason,
      RejectReason: RejectReason ?? this.RejectReason,
      Status: Status ?? this.Status,
      Type: Type ?? this.Type,
      UserID: UserID ?? this.UserID);
  }
  
  Leaves.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _From = json['From'],
      _To = json['To'],
      _LeaveReason = json['LeaveReason'],
      _RejectReason = json['RejectReason'],
      _Status = enumFromString<LeaveStatus>(json['Status'], LeaveStatus.values),
      _Type = enumFromString<LeaveType>(json['Type'], LeaveType.values),
      _UserID = json['UserID'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'From': _From, 'To': _To, 'LeaveReason': _LeaveReason, 'RejectReason': _RejectReason, 'Status': enumToString(_Status), 'Type': enumToString(_Type), 'UserID': _UserID
  };

  static final QueryField ID = QueryField(fieldName: "leaves.id");
  static final QueryField FROM = QueryField(fieldName: "From");
  static final QueryField TO = QueryField(fieldName: "To");
  static final QueryField LEAVEREASON = QueryField(fieldName: "LeaveReason");
  static final QueryField REJECTREASON = QueryField(fieldName: "RejectReason");
  static final QueryField STATUS = QueryField(fieldName: "Status");
  static final QueryField TYPE = QueryField(fieldName: "Type");
  static final QueryField USERID = QueryField(fieldName: "UserID");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Leaves";
    modelSchemaDefinition.pluralName = "Leaves";
    
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
      key: Leaves.FROM,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Leaves.TO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Leaves.LEAVEREASON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Leaves.REJECTREASON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Leaves.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Leaves.TYPE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Leaves.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _LeavesModelType extends ModelType<Leaves> {
  const _LeavesModelType();
  
  @override
  Leaves fromJson(Map<String, dynamic> jsonData) {
    return Leaves.fromJson(jsonData);
  }
}