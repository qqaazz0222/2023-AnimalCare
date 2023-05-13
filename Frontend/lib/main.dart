import 'dart:convert';

import 'package:animal_care_flutter_app/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:animal_care_flutter_app/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final themeStr = await rootBundle.loadString('assets/theme/appainter_theme.json');
  // final themeJson = jsonDecode(themeStr);
  // final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme)));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: myRouter,
    );
  }
}
