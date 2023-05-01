import 'dart:io';

import 'package:animal_care_flutter_app/bloc/health_check_bloc/health_check_bloc.dart';
import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pet_bloc/pet_bloc.dart';

class FecesDiagnosisPage extends StatelessWidget {
  const FecesDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pResult;
    final petBloc = BlocProvider.of<PetBloc>(context);
    final fecesBloc = BlocProvider.of<HealthCheckBloc>(context);
    return BlocBuilder<PetBloc, PetState>(
      bloc: petBloc,
      builder: (petContext, petState) {
        return BlocBuilder<HealthCheckBloc, HealthCheckState>(
          bloc: fecesBloc,
          builder: (fecesContext, fecesState) {
            pResult = fecesState.healthCheckResults?.logResult;
            return Scaffold(
              backgroundColor: Colors.grey,
              appBar: MyAppBar(
                  appbarSize: 140,
                  petName: petState.selectedPet?.petName ?? "Your Pet"
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "배변 케어",
                    style: TextStyle(fontSize: 32),
                  ),

                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "대변 상태는 정상에 가까워요!",
                          style: TextStyle(fontSize: 24),
                        ),
                        if (!fecesState.isLoading) ...[
                          Container(
                            height: 224,
                            width: 224,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: FileImage(
                                  fecesState.healthCheckResults!.logImg,
                                ),
                              )
                            ),
                          ),
                          SizedBox(height: 12,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Good results
                              _fecesClassIcon(
                                image: "good",
                                selected: (pResult == "g") ? true : false,
                              ),
                              // Bad results
                              _fecesClassIcon(
                                image: "bad",
                                selected: (pResult == "b") ? true : false,
                              ),
                              // Not decided
                              _fecesClassIcon(
                                image: "idk",
                                selected: false,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: (pResult == "g") ? Text("적당한 무르기의 갈색 변은 건강함을 뜻해요. 갈색은 건강한 대변 색상이에요. 휴지로 집었을 때 묽지 않으며, 찰흙 같은 단단함과 적당한 수분감을 가지고 있어야 해요. 종종 소화되지 않는 음식물이 보이기도 하고 최근 먹은 음식에 따라 색상이 살짝 달라질 수도 있어요.",
                              style: TextStyle(fontSize: 18),)
                                  : (pResult == "b") ? Text("배변에 점액이 섞인 변일 수도 있어요. 변에 점액이 눈에 보일 정도로 섞여 있다면, 대장등에 문제가 있을 수도 있어요! 점액이 섞인 변을 2-3회 이상 본다면 병원진료를 받아보는것을 추천드려요.",
                                style: TextStyle(fontSize: 18),)
                                  : Text("배변에 점액이 섞인 변일 수도 있어요. 변에 점액이 눈에 보일 정도로 섞여 있다면, 대장등에 문제가 있을 수도 있어요! 점액이 섞인 변을 2-3회 이상 본다면 병원진료를 받아보는것을 추천드려요.",
                                style: TextStyle(fontSize: 18),),

                            ),
                          )
                        ]
                        else ...[
                          Text("Loading"),
                          Image.asset("assets/img/no_image.png"),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _fecesClassIcon extends StatelessWidget {
  final String image;
  final bool selected;

  const _fecesClassIcon({Key? key, required this.image, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            decoration: (selected) ? BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle
            ) : BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,),
            //TODO: Change to image icon
            child: Text(image),
          ),
        ],
      );
  }
}
