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
    File? croppedFile = await ImageScan.cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
      ],
      iosUiSettings: IOSUiSettings(
        rectX: 90,
        rectY: 160,
        rectWidth: 90,
        rectHeight: 160,
        // showActivitySheetOnDone: true, // not need at this time <TDB>
        showCancelConfirmationDialog: false, // defautl
        rotateClockwiseButtonHidden: false, // default

        hidesNavigationBar: true,

        resetButtonHidden: false, // deffault
        rotateButtonsHidden: false, // default
        aspectRatioLockEnabled: false, // default
        resetAspectRatioEnabled: true, // default
        aspectRatioPickerButtonHidden: false, // default
        aspectRatioLockDimensionSwapEnabled: false, // default
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Cortar',
        title: 'Teste',
      ),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Test',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,

        /// `Colors`
        // statusBarColor: ,
        // backgroundColor: ,
        // activeControlsWidgetColor: ,
        // dimmedLayerColor: ,
        // cropFrameColor: ,
        // cropGridColor: ,

        /// `Style`
        // cropFrameStrokeWidth: ,
        // cropGridStrokeWidth: ,
        // cropGridColumnCount: ,
        // cropGridRowCount: ,
        // showCropGrid: ,

        lockAspectRatio: true, // keeps aspect
        hideBottomControls: false, // default
        initAspectRatio: CropAspectRatioPreset.ratio16x9, // optional
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
