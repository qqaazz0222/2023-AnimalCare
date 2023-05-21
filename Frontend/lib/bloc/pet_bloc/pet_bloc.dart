import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:animal_care_flutter_app/models/pet.dart';
import 'package:animal_care_flutter_app/utils/AppConfig.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'pet_event.dart';
part 'pet_state.dart';

class PetBloc extends Bloc<SelectPetEvent, PetState> {
  PetBloc() : super(PetState()) {
    on<SelectPetEvent>(_onSelectPet);
  }

  Future<void> _onSelectPet(SelectPetEvent event, Emitter<PetState> emit) async {
    emit(state.copyWith(isLoading: false));
    final uri = Uri.parse("${Server.serverUrl}/pet/getinfo");
    Pet? selectedPet;
    // print("PetBloc: Selected Pet: ${event.petId}");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'petid': event.petId,
      }),
    );
    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      // print(_data);
      //? Decode base64 image and save to the app directory
      final buffer = base64.decode(_data[8].replaceAll(RegExp(r'\s+'), ''));
      String dir = (await getApplicationDocumentsDirectory()).path;
      //? Create a file of apps directory and write decoded image into it
      File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.jpeg");
      await file.writeAsBytes(buffer);
      selectedPet = Pet(
        _data[0],
        _data[1],
        _data[2],
        _data[3],
        _data[4],
        _data[5],
        _data[6],
        _data[7],
        file,
        _data[9],
      );
    } else {
      throw Exception('Failed to fetch data');
    }
    emit(state.copyWith(selectedPet: selectedPet, isLoading: false));
  }
}
