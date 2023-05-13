import 'dart:convert';

import 'package:animal_care_flutter_app/screens/login_page.dart';
import 'package:animal_care_flutter_app/screens/pet_register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;

import '../utils/AppConfig.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static String id = "/signup";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false;
  String? _errorMessage;

  bool? _agreedToTerms = false;

  void _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final signupUrl = Uri.parse('${Server.serverUrl}/user/signup');
    final response = await http.post(
      signupUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': _usernameController.text,
        'upw': _passwordController.text,
        'uname': _nameController.text,
        'uemail': _emailController.text,
      }),
    );
    final responseJson = jsonDecode(response.body);

    switch (responseJson["code"]) {
      case 0:
        print(responseJson["msg"]);
        if (context.mounted) {
          context.push(PetRegisterPage.id);
        }
        break;
      case 5:
        print(responseJson["msg"]);
        //TODO: Handle existing Username
        break;
      case 6:
        print(responseJson["msg"]);
        //TODO: Handle Database Problem
        break;
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Scaffold - basic layout with FAB
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Signup Page",
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: EdgeInsets.all(24),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //? Icon and Welcome text
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/img/logo.png'),
                            height: 100,
                            width: 100,
                          ),
                          const Text("건강한 견생의 일상"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("푸푸케어",
                                  style: TextStyle(color: Theme.of(context).primaryColor)),
                              Text("에서 함께 해주세요")
                            ],
                          )
                        ],
                      ),
                    ),

                    //TODO: Add validators to TextFormFields
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          //? Email Sign Up
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _emailController.text = value;
                              });
                            },
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email',
                            ),
                          ),

                          SizedBox(height: 15,),

                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _usernameController.text = value;
                              });
                            },
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Username',
                            ),
                          ),

                          SizedBox(height: 15,),

                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                _nameController.text = value;
                              });
                            },
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Full Name',
                            ),
                          ),

                          SizedBox(height: 15,),

                          TextFormField(
                            // textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                _passwordController.text = value;
                              });
                            },
                            autocorrect: false,
                            obscureText: true,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Password',
                            ),
                          ),

                          SizedBox(height: 15,),


                          TextFormField(
                            // textAlign: TextAlign.center,
                            autocorrect: false,
                            obscureText: true,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Confirm Password',
                            ),
                          ),

                          CheckboxListTile(
                              value: _agreedToTerms,
                              title: Text("I agree with Terms of Conditions"),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value){
                                setState(() {
                                  _agreedToTerms = value;
                                });
                              }),

                          SizedBox(height: 15,),

                          Container(
                            width: double.infinity,
                            child: ProgressButton(
                              stateWidgets: {
                                ButtonState.idle: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                ButtonState.loading: Text(
                                  "Loading",
                                  style: TextStyle(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Do not use
                                ButtonState.fail: Text(
                                  "Fail",
                                  style: TextStyle(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                ButtonState.success: Text(
                                  "Success",
                                  style: TextStyle(
                                      color: Theme.of(context).scaffoldBackgroundColor,
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
                                print(_usernameController.text);
                                print(_passwordController.text);
                                _handleSignup();
                              },
                              state: _isLoading
                                  ? ButtonState.loading
                                  : ButtonState.idle,
                            ),
                          ),

                          SizedBox(height: 15,),

                          //TODO: Handle Kakao Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.mail_outline_outlined),
                                label: const Text("카카오로 가입하기"),
                              ),

                              //TODO: Handle Google Sign Up
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.mail_outline_outlined),
                                label: const Text("Gmail로 가입하기"),
                              ),
                            ],
                          ),

                          //? Already Have an account?
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: "이미 가입하셨나요? "),
                            TextSpan(
                                style: TextStyle(color: Theme.of(context).disabledColor),
                                text: "로그인하기",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.go(LoginPage.id);
                                  } //TODO: Add route to Login Page
                            ),
                          ])),
                        ],
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
