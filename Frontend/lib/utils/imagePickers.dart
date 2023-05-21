import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../bloc/health_check_bloc/health_check_bloc.dart';
import 'AppConfig.dart';

Future pickImageFeces(source_, fecesBloc, petState) async {
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

Future uploadPetImage(File img, petId) async {
  try {
    //TODO: Use PetBloc to add PetEvent
    const url = "${Server.serverUrl}/pet";
    var request = http.MultipartRequest('POST', Uri.parse("$url/uploadimg"));
    request.fields["petid"] = petId.toString();
    request.files.add(http.MultipartFile.fromBytes(
        "img", File(img.path).readAsBytesSync(),
        filename: img.path, contentType: MediaType('image', 'jpeg')));
    //? Get results as Streamed Response and convert to normal Response
    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    //? Success
    if (streamedResponse.statusCode == 200) {
      print('Image uploaded successfully!');
      //? Retrieve data from the response
    }else{
      print('Failed to upload image');
    }

  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
    return null;
  }
}

Future<int> uploadImage(File imageFile, url, petId) async {
  // open a bytestream
  var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();
  var resultCode = 1;

  // string to uri
  var uri = Uri.parse(url.toString());

  // create multipart request
  var request = http.MultipartRequest("POST", uri);
  // multipart that takes file
  var multipartFile = http.MultipartFile('img', stream, length, filename: basename(imageFile.path));

  // add file to multipart
  request.files.add(multipartFile);

  // add petId to fields
  request.fields.addEntries([MapEntry('petid', petId.toString())]);

  // send
  var response = await request.send();

  // listen for response
  await utf8.decoder.bind(response.stream).listen((value) {
    Map<String, dynamic> responseMap = jsonDecode(value);
    print(responseMap);
    resultCode = responseMap["code"];
  }).asFuture();

  return resultCode;
}