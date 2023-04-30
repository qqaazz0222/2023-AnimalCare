import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_state_button/progress_button.dart';

import '../bloc/health_check_bloc/health_check_bloc.dart';
import '../bloc/pet_bloc/pet_bloc.dart';
import '../components/MyAppBar.dart';

class FecesCarePage extends StatelessWidget {
  const FecesCarePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    http.ByteStream? stream;
    int? length;

    Future pickImage(source_, fecesBloc, petState) async {
      try {
        final pickedImage = await ImagePicker().pickImage(source: source_);
        if (pickedImage == null) return;
        File file = File(pickedImage.path);
        // stream = http.ByteStream(pickedImage.openRead());
        // stream?.cast();
        length = await pickedImage.length();

        fecesBloc.add(UploadFecesHealthCheckEvent(
            petState.selectedPet.petId, file,
            length!));

        // bytes = await pickedImage.readAsBytes();
        // myPickedImage = html.Blob([bytes]);
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
        return null;
      }
    }

    final petBloc = BlocProvider.of<PetBloc>(context);
    final fecesBloc = HealthCheckBloc();
    return BlocProvider(
      create: (context) => fecesBloc,
      child: BlocBuilder<PetBloc, PetState>(
          bloc: petBloc,
          builder: (petContext, petState) {
            return BlocBuilder<HealthCheckBloc, HealthCheckState>(
              bloc: fecesBloc,
              builder: (fecesContext, fecesState) {
                return Scaffold(
                  backgroundColor: Colors.grey,
                  appBar: MyAppBar(
                      appbarSize: 140,
                      petName: petState.selectedPet?.petName ?? "Your Pet"
                  ),
                  //TODO: Create BlocBuilder for FecesCareState
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "배변 케어",
                        style: TextStyle(fontSize: 24),
                      ),
                      //TODO: Change depending on FecesCareState
                      Center(child: SizedBox(width: 200, height: 200,
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("배변", style: TextStyle(fontSize: 18),),
                                Text("체크기록이 없어요"),
                              ],
                            ),
                          ),
                        ),
                      )
                      ),
                      SizedBox(height: 50,),
                      Center(
                          child: Text(
                            "나의 반려견의 배변사진을 찍어매주, 체크 주기를 지켜 점수를 쌓아보세요!",
                            style: TextStyle(fontSize: 18),)
                      ),
                      SizedBox(height: 100,),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              pickImage(ImageSource.gallery, fecesBloc, petState);
                            },
                            child: const Text("촬영하기!")),
                      )
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
