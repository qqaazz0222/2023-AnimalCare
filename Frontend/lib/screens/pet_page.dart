import 'package:animal_care_flutter_app/bloc/pet_bloc/pet_bloc.dart';
import 'package:animal_care_flutter_app/components/MyAppBar.dart';
import 'package:animal_care_flutter_app/screens/feces_care_page.dart';
import 'package:animal_care_flutter_app/screens/feces_diagnosis_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/health_check_bloc/health_check_bloc.dart';
import '../components/care_card.dart';

class PetPage extends StatelessWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOnThisPage = true;
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
            backgroundColor: Colors.grey,
            appBar: MyAppBar(
                appbarSize: 140,
                petName: petState.selectedPet?.petName ?? "Your Pet"),
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
                            //! Show this when loading data from the database
                            if (petState.isLoading)
                              const CircularProgressIndicator(),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "케어 캘린더",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            //TODO: Create calendar widget
                            //! Calendar widget
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
                            //! List of Pet Care options
                            Container(
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  //TODO: Get card status from database
                                  //? Using BlocListener to receive updates when changes happen
                                  BlocListener<HealthCheckBloc,
                                      HealthCheckState>(
                                    //? Restrict reading updates when on the different page
                                    listenWhen: (previousState, currentState) {
                                      return isOnThisPage;
                                    },
                                    listener: (fecesContext, fecesState) {
                                      //? Navigate to FecesCarePage when no updates found
                                      // print("Last Health Check Results: ${fecesState.lastHealthCheckResults}");
                                      // print("Is Loading: ${fecesState.isLoading}");
                                      if (fecesState.lastHealthCheckResults == null && fecesState.isLoading == false) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MultiBlocProvider(
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
                                        isOnThisPage = false;
                                      }
                                      //? Once getting data from the database move to FecesDiagnosisPage with latest record
                                      if ((fecesState.lastHealthCheckResults != null && fecesState.isLoading == false)) {
                                        print("PetPage: There are some records");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(
                                                      value: petBloc),
                                                  BlocProvider.value(
                                                      value: fecesBloc),
                                                ],
                                                child: FecesDiagnosisPage(),
                                              ),
                                            ));
                                        //? Needed for ignoring changes in different page
                                        isOnThisPage = false;
                                      }
                                    },
                                    child: InkWell(
                                        onTap: () {
                                          //? Getting the latest health check record
                                          fecesBloc.add(GetLastHealthCheckEvent(petState.selectedPet!.petId));
                                        },
                                        child: const CareCard(
                                          careCardTitle: "건강케어",
                                          careCardSubtitle: "배변사진 체크기록이 없어요",
                                          careCardStatus: false,
                                        )),
                                  ),
                                  //TODO: add Navigation for other buttons
                                  const CareCard(
                                    careCardTitle: "맞춤케어",
                                    careCardSubtitle: "식사량 체크기록이 있어요",
                                    careCardStatus: true,
                                  ),
                                  const CareCard(
                                    careCardTitle: "검진케어",
                                    careCardSubtitle: "진료/검진 기록이 있어요",
                                    careCardStatus: true,
                                  ),
                                  const CareCard(
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
      ),
    );
  }
}
