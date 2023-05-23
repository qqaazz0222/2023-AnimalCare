import 'dart:io';

import 'package:animal_care_flutter_app/bloc/health_check_bloc/health_check_bloc.dart';
import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:animal_care_flutter_app/screens/feces_suggestion_page.dart';
import 'package:animal_care_flutter_app/screens/pet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/pet_bloc/pet_bloc.dart';
import '../utils/imagePickers.dart';

class FecesDiagnosisPage extends StatelessWidget {
  const FecesDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? pResult;
    final petBloc = BlocProvider.of<PetBloc>(context);
    final fecesBloc = BlocProvider.of<HealthCheckBloc>(context);
    //? Wrapping everything with petBloc and fecesBloc builders
    return BlocBuilder<PetBloc, PetState>(
      bloc: petBloc,
      builder: (petContext, petState) {
        return BlocBuilder<HealthCheckBloc, HealthCheckState>(
          bloc: fecesBloc,
          builder: (fecesContext, fecesState) {
            pResult = fecesState.lastHealthCheckResults?.logResult;
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
                    //! Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "배변 케어",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () async {
                            await pickImageFeces(ImageSource.gallery, fecesBloc, petState);},
                          icon: const Icon(Icons.add_a_photo),
                        )
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Center(
                      child: Column(
                        children: [
                          //! Subtitle
                          Text(
                            "대변 상태는 정상에 가까워요!",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8,),
                          //! Show this when data is loaded
                          if (!fecesState.isLoading) ...[
                            //! The Image uploaded for prediction
                            Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(32),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      fecesState.lastHealthCheckResults!.logImg,
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 18,),
                            //! Prediction results
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Good results
                                _fecesClassIcon(
                                  good: true,
                                  selected: (pResult == "g") ? true : false,
                                ),
                                // Bad results
                                _fecesClassIcon(
                                  good: false,
                                  selected: (pResult == "b") ? true : false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18,),
                            //! Prediction comments
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                child: (pResult == "g")
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "적당한 무르기의 갈색 변은 건강함을 뜻해요.",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.fontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "갈색은 건강한 대변 색상이에요. 휴지로 집었을 때 묽지 않으며, 찰흙 같은 단단함과 적당한 수분감을 가지고 있어야 해요. 종종 소화되지 않는 음식물이 보이기도 하고 최근 먹은 음식에 따라 색상이 살짝 달라질 수도 있어요.",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.fontSize,
                                            ),
                                          ),
                                        ],
                                      )
                                    : (pResult == "b")
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "배변에 점액이 섞인 변일 수도 있어요.",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.fontSize,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "변에 점액이 눈에 보일 정도로 섞여 있다면, 대장등에 문제가 있을 수도 있어요! 점액이 섞인 변을 2-3회 이상 본다면 병원진료를 받아보는것을 추천드려요.",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.fontSize,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            "배변에 점액이 섞인 변일 수도 있어요. 변에 점액이 눈에 보일 정도로 섞여 있다면, 대장등에 문제가 있을 수도 있어요! 점액이 섞인 변을 2-3회 이상 본다면 병원진료를 받아보는것을 추천드려요.",
                                            style: TextStyle(fontSize: 18),
                                          ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            //! Allow Users to create a new record
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) =>
                                              MultiBlocProvider(providers: [
                                                BlocProvider.value(value: petBloc),
                                              ], child: FecesSuggestionPage())
                                          )
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Text(
                                          "의아해요!",
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                                          )
                                        ),
                                      )
                                  ),
                                ),
                                const SizedBox(width: 16,),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) =>
                                                MultiBlocProvider(providers: [
                                                  BlocProvider.value(value: petBloc),
                                                  BlocProvider.value(value: fecesBloc)
                                                ], child: PetPage())
                                            )
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        child: Text(
                                            "기록하기!",
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.onPrimary,
                                                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                                            )
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ]
                          //! Show this when data is NOT loaded
                          else ...[
                            Text("Loading"),
                            Image.asset("assets/img/no_image.png"),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _fecesClassIcon extends StatelessWidget {
  final bool good;
  final bool selected;

  const _fecesClassIcon({Key? key, required this.good, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 100,
          width: 100,
          decoration: (selected)
              ? BoxDecoration(color: Colors.yellow, shape: BoxShape.circle)
              : BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
          //TODO: Change to image icon
          child: (good)
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/img/feces_good.png"),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/img/feces_bad.png"),
                ),
        ),
      ],
    );
  }
}
