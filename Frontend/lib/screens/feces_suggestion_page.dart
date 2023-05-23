import 'package:animal_care_flutter_app/bloc/health_check_bloc/health_check_bloc.dart';
import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:animal_care_flutter_app/components/feces_suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pet_bloc/pet_bloc.dart';
import '../components/feces_suggestion_color_card.dart';

class FecesSuggestionPage extends StatefulWidget {
  const FecesSuggestionPage({Key? key}) : super(key: key);

  @override
  State<FecesSuggestionPage> createState() => _FecesSuggestionPageState();
}

class _FecesSuggestionPageState extends State<FecesSuggestionPage> {
  @override
  Widget build(BuildContext context) {
    // final fecesBloc = BlocProvider.of<HealthCheckBloc>(context);
    final petBloc = BlocProvider.of<PetBloc>(context);
    return BlocProvider(
      create: (context) => petBloc,
      child: BlocBuilder<PetBloc, PetState>(
        bloc: petBloc,
        builder: (petContext, petState){
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: MyAppBar(
              appbarSize: 100,
              petName: petState.selectedPet?.petName ?? "Your Pet",
              petImg: petState.selectedPet?.petImg,
            ),
            body: CustomScrollView(
              slivers: [SliverFillRemaining(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 12,),
                        Row(
                          children: [
                            Text(
                              "배변상태를 직접 체크 해 주세요",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.check_box_outlined)
                          ],
                        ),
                        const SizedBox(height: 18,),
                        Text(
                          "배변 색상은 어떤가요?",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 18,),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FecesSuggestionColorCard(color: Colors.red, visibility: true,),
                                FecesSuggestionColorCard(color: Colors.orange, visibility: true,),
                                FecesSuggestionColorCard(color: Colors.yellow, visibility: true,),
                                FecesSuggestionColorCard(color: Theme.of(context).colorScheme.primary, visibility: true,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FecesSuggestionColorCard(color: Colors.brown, visibility: true,),
                                FecesSuggestionColorCard(color: Colors.grey, visibility: true,),
                                FecesSuggestionColorCard(color: Colors.black, visibility: true,),
                                FecesSuggestionColorCard(color: Colors.red, visibility: false,),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 18,),
                        Text(
                          "배변 형태는 어떤가요?",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 18,),
                        const FecesSuggestionCard(
                            fecesSuggestionCardTitle: "정상적인 배변 모양",
                            fecesSuggestionCardSubtitle: "통나무같이 길쭉하고 약간 두툼한 모양.",
                            fecesSuggestionCardSubSubtitle: "부드럽지만 단단해 집었을 때 형태가 무너지지 않음",
                            fecesSuggestionCardIconPath: "assets/img/feces_suggestion_1.png",
                        ),
                        const SizedBox(height: 6,),
                        const FecesSuggestionCard(
                          fecesSuggestionCardTitle: "부드러운 토끼 똥 모양",
                          fecesSuggestionCardSubtitle: "딱딱하고, 부드러운 토끼 똥 모양.",
                          fecesSuggestionCardSubSubtitle: "변비기가 있거나 신장에 문제가 있을 수 있음",
                          fecesSuggestionCardIconPath: "assets/img/feces_suggestion_2.png",
                        ),
                        const SizedBox(height: 6,),
                        const FecesSuggestionCard(
                          fecesSuggestionCardTitle: "흐물흐물한 모양 ",
                          fecesSuggestionCardSubtitle: "진흙같은 흐물흐물한 모양.",
                          fecesSuggestionCardSubSubtitle: "사료량이 많거나, 사료 변경시 설사기가 있을 수 있음 ",
                          fecesSuggestionCardIconPath: "assets/img/feces_suggestion_3.png",
                        ),
                        const SizedBox(height: 6,),
                        const FecesSuggestionCard(
                          fecesSuggestionCardTitle: "죽이나 물같은 모양",
                          fecesSuggestionCardSubtitle: "완전히 물같은 모양. ",
                          fecesSuggestionCardSubSubtitle: "소화시키기 힘든 음식,급성장염,식중독 위험이 있음",
                          fecesSuggestionCardIconPath: "assets/img/feces_suggestion_4.png",
                        ),
                        const SizedBox(height: 6,),
                        const FecesSuggestionCard(
                          fecesSuggestionCardTitle: "점액이 섞인 모양",
                          fecesSuggestionCardSubtitle: "배변 겉에 점액이 있는 모양.",
                          fecesSuggestionCardSubSubtitle: "눈에 보일 정도로 섞여있다면, 대장에 문제 있음",
                          fecesSuggestionCardIconPath: "assets/img/feces_suggestion_5.png",
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    // await pickImageFeces(ImageSource.gallery,
                                    //     fecesBloc, petState);
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
                      ],
                    ),
                  ),
                ),
              ),
          ]
            ),
          );
        },
      ),
    );
  }
}
