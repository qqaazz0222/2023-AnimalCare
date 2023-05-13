import 'dart:async';

import 'package:animal_care_flutter_app/bloc/health_check_bloc/health_check_bloc.dart';
import 'package:animal_care_flutter_app/components/PetCardCarousel.dart';
import 'package:animal_care_flutter_app/screens/feces_care_page.dart';
import 'package:animal_care_flutter_app/screens/feces_diagnosis_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pet_bloc/pet_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> currentPet;

  @override
  Widget build(BuildContext context) {
    //? Instance of PetBloc and FecesBloc. Use this after navigating to Pet's page
    final petBloc = PetBloc();
    final fecesBloc = HealthCheckBloc();
    //? Managing Providers for this page
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => petBloc,
        ),
        BlocProvider(
          create: (context) => fecesBloc,
        )
      ],
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        toolbarHeight: 140,
                        elevation: 0,
                        actions: [
                          IconButton(
                            onPressed: () {},
                            color: Theme.of(context).iconTheme.color,
                            iconSize: Theme.of(context).iconTheme.size,
                            icon: Icon(Icons.search),
                            tooltip: "Search",
                          ),
                          IconButton(
                            onPressed: () {},
                            color: Colors.black,
                            icon: Icon(Icons.menu),
                            iconSize: 32,
                            tooltip: "Navigation",
                          ),
                        ],
                        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("안녕하세요"),
                              ],
                            ),
                            Row(
                              children: [
                                //TODO: Change the name of the Pet.
                                //? Which pet's name???
                                Text("봉쥬르",
                                    style: TextStyle(color: Theme.of(context).primaryColor)),
                                const Text(
                                  "반려인님",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text("나의 반려동물 등록해요", style: TextStyle(

                      )),
                      //! Pet Cards Carousel
                      Row(
                        children: [
                          Container(
                            child: PetCardCarousel(petBloc: petBloc, fecesBloc: fecesBloc),
                            height: 270,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                          ),

                        ],
                      ),
                      //! Health Check Options
                      const Text("건강체크 해볼까요"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //! Feces Diagnosis
                          BlocBuilder<HealthCheckBloc, HealthCheckState>(
                            bloc: fecesBloc,
                            builder: (fecesContext, fecesState) {
                              return InkWell(
                                onTap: () async {
                                  fecesBloc.add(GetLastHealthCheckEvent(petBloc.state.selectedPet!.petId));
                                  print("For a second: ${fecesState.lastHealthCheckResults?.petId}");
                                  late StreamSubscription<HealthCheckState> fecesStateSubscription;
                                  fecesStateSubscription = fecesBloc.stream.listen((fecesState) {
                                    if (fecesState.lastHealthCheckResults == null && !fecesState.isLoading) {
                                      print("HomePage: There are no records");
                                      print("HomePage: ${fecesState.lastHealthCheckResults?.petId}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(value: petBloc),
                                              BlocProvider.value(value: fecesBloc),
                                            ],
                                            child: FecesCarePage(),
                                          ),
                                        ),
                                      );
                                      //? Cancel the subscription to avoid memory leaks
                                      fecesStateSubscription.cancel();
                                    } else if (fecesState.lastHealthCheckResults != null && !fecesState.isLoading) {
                                      print("HomePage: There are some records");
                                      print("HomePage: ${petBloc.state.selectedPet?.petId}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(value: petBloc),
                                              BlocProvider.value(value: fecesBloc),
                                            ],
                                            child: FecesDiagnosisPage(),
                                          ),
                                        ),
                                      );
                                      //? Cancel the subscription to avoid memory leaks
                                      fecesStateSubscription.cancel();
                                    }
                                  });
                                },
                                  child: Card(
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
                                  )
                              );
                            },
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
                                  //TODO: get data from Database, but which pet's name if I have many pets?
                                  ListTile(
                                    title: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
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
          )),
    );
  }
}
