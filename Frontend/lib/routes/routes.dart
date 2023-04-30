import 'package:animal_care_flutter_app/main.dart';
import 'package:animal_care_flutter_app/screens/home_page.dart';
import 'package:animal_care_flutter_app/screens/login_page.dart';
import 'package:animal_care_flutter_app/screens/pet_page.dart';
import 'package:animal_care_flutter_app/screens/pet_register_page.dart';
import 'package:animal_care_flutter_app/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter myRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage(); //TODO: Switch to HomePage
      }
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignupPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/petRegister',
      builder: (BuildContext context, GoRouterState state) {
        return const PetRegisterPage();
      },
    ),
    //TODO: change to dynamic link (e.g. 'username/petId/')
    // GoRoute(
    //   path: '/petPage',
    //   name: 'petPage',
    //   builder: (BuildContext context, state) => PetPage()
    // )
  ],
);
