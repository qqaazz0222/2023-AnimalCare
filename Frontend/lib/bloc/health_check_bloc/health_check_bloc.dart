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
      // Set loading to true
      emit(state.copyWith(isLoading: true));
      const url = "${Server.serverUrl}/log";
      // Initialize our HealthCheck class
      HealthCheck? healthCheckResults;

      // Post uploaded image to the API
      var request = http.MultipartRequest('POST', Uri.parse("$url/healthcheck"));
      request.fields["petid"] = event.petId.toString();
      request.files.add(
          http.MultipartFile.fromBytes(
            "img",
            File(event.img.path).readAsBytesSync(),
            filename: event.img.path,
            contentType: MediaType('image', 'jpeg')
          ));
      // Get results as Streamed Response and convert to normal Response
      var streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Success
      if (streamedResponse.statusCode == 200) {
        print('Image uploaded successfully!');
        // Retrieve data from the response
        final data = jsonDecode(response.body);

        final year = data["year"];
        final month = data["month"];
        final day = data["day"];
        final pResult = data["predictResult"];

        // Create another POST to get results of the prediction
        final response2 = await http.post(
          Uri.parse("$url/getinfo"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'petid': event.petId,
            'year': year,
            'month': month,
            'day': day,
          }),
        );
        if (response2.statusCode == 200) {
          final data2 = jsonDecode(response2.body);
          // define initialized HealthCheck
          healthCheckResults = HealthCheck(
              data2[0] as int,
              year,
              month,
              day,
              event.img,
              pResult,
              event.petId
          );
        }
      } else {
        print('Failed to upload image.');
      }
      // Set results state and make isLoading "false"
      emit(state.copyWith(healthCheckResults: healthCheckResults, isLoading: false));
    }
}
