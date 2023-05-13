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

  const PetCardCarousel({Key? key, required this.petBloc, required this.fecesBloc}) : super(key: key);

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
      return InkWell(
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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: 200,
            height: 270,
            child: Column(
              children: [
                //TODO: Parse image from a bytecode format
                // item[8] ??
                Image(
                  image: AssetImage("assets/img/no_image.png"),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(item[1]),
                Text(item[2]) //TODO: Change to dog breed
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
          return CarouselSlider(
            items: data.map((item) => buildCard(item)).toList(),
            options: CarouselOptions(
              //? Allows us to select focused card
              onPageChanged: (index, reason){
                setState(() {
                  currentPet = data[index];
                });
              },
              height: 400,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              disableCenter: true,
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