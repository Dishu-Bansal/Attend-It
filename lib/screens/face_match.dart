import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:core';
import 'package:attend_it/aws_ai/src/RekognitionHandler.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

import 'package:path_provider/path_provider.dart';

import 'package:attend_it/keys.dart';

List<CameraDescription> cameras = List.empty(growable: true);

class FaceMatch extends StatefulWidget {
  const FaceMatch({Key? key}) : super(key: key);

  @override
  _FaceMatchState createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _FaceMatchState();
  }
}

class _FaceMatchState extends State<FaceMatch> {

  late CameraController _controller;
  bool initialized = false;
  String imagepath = "";
  bool detecting = false, faceerror = false;
  String accesskey = accesske, secretkey = secretke, region = regio;

  late RekognitionHandler handler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeCamera();
    handler = new RekognitionHandler(accesskey, secretkey, region);
  }

  _initializeCamera() async {
    await availableCameras().then((value) {
      cameras = value;
      print("Values are: " + value.toString());
    });

    _controller = CameraController(cameras[1], ResolutionPreset.max);
    _controller.initialize().then((value) {
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Future<File> _downloadProfileImage() async
  {
    AuthUser user = await Amplify.Auth.getCurrentUser();
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + "/profile.jpg";
    final file = File(filepath);
    await Amplify.Storage.downloadFile(key: user.username, local: file);
    return file;
  }
  @override
  Widget build(BuildContext context) {

    if(detecting)
    {
      Future<File> source = _downloadProfileImage();
      File target = File(imagepath);
      source.then((value) {
        handler.compareFaces(value, target).then((value) {
          Map<String, dynamic> faceresult = jsonDecode(value);
          List<dynamic> details = faceresult["FaceMatches"];
          if(details!= null && details.isNotEmpty)
          {
            double confidence = double.parse(details.first["Face"]["Confidence"].toString());
            if(confidence > 90)
            {
              Navigator.of(context).pop(true);
              _controller.dispose();
            }
            else
            {
              setState(() {
                faceerror = true;
                detecting = false;
                imagepath = "";
              });
            }
          }
          else
          {
            setState(() {
              faceerror = true;
              detecting = false;
              imagepath = "";
            });
          }
        });
      });

    }

    if(initialized)
    {
      print("Path to is: " + imagepath);
      return Scaffold(
          appBar: AppBar(
            title: Text("Take Picture"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: (imagepath == "") ? CameraPreview(_controller) : Image.file(File(imagepath)),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  margin: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Photo 1.png"),
                          fit: BoxFit.fill
                      )
                  ),
                ),
              ),
              Text(faceerror ? "Error Detecting face. Please try again." : (!detecting ? "Click a Photo to confirm your face" : "Detecting face"), style: TextStyle(fontSize: 23.0),),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  onPressed: () async {
                    var image = await _controller.takePicture();
                    setState(() {
                      imagepath = image.path;
                      faceerror = false;
                      detecting = true;
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.blue,
                  padding: EdgeInsets.all(15.0),
                  child: Text("Take Photo", style: TextStyle(fontSize: 20.0)),
                ),
              )
            ],
          )
      );
    }
    else
    {
      return Scaffold(
        appBar: AppBar(
          title: Text("Take Photo"),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
