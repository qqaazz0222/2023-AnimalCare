import 'dart:io';

import 'package:animal_care_flutter_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pet_bloc/pet_bloc.dart';

//? Primary Color Background
class MyAppBarPrimary extends StatelessWidget implements PreferredSizeWidget {
  final double appbarSize;
  final String petName;
  final String? subtitle;
  final File? petImg;

  const MyAppBarPrimary({
    required this.appbarSize,
    Key? key,
    required this.petName,
    this.subtitle, required this.petImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () => {
          //     Navigator.of(context).pop()},
          //   color: Colors.black,
          // ),
          toolbarHeight: appbarSize,
          elevation: 0,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   color: Colors.black,
            //   iconSize: 32,
            //   icon: Icon(Icons.search),
            //   tooltip: "Search",
            // ),
            // IconButton(
            //   onPressed: () {},
            //   color: Colors.black,
            //   icon: Icon(Icons.menu),
            //   iconSize: 32,
            //   tooltip: "Navigation",
            // ),
          ],
          titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize),
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => HomePage())
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (petImg != null)
                      ClipOval(
                        child: Image.file(
                            petImg!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60),
                      ),
                    if (petImg == null)
                      ClipOval(
                        clipBehavior: Clip.hardEdge,
                        child: Image(
                            image: AssetImage("assets/img/no_image.png"),
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60),
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(petName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                if (subtitle != null)
                  SizedBox(height: 12,),
                  Row(
                    children: [
                      Text(subtitle!, style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                      ),)
                    ],
                  )

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appbarSize);
}

//? White Appbar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appbarSize;
  final String petName;
  final File? petImg;

  const MyAppBar({
    required this.appbarSize,
    Key? key,
    required this.petName, required this.petImg,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () => {
          //     Navigator.of(context).pop()},
          //   color: Colors.black,
          // ),
          toolbarHeight: appbarSize,
          elevation: 0,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   color: Colors.black,
            //   iconSize: 32,
            //   icon: Icon(Icons.search),
            //   tooltip: "Search",
            // ),
            // IconButton(
            //   onPressed: () {},
            //   color: Colors.black,
            //   icon: Icon(Icons.menu),
            //   iconSize: 32,
            //   tooltip: "Navigation",
            // ),
          ],
          titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize),
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => HomePage())
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (petImg != null)
                      ClipOval(
                        child: Image.file(
                            petImg!,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60),
                      ),
                    if (petImg == null)
                        ClipOval(
                          child: Image(
                              image: AssetImage("assets/img/no_image.png"),
                              width: 60,
                              height: 60),
                        ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(petName,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appbarSize);
}