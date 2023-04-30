import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:animal_care_flutter_app/models/health_check.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../utils/AppConfig.dart';

part 'health_check_event.dart';
part 'health_check_state.dart';

class HealthCheckBloc extends Bloc<HealthCheckEvent, HealthCheckState> {
  HealthCheckBloc() : super(HealthCheckState()) {
    on<UploadFecesHealthCheckEvent>(_onUploadFecesHealthCheckEvent);
    }

    Future<void> _onUploadFecesHealthCheckEvent(UploadFecesHealthCheckEvent event, Emitter<HealthCheckState> emit) async {
      emit(state.copyWith(isLoading: false));
      const url = "${Server.serverUrl}/log/healthcheck";
      HealthCheck? healthCheckResults;

      //TODO: Move credentials to another place
      // final cloudinary = Cloudinary.signedConfig(
      //   apiKey: "drmfizkit",
      //   apiSecret: "171663269982453",
      //   cloudName: "9bhs25W0dAFnlKeto1eok9rdWrg",
      // );

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields["petid"] = event.petId.toString();
      request.files.add(
          http.MultipartFile.fromBytes(
            "img",
            File(event.img.path).readAsBytesSync(),
            filename: event.img.path,
            contentType: MediaType('image', 'jpeg')
          ));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
      } else {
        print('Failed to upload image.');
      }
      emit(state.copyWith(isLoading: true));
    }
}
