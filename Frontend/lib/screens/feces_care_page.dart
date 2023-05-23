import 'package:animal_care_flutter_app/screens/feces_diagnosis_page.dart';
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
import '../utils/imagePickers.dart';

class FecesCarePage extends StatelessWidget {
  const FecesCarePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    XFile? pickedImage;

    // Future pickImage(source_, fecesBloc, petState) async {
    //   try {
    //     pickedImage = await ImagePicker().pickImage(source: source_);
    //     if (pickedImage == null) return;
    //     File file = File(pickedImage!.path);
    //
    //     fecesBloc.add(UploadFecesHealthCheckEvent(petState.selectedPet.petId, file));
    //   } on PlatformException catch (e) {
    //     print('Failed to pick image: $e');
    //     return null;
    //   }
    // }

    //! Initialize petBloc and fecesBloc passed from the previous page
    final petBloc = BlocProvider.of<PetBloc>(context);
    final fecesBloc = BlocProvider.of<HealthCheckBloc>(context);
    //! Wrap everything with PetBloc builder
    return BlocBuilder<PetBloc, PetState>(
        bloc: petBloc,
        builder: (petContext, petState) {
          //! Wrap everything with HealthCheckBloc builder
          return BlocBuilder<HealthCheckBloc, HealthCheckState>(
            bloc: fecesBloc,
            builder: (fecesContext, fecesState) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: MyAppBar(
                    appbarSize: 100,
                    petName: petState.selectedPet?.petName ?? "Your Pet",
                    petImg: petState.selectedPet?.petImg),
                body: Container(
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("배변 케어",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 50,
                      ),
                      //! Show empty Container if image is not loaded
                      if (pickedImage == null) ...[
                        Center(
                            child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "배변",
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "체크기록이 없어요",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                      ] else ...[
                        //! Show after image was uploaded
                        Center(
                          child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.primary),
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(32),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(pickedImage!.path),
                                  ),
                                ),
                              ),
                              // child: Image.file(fecesState.healthCheckResults!.logImg)
                              ),
                        )),
                      ],
                      const SizedBox(
                        height: 60,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "나의 반려견의 배변사진을 찍어",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "매주, 체크 주기를 지켜 점수를 쌓아보세요!",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      //! Image Upload Button
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondaryContainer,
                              ),
                              onPressed: () async {
                                pickedImage = await pickImageFeces(
                                    ImageSource.gallery, fecesBloc, petState);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  "촬영하기!",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.fontSize),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      //! Diagnosis prediction button
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                if (pickedImage != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      //? Move Blocs to the next page
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(value: petBloc),
                                          BlocProvider.value(value: fecesBloc),
                                        ],
                                        child: FecesDiagnosisPage(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  "Analyze!",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.onPrimary,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.fontSize),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
