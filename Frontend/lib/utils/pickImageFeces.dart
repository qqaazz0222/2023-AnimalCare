import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/health_check_bloc/health_check_bloc.dart';

Future pickImage(source_, fecesBloc, petState) async {
  XFile? pickedImage;
  try {
    pickedImage = await ImagePicker().pickImage(source: source_);
    if (pickedImage == null) return;
    File file = File(pickedImage.path);
    fecesBloc.add(UploadFecesHealthCheckEvent(petState.selectedPet.petId, file));
    return pickedImage;
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
    return null;
  }
}