import 'package:animal_care_flutter_app/bloc/health_check_bloc/health_check_bloc.dart';
import 'package:animal_care_flutter_app/bloc/pet_bloc/pet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animal_care_flutter_app/utils/AppConfig.dart';
import '../screens/pet_page.dart';

class PetCardCarousel extends StatefulWidget {
  final PetBloc petBloc;
  final HealthCheckBloc fecesBloc;
  final Function callback;

  const PetCardCarousel({Key? key, required this.petBloc, required this.fecesBloc, required this.callback}) : super(key: key);

  @override
  State<PetCardCarousel> createState() => _PetCardCarouselState();
}

class _PetCardCarouselState extends State<PetCardCarousel> {
  List<dynamic> currentPet = [];

  @override
  Widget build(BuildContext context) {
    final SecureStorage secureStorage = SecureStorage();

    Future<List<dynamic>> fetchData() async {
      final getPetList = Uri.parse("${Server.serverUrl}/pet/getlist");
      final response = await http.post(
        getPetList,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': await secureStorage.getUserName() ?? '',
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //? Set Current Pet
        if (currentPet.isEmpty){
          currentPet = data[0];
        }
        widget.petBloc.add(SelectPetEvent(currentPet[0]));
        // widget.fecesBloc.add(GetLastHealthCheckEvent(0));
        // print("PetCardCarousel: ${widget.petBloc.state.selectedPet?.petId}");
        // print("PetCardCarousel: $currentPet");
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    }

    Widget buildCard(dynamic item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Card(
          surfaceTintColor: Theme.of(context).colorScheme.background,
          color: Theme.of(context).colorScheme.background,
          elevation: 3,
          shape: RoundedRectangleBorder(
            // side: BorderSide(),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: widget.petBloc,
                    child: PetPage(),
                  ),
                ),
              );
              widget.petBloc.add(SelectPetEvent(item[0]));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: Parse image from a bytecode format
                // item[8] ??
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image(
                      image: AssetImage("assets/img/no_image.png"),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Text(item[1], style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                        fontWeight: FontWeight.bold
                      ),),
                      Text(item[2], style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                      ),),
                    ],
                  ),
                ) //TODO: Change to dog breed
              ],
            ),
          ),
        ),
      );
    }

    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: CarouselSlider(
              items: data.map((item) => buildCard(item)).toList(),
              options: CarouselOptions(
                viewportFraction: 0.5,
                //? Allows us to select focused card
                onPageChanged: (index, reason){
                  setState(() {
                    currentPet = data[index];
                    widget.callback(index == data.length-1);
                  });
                },
                height: 400,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                disableCenter: true,
                padEnds: true
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Failed to fetch data');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}