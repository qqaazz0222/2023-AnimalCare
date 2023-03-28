import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PetCardCarousel extends StatefulWidget {
  const PetCardCarousel({Key? key}) : super(key: key);

  @override
  State<PetCardCarousel> createState() => _PetCardCarouselState();
}

class _PetCardCarouselState extends State<PetCardCarousel> {

  List<dynamic> _dataList = [];

  Future<List<dynamic>> fetchData() async {
    final response =
    await http.get(Uri.parse('http://your_flask_api_endpoint.com'));

    if (response.statusCode == 200) {
      final List<dynamic> parsedList = json.decode(response.body);
      return parsedList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 280,
      // child: ListView.builder(
      //   scrollDirection: Axis.horizontal,
      //   itemCount: ,
      // ),
    );
  }
}
