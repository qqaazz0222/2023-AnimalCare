import 'package:animal_care_flutter_app/bloc/pet_bloc/pet_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animal_care_flutter_app/utils/AppConfig.dart';
import '../screens/pet_page.dart';

class PetCardCarousel extends StatelessWidget {
  final PetBloc petBloc;

  const PetCardCarousel({Key? key, required this.petBloc,}) : super(key: key);

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
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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
                        value: petBloc,
                        child: PetPage(),
              ),
            ),
          );
          petBloc.add(SelectPetEvent(item[0]));
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