import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:core';
import 'package:attend_it/aws_ai/src/RekognitionHandler.dart';

List<CameraDescription> cameras = List.empty(growable: true);


class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  _PhotoState createState() {
    WidgetsFlutterBinding.ensureInitialized();

    return _PhotoState();
  }
}


class _PhotoState extends State<Photo> {
  late CameraController _controller;
  bool initialized = false;
  String imagepath = "";
  bool detecting = false, faceerror = false;
  String accesskey = "AKIAYCBZZPSXIQC4I3GO", secretkey = "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", region = "ap-south-1";

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

  @override
  Widget build(BuildContext context) {

    if(detecting)
      {
        File source = File(imagepath);
        handler.detectFaces(source).then((value) {
          Map<String, dynamic> faceresult = jsonDecode(value);
          List<dynamic> details = faceresult["FaceDetails"];
          if(details.isNotEmpty)
            {
              double confidence = double.parse(details[0]["Confidence"].toString());
              if(confidence > 90)
              {
                Navigator.of(context).pop([imagepath]);
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
      }

    if(initialized)
      {
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
              Text(faceerror ? "Error Detecting face. Please try again." : (!detecting ? "Click a Photo to confirm your face" : "Detecting face")),
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
