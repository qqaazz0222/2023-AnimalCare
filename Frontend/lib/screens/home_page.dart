import 'dart:async';

import 'package:animal_care_flutter_app/bloc/health_check_bloc/health_check_bloc.dart';
import 'package:animal_care_flutter_app/components/PetCardCarousel.dart';
import 'package:animal_care_flutter_app/screens/feces_care_page.dart';
import 'package:animal_care_flutter_app/screens/feces_diagnosis_page.dart';
import 'package:animal_care_flutter_app/screens/pet_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/pet_bloc/pet_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool endOfCarousel = false;
  callBack(bool endOfCarousel) {
    setState(() {
      this.endOfCarousel = endOfCarousel;
    });
    print(endOfCarousel);
  }
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
              SliverAppBar(
                automaticallyImplyLeading: false,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                pinned: true,
                forceElevated: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: 120,
                elevation: 2,
                actions: [
                  IconButton(
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.onBackground,
                    iconSize: 32,
                    icon: Icon(Icons.search),
                    tooltip: "Search",
                  ),
                  IconButton(
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.onBackground,
                    icon: Icon(Icons.menu),
                    iconSize: 38,
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
                        BlocBuilder<PetBloc, PetState>(
                          bloc: petBloc,
                          builder: (petContext, petState) {
                            return Text(petState.selectedPet?.petName ?? "",
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold));
                            },
                        ),
                        const Text(
                          "반려인님",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text("나의 반려동물 등록해요 📌", style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                          fontWeight: FontWeight.bold
                        )),
                      ),
                      //! Pet Cards Carousel
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            height: 324,
                            width: MediaQuery.of(context).size.width,
                            child: PetCardCarousel(petBloc: petBloc, fecesBloc: fecesBloc, callback: callBack,),
                          ),

                            Visibility(
                              visible: endOfCarousel,
                              child: Container(
                                margin: const EdgeInsets.only(right: 36),
                                child: FloatingActionButton(
                                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                  onPressed: () {
                                    context.push(PetRegisterPage.id);
                                  },
                                  child: const Icon(Icons.add),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 16,),
                      //! Health Check Options
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("건강체크 해볼까요 ✨", style: TextStyle(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                  fontWeight: FontWeight.bold
                              )),
                            ),
                            const SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //! Feces Diagnosis
                                Expanded(
                                  flex: 1,
                                  child: BlocBuilder<HealthCheckBloc, HealthCheckState>(
                                    bloc: fecesBloc,
                                    builder: (fecesContext, fecesState) {
                                      return Card(
                                        surfaceTintColor: null,
                                        color: Theme.of(context).colorScheme.surface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
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
                                            }
                                            );
                                          },
                                          child: SizedBox(
                                            height: 130,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  title: Text("건강케어",
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onSurface,
                                                      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  subtitle: Text("배변사진 체크",
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onSurface,
                                                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                                                    ),
                                                  ),
                                                  trailing: Image.asset("assets/img/feces_icon.png"),
                                                ),
                                              ], //TODO: Add icon image
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    surfaceTintColor: null,
                                    color: Theme.of(context).colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: SizedBox(
                                      height: 130,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ListTile(
                                            title: Text("맞춤케어",
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            subtitle: Text("식사량 체크",
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                                              ),
                                            ),
                                            trailing: Image.asset("assets/img/food_icon.png"),
                                          ),
                                        ], //TODO: Add icon image
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    surfaceTintColor: null,
                                    color: Theme.of(context).colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: SizedBox(
                                      height: 130,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ListTile(
                                            title: Text("검진케어",
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            subtitle: Text("진료/검진 체크",
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                                              ),
                                            ),
                                            trailing: Image.asset("assets/img/calendar_icon.png"),
                                          ),
                                        ], //TODO: Add icon image
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    surfaceTintColor: null,
                                    color: Theme.of(context).colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: SizedBox(
                                      height: 130,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ListTile(
                                            title: Text("산책케어",
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                  fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            subtitle: Text("산책량 체크",
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                                              ),
                                            ),
                                            trailing: Image.asset("assets/img/walk_icon.png"),
                                          ),
                                        ], //TODO: Add icon image
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    surfaceTintColor: null,
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          title: Text("케어 기록 보기",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                                              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          subtitle: Text("체크 기록이 없어요",
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                                              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                                            ),
                                          ),
                                        ),
                                      ], //TODO: Add icon image
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16,),
                            Text("이번 주 예정사항 있어요 ✅", style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                fontWeight: FontWeight.bold
                            )),
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
                                          subtitle: const Text("🕒 2023.03.13 17:30"),
                                        ),
                                      ], //TODO: Add icon image
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
