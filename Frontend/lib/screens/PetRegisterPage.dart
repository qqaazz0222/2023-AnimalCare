import 'dart:convert';

import 'package:animal_care_flutter_app/utils/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PetRegisterPage extends StatefulWidget {
  const PetRegisterPage({Key? key}) : super(key: key);
  static String id = "/petRegister";

  @override
  State<PetRegisterPage> createState() => _PetRegisterPageState();
}

class _PetRegisterPageState extends State<PetRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _gender;
  final _birthdayController = TextEditingController();
  final _adoptionDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _secureStorage = SecureStorage();

  // Function to select date from 1900 until today
  Future<void> _selectDate(
      BuildContext context, TextEditingController myDateController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}";
      myDateController.text = formattedDate;
    }
  }

  // Post entered data to the server
  Future<void> _sendDataToApi() async {
    final petRegisterUrl = Uri.parse("${Server.serverUrl}/pet/register");
    final response = await http.post(
      petRegisterUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'petName':_nameController.text,
        'petSex': _gender,
        'petBirthYear': _birthdayController.text.substring(0,4),
        'petBirthMonth': _birthdayController.text.substring(5),
        'petAdoptYear': _adoptionDateController.text.substring(0,4),
        'petAdoptMonth':_adoptionDateController.text.substring(5),
        'petWeight': _weightController.text,
        'uid': await _secureStorage.getUserName() ?? '',
      })
    );

    // print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Registration"),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("우리집 강아지를"),
                    Text("소개해 주세요!"),
                    Text("일부 정보를 간편하게 입력받을 수 있어요."),
                    Text("동물등록번호 입력하기"),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "이름은 무엇인가요?",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter pet's name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Gender:',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 'male',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                        Text('Male'),
                        SizedBox(width: 32),
                        Radio(
                          value: 'female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Birthday'),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _adoptionDateController,
                      decoration: InputDecoration(
                          labelText: 'YYYY-MM',
                          suffixIcon: GestureDetector(
                              onTap: () =>
                                  _selectDate(context, _adoptionDateController),
                              child: Icon(Icons.calendar_today))),
                    ),
                    SizedBox(height: 16),
                    Text('Adoption Date'),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _birthdayController,
                      decoration: InputDecoration(
                          labelText: 'YYYY-MM',
                          suffixIcon: GestureDetector(
                              onTap: () =>
                                  _selectDate(context, _birthdayController),
                              child: Icon(Icons.calendar_today))),
                    ),
                    SizedBox(height: 16),
                    Text("Pet's Weight"),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Weight",
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter pet's weight";
                        }
                        return null;
                      },
                    ),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => _sendDataToApi(),
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
