import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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