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


/** This is an auto generated class representing the Attending type in your schema. */
@immutable
class Attending extends Model {
  static const classType = const _AttendingModelType();
  final String id;
  final String? _Clockin;
  final String? _Clockout;
  final String? _Date;
  final String? _UserID;
  final String? _WorkingHours;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Clockin {
    return _Clockin;
  }
  
  String? get Clockout {
    return _Clockout;
  }
  
  String? get Date {
    return _Date;
  }
  
  String? get UserID {
    return _UserID;
  }
  
  String? get WorkingHours {
    return _WorkingHours;
  }
  
  const Attending._internal({required this.id, Clockin, Clockout, Date, UserID, WorkingHours}): _Clockin = Clockin, _Clockout = Clockout, _Date = Date, _UserID = UserID, _WorkingHours = WorkingHours;
  
  factory Attending({String? id, String? Clockin, String? Clockout, String? Date, String? UserID, String? WorkingHours}) {
    return Attending._internal(
      id: id == null ? UUID.getUUID() : id,
      Clockin: Clockin,
      Clockout: Clockout,
      Date: Date,
      UserID: UserID,
      WorkingHours: WorkingHours);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Attending &&
      id == other.id &&
      _Clockin == other._Clockin &&
      _Clockout == other._Clockout &&
      _Date == other._Date &&
      _UserID == other._UserID &&
      _WorkingHours == other._WorkingHours;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Attending {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Clockin=" + "$_Clockin" + ", ");
    buffer.write("Clockout=" + "$_Clockout" + ", ");
    buffer.write("Date=" + "$_Date" + ", ");
    buffer.write("UserID=" + "$_UserID" + ", ");
    buffer.write("WorkingHours=" + "$_WorkingHours");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Attending copyWith({String? id, String? Clockin, String? Clockout, String? Date, String? UserID, String? WorkingHours}) {
    return Attending(
      id: id ?? this.id,
      Clockin: Clockin ?? this.Clockin,
      Clockout: Clockout ?? this.Clockout,
      Date: Date ?? this.Date,
      UserID: UserID ?? this.UserID,
      WorkingHours: WorkingHours ?? this.WorkingHours);
  }
  
  Attending.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Clockin = json['Clockin'],
      _Clockout = json['Clockout'],
      _Date = json['Date'],
      _UserID = json['UserID'],
      _WorkingHours = json['WorkingHours'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Clockin': _Clockin, 'Clockout': _Clockout, 'Date': _Date, 'UserID': _UserID, 'WorkingHours': _WorkingHours
  };

  static final QueryField ID = QueryField(fieldName: "attending.id");
  static final QueryField CLOCKIN = QueryField(fieldName: "Clockin");
  static final QueryField CLOCKOUT = QueryField(fieldName: "Clockout");
  static final QueryField DATE = QueryField(fieldName: "Date");
  static final QueryField USERID = QueryField(fieldName: "UserID");
  static final QueryField WORKINGHOURS = QueryField(fieldName: "WorkingHours");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Attending";
    modelSchemaDefinition.pluralName = "Attendings";
    
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
      key: Attending.CLOCKIN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Attending.CLOCKOUT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Attending.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Attending.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Attending.WORKINGHOURS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AttendingModelType extends ModelType<Attending> {
  const _AttendingModelType();
  
  @override
  Attending fromJson(Map<String, dynamic> jsonData) {
    return Attending.fromJson(jsonData);
  }
}