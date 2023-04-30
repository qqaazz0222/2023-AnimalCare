import 'package:animal_care_flutter_app/bloc/pet_bloc/pet_bloc.dart';
import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:animal_care_flutter_app/screens/feces_care_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/care_card.dart';

class PetPage extends StatelessWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petBloc = BlocProvider.of<PetBloc>(context);
    // Wrapping with BlocBuilder to access the BlocProvider from the main page
    return BlocBuilder<PetBloc, PetState>(
      bloc: petBloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: MyAppBar(
              appbarSize: 140,
              petName: state.selectedPet?.petName ?? "Your Pet"),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "주기적인 건강체크, 잊지마세요✔",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          if (state.isLoading)
                            const CircularProgressIndicator(),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "케어 캘린더",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          //TODO: Create calendar widget
                          Container(
                            color: Colors.white,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Text("Calendar"),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "오늘 케어 기록",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                //TODO: Get card status from database
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: petBloc,
                                            child: FecesCarePage(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: CareCard(
                                      careCardTitle: "건강케어",
                                      careCardSubtitle: "배변사진 체크기록이 없어요",
                                      careCardStatus: false,
                                    )),
                                //TODO: add Navigation for other buttons
                                CareCard(
                                  careCardTitle: "맞춤케어",
                                  careCardSubtitle: "식사량 체크기록이 있어요",
                                  careCardStatus: true,
                                ),
                                CareCard(
                                  careCardTitle: "검진케어",
                                  careCardSubtitle: "진료/검진 기록이 있어요",
                                  careCardStatus: true,
                                ),
                                CareCard(
                                  careCardTitle: "산책케어",
                                  careCardSubtitle: "산책량 체크기록이 없어요",
                                  careCardStatus: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        );
      },
    );
  }
}
