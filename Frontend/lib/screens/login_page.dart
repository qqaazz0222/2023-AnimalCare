import 'dart:convert';

import 'package:animal_care_flutter_app/screens/home_page.dart';
import 'package:animal_care_flutter_app/screens/pet_register_page.dart';
import 'package:animal_care_flutter_app/screens/signup_page.dart';
import 'package:animal_care_flutter_app/utils/AppConfig.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:progress_state_button/progress_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final SecureStorage _secureStorage = SecureStorage();

  Future<int> _petGetListCount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final getPetListCountUrl =
        Uri.parse('${Server.serverUrl}/pet/getlist/countpets');
    final response = await http.post(
      getPetListCountUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': _usernameController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    return jsonDecode(response.body)[0];
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final loginUrl = Uri.parse('${Server.serverUrl}/user/signin');
    final response = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': _usernameController.text,
        'upw': _passwordController.text,
      }),
    );
    final responseJson = jsonDecode(response.body);
    // print("This is responseJson from Login Page: $responseJson");
    switch (responseJson["code"]) {
      case 0:
        await _secureStorage.setUserName(
            _usernameController.text); // Add UserID into Secure Storage
        final count = await _petGetListCount(); // Get the number of pets for entered user
        if (context.mounted) {
          if (count == 0) {
            context.push(PetRegisterPage.id); // Move to Pet Registration
          } else {
            context.push(HomePage.id);
          } //TODO: Switch to GO
          // Move to Home Page
        }
        break;
      case 3:
        print(responseJson["msg"]);
        //TODO: Handle non-existing ID
        break;
      case 4:
        print(responseJson["msg"]);
        //TODO: Handle Invalid password
        break;
    }

    setState(() {
      _isLoading = false;
    });
  }

  //:TODO: Implement keyboard behaviour.
  @override
  Widget build(BuildContext context) {
    // Scaffold - basic layout with FAB
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
                //TODO: Add Global margins
                margin: EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //? Logo and Welcome text
                        //TODO: Add TextFormFields validators
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/img/logo.png'),
                                height: 200,
                                width: 200,
                              ),
                              Text("건강한 견생의 일상", style: TextStyle(
                                color: Theme.of(context).colorScheme.onBackground,
                                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize
                              ),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("푸푸케어",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize
                                      )),
                                  Text("에서 함께 해주세요", style: TextStyle(
                                      color: Theme.of(context).colorScheme.onBackground,
                                      fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize
                                  ),)
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              //? Login Form
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    _usernameController.text = value;
                                  });
                                },
                                autocorrect: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Username',
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              TextFormField(
                                // textAlign: TextAlign.center,
                                autocorrect: false,
                                obscureText: true,
                                enableSuggestions: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Password',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _passwordController.text = value;
                                  });
                                },
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              //? Login Button
                              Container(
                                width: double.infinity,
                                child: ProgressButton(
                                  stateWidgets: {
                                    ButtonState.idle: Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize
                                      ),
                                    ),
                                    ButtonState.loading: Text(
                                      "Loading",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    // Do not use
                                    ButtonState.fail: Text(
                                      "Fail",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    ButtonState.success: Text(
                                      "Success",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )
                                  },
                                  stateColors: {
                                    ButtonState.idle: Theme.of(context).primaryColor,
                                    ButtonState.loading: Colors.grey.shade400,

                                    // Do not use
                                    ButtonState.fail: Colors.red.shade300,
                                    ButtonState.success: Colors.green.shade400,
                                  },
                                  onPressed: () async {
                                    // print(_usernameController.text);
                                    // print(_passwordController.text);
                                    _handleLogin();
                                  },
                                  state: _isLoading
                                      ? ButtonState.loading
                                      : ButtonState.idle,
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: "Forgot Login / ",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push(PetRegisterPage.id);
                                      } //TODO: Add route to a Forgot Login
                                    ),
                                TextSpan(
                                    text: "Forgot Password / ",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push(PetRegisterPage.id);
                                      } //TODO: Add route to Login Page
                                    ),
                                TextSpan(
                                    text: "Sign Up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push(SignupPage.id);
                                      }),
                              ])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
