import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PetImageUploadPage extends StatefulWidget {
  const PetImageUploadPage({Key? key}) : super(key: key);

  @override
  State<PetImageUploadPage> createState() => _PetImageUploadPageState();
}

class _PetImageUploadPageState extends State<PetImageUploadPage> {

  File? imageGallery;
  Future pickImageGallery() async {
    try {
      final imageGallery = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if(imageGallery == null) return;
          final imageTemp = File(imageGallery.path);
          setState(() => this.imageGallery = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  File? imageCamera;
  Future pickImageCamera() async {
    try {
      final imageCamera = await ImagePicker().pickImage(
          source: ImageSource.camera);
      if(imageCamera == null) return;
      final imageTemp = File(imageCamera.path);
      setState(() => this.imageCamera = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    pickImageGallery();
                  }
              ),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Image from Camera",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    pickImageCamera();
                  }
              ),
            ],
          ),
        )
    );;
  }
}
