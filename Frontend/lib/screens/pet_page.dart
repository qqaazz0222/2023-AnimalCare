import 'dart:async';

import 'package:animal_care_flutter_app/bloc/pet_bloc/pet_bloc.dart';
import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:animal_care_flutter_app/screens/feces_care_page.dart';
import 'package:animal_care_flutter_app/screens/feces_diagnosis_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/health_check_bloc/health_check_bloc.dart';
import '../components/care_card.dart';

class PetPage extends StatefulWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  @override
  Widget build(BuildContext context) {
    //? Initialize new fecesBloc and get petBloc from the previous page
    final petBloc = BlocProvider.of<PetBloc>(context);
    final fecesBloc = HealthCheckBloc();
    //? Wrapping with BlocBuilder to access the BlocProvider from the main page
    return BlocProvider(
      create: (context) => fecesBloc,
      child: BlocBuilder<PetBloc, PetState>(
        bloc: petBloc,
        builder: (petContext, petState) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: MyAppBarPrimary(
              appbarSize: 140,
              petName: petState.selectedPet?.petName ?? "Your Pet",
              subtitle: "주기적인 건강체크, 잊지마세요 ✔",
              petImg: petState.selectedPet?.petImg,
            ),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
                          color: Theme.of(context).colorScheme.background
                        ),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //! Show this when loading data from the database
                                  if (petState.isLoading)
                                    const CircularProgressIndicator(),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    "케어 캘린더",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  //TODO: Create calendar widget
                                  //! Calendar widget
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: -3,
                                            blurRadius: 12,
                                            offset: const Offset(0, 3),
                                          )
                                        ]),
                                    child: Card(
                                      elevation: 0,
                                      surfaceTintColor:
                                          Theme.of(context).colorScheme.background,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 12,),
                                          SizedBox(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: TableCalendar(
                                              firstDay: DateTime.utc(2010, 10, 16),
                                              lastDay: DateTime.utc(2030, 3, 14),
                                              focusedDay: DateTime.now(),
                                              calendarStyle: CalendarStyle(
                                                todayDecoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  shape: BoxShape.circle
                                                ),
                                                selectedDecoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.primary)
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40,),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "오늘 케어 기록",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  //! List of Pet Care options
                                  Container(
                                    child: ListView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        //TODO: Get card status from database
                                        //? Using BlocListener to receive updates when changes happen
                                        BlocBuilder<HealthCheckBloc,
                                            HealthCheckState>(
                                          builder: (fecesContext, fecesState) {
                                            return InkWell(
                                              onTap: () async {
                                                fecesBloc.add(
                                                    GetLastHealthCheckEvent(petState
                                                        .selectedPet!.petId));
                                                late StreamSubscription<
                                                        HealthCheckState>
                                                    fecesStateSubscription;
                                                fecesStateSubscription = fecesBloc
                                                    .stream
                                                    .listen((fecesState) {
                                                  if (fecesState
                                                              .lastHealthCheckResults ==
                                                          null &&
                                                      !fecesState.isLoading) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider.value(
                                                                value: petBloc),
                                                            BlocProvider.value(
                                                                value: fecesBloc),
                                                          ],
                                                          child: FecesCarePage(),
                                                        ),
                                                      ),
                                                    );
                                                    // Cancel the subscription to avoid memory leaks
                                                    fecesStateSubscription.cancel();
                                                  } else if (fecesState
                                                              .lastHealthCheckResults !=
                                                          null &&
                                                      !fecesState.isLoading) {
                                                    print(
                                                        "PetPage: There are some records");
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            MultiBlocProvider(
                                                          providers: [
                                                            BlocProvider.value(
                                                                value: petBloc),
                                                            BlocProvider.value(
                                                                value: fecesBloc),
                                                          ],
                                                          child:
                                                              FecesDiagnosisPage(),
                                                        ),
                                                      ),
                                                    );
                                                    // Cancel the subscription to avoid memory leaks
                                                    fecesStateSubscription.cancel();
                                                  }
                                                }
                                              );
                                            },
                                            child: const CareCard(
                                              careCardTitle: "건강케어",
                                              careCardSubtitle: "배변사진 체크기록이 없어요",
                                              careCardStatus: false,
                                              careCardIconPath:
                                                  "assets/img/feces_icon.png",
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      //TODO: add Navigation for other buttons
                                      CareCard(
                                        careCardTitle: "맞춤케어",
                                        careCardSubtitle: "식사량 체크기록이 있어요",
                                        careCardStatus: true,
                                        careCardIconPath:
                                            "assets/img/food_icon.png",
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      CareCard(
                                        careCardTitle: "검진케어",
                                        careCardSubtitle: "진료/검진 기록이 있어요",
                                        careCardStatus: true,
                                        careCardIconPath:
                                            "assets/img/calendar_icon.png",
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      CareCard(
                                        careCardTitle: "산책케어",
                                        careCardSubtitle: "산책량 체크기록이 없어요",
                                        careCardStatus: false,
                                        careCardIconPath:
                                            "assets/img/walk_icon.png",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              ),
                          ],
                        ),
                    ),
                      )
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
