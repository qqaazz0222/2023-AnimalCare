import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:animal_care_flutter_app/components/PetCard.dart';
import 'package:animal_care_flutter_app/components/PetCardCarousel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyAppBar(appbarSize: 140.0),
                    const Text("My Pet"),
                    Row(
                      children: [
                        Container(
                          child: PetCardCarousel(),
                          height: 270,
                          width: MediaQuery.of(context).size.width,
                        )
                      ],
                    ),
                    const Text("건강체크 해볼까요"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: 200,
                            height: 130,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("건강케어"),
                                  subtitle: Text("배변사진 체크"),
                                ),
                              ], //TODO: Add icon image
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: 200,
                            height: 130,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("맞춤케어"),
                                  subtitle: Text("식사량 체크"),
                                ),
                              ], //TODO: Add icon image
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: 200,
                            height: 130,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("검진케어"),
                                  subtitle: Text("진료/검진 체크"),
                                ),
                              ], //TODO: Add icon image
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: 200,
                            height: 130,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("산책케어"),
                                  subtitle: Text("산책량 체크"),
                                ),
                              ], //TODO: Add icon image
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("케어 기록 보기"),
                                  subtitle: Text("체크 기록이 없어요"),
                                ),
                              ], //TODO: Add icon image
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text("이번 주 예정사항 있어요"),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              children: [
                                //TODO: get data from Database
                                ListTile(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Text("봉쥬르의"),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text("예방 접종이 있는 날이에요!"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: const Text("2023.03.13 17:30"),
                                ),
                              ], //TODO: Add icon image
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
