import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appbarSize;

  const MyAppBar({required this.appbarSize, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: appbarSize,
        elevation: 0,
        shadowColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            color: Colors.black,
            iconSize: 32,
            icon: Icon(Icons.search),
            tooltip: "Search",),
          IconButton(
            onPressed: () {},
            color: Colors.black,
            icon: Icon(Icons.menu),
            iconSize: 32,
            tooltip: "Navigation",),
        ],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 32),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("안녕하세요"),
              ],
            ),
            Row(
              children: [
                //TODO: Change the name of the Pet
                Text("봉쥬르", style: TextStyle(color: Colors.green)),
                const Text("반려인님", style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ],
        ),
      );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appbarSize);
}
