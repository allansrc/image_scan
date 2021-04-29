import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_scan/image_scan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyAppState extends State<MyApp> {
  late AppState state;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('f-team imagescan'),
        ),
        body: Center(
          child: imageFile != null ? Image.file(imageFile!) : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            if (state == AppState.free)
              _pickImage();
            else if (state == AppState.picked)
              _cropImage();
            else if (state == AppState.cropped) _clearImage();
          },
          child: _buildButtonIcon(),
        ),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      iosUiSettings: IOSUiSettings(
        title: 'Test',
        minimumAspectRatio: 16 / 9,
      ),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Test', // optional
        toolbarColor: Colors.blue, // optional
        toolbarWidgetColor: Colors.white, // optional
        initAspectRatio: CropAspectRatioPreset.ratio16x9, // optional
        lockAspectRatio: true, // optional > KEEPS ASPECT RAIO SELECTED

        showCropGrid: true, // optional
        hideBottomControls: true, // optional
        cropFrameColor: Colors.amber, // optional

        // cropGridColor: null,// optional
        // statusBarColor: null,// optional
        // backgroundColor: null, // optional
        // cropGridRowCount: 5, // optional
        // dimmedLayerColor: null,// optional // Corners colors
        // cropGridStrokeWidth: null,// optional
        // cropGridColumnCount: null,// optional
        // cropFrameStrokeWidth: null,// optional
        // activeControlsWidgetColor: null,// optional
      ),
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}
