import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animal_care_flutter_app/utils/AppConfig.dart';

class PetCardCarousel extends StatefulWidget {
  const PetCardCarousel({super.key});


  @override
  _PetCardCarouselState createState() => _PetCardCarouselState();
}

class _PetCardCarouselState extends State<PetCardCarousel> {

  List<dynamic> _data = [];
  String? uid;

  final SecureStorage _secureStorage = SecureStorage();

  Future<void> _fetchData() async {

    final getPetList = Uri.parse("${Server.serverUrl}/pet/getlist");
    final response = await http.post(
      getPetList,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': await _secureStorage.getUserName() ?? '',
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
        print(_data);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _data.map((item) => _buildCard(item)).toList(),
      options: CarouselOptions(
        height: 400,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        disableCenter: true,


      ),
    );
  }

  Widget _buildCard(dynamic item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: 200,
        height: 270,
        child: Column(
          children: [
            //TODO: Extract Pet data from the server
            Image(image: AssetImage("assets/img/puppy.jpg"), width: 200, height: 200, fit: BoxFit.cover,),
            Text(item[2]),
            Text("Breed")
          ],
        ),
      ),
    );
  }
}