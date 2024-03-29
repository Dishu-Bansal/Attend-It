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
import 'Attendance.dart';
import 'Attending.dart';
import 'Companies.dart';
import 'Leaves.dart';
import 'Users.dart';

export 'AccessLevel.dart';
export 'Attendance.dart';
export 'Attending.dart';
export 'Companies.dart';
export 'LeaveStatus.dart';
export 'LeaveType.dart';
export 'Leaves.dart';
export 'Users.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "9328be9d78a0ffc143ede8307ed7ace5";
  @override
  List<ModelSchema> modelSchemas = [Attendance.schema, Attending.schema, Companies.schema, Leaves.schema, Users.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
    case "Attendance": {
    return Attendance.classType;
    }
    break;
    case "Attending": {
    return Attending.classType;
    }
    break;
    case "Companies": {
    return Companies.classType;
    }
    break;
    case "Leaves": {
    return Leaves.classType;
    }
    break;
    case "Users": {
    return Users.classType;
    }
    break;
    default: {
    throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
    }
  }
}