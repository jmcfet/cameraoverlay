import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'sidebyside.dart';
List<CameraDescription> cameras;

Future<void> main() async {

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CameraApp(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}



class CameraApp extends StatefulWidget {
  final CameraDescription camera;
  const CameraApp({
    Key key,
    @required this.camera,
  }) : super(key: key);
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController _controller;
  File _imageFile;
  double _sliderValue = .3;
  @override
  void initState() {

    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
   _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
   });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height1 = 500;
    try {
       height1 = MediaQuery
          .of(context)
          .size
          .height - 80;
    }
    catch ( e)
    {
      height1 = 500;
    }
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(

        home:Scaffold(
        appBar: AppBar(
        title: Text('Image Picker Example'),
        ),
        body:
          Column(children: <Widget> [
            Container(
              height: 600,
              child:Stack(

                alignment: FractionalOffset.center,
                children: <Widget>[

                  new Positioned.fill(

                    child: new AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: new CameraPreview(_controller)),
                  ),
                  new Positioned.fill(
                    child: new Opacity(
                      opacity: _sliderValue,
                      child: new Container(
                          child: _imageFile == null ? Container() : Image.file(_imageFile,
                               fit: BoxFit.fill,
                          ),

                      ),
                    ),
                  ),
                ]
              ) ,
        ),
              Container(
                height:30,
                child:Row(

                  children: <Widget>[
                    new  FlatButton(
                      onPressed: getImage,

                      child: Icon(Icons.photo_library),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.camera_alt),
                      // Provide an onPressed callback.
                      onPressed: () async {
                        // Take the Picture in a try / catch block. If anything goes wrong,
                        // catch the error.
                        try {
                          // Ensure that the camera is initialized.
                         // await _initializeControllerFuture;

                          // Construct the path where the image should be saved using the path
                          // package.
                          final path = join(
                            // Store the picture in the temp directory.
                            // Find the temp directory using the `path_provider` plugin.
                            (await getTemporaryDirectory()).path,
                            '${DateTime.now()}.png',
                          );

                          // Attempt to take a picture and log where it's been saved.
                          await _controller.takePicture(path);
                          GallerySaver.saveImage(path);
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => sidebyside( File(path),_imageFile),
                          )
                           );
                        } catch (e) {
                          // If an error occurs, log the error to the console.
                          print(e);
                        }
                      },
                    ),
                    new  Slider(
                      activeColor: Colors.indigoAccent,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (newRating) {
                        setState(() => _sliderValue = newRating);
                      },
                      value: _sliderValue,
                    ),

                  ]
                )
              )
          ]


        )
    )
    );
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _imageFile = image;
   //   showButton = true;
    });

  }
}