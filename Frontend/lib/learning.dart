// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   // Using MaterialApp widget to include styles and features
//   runApp(const MaterialApp(
//     home: Home()
//   ));
// }
//
// // Using StatelessWidget allows updating Widgets without reloading whole app
// // Now, instead of clicking hot-reload, update results after saving
// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold - basic layout with FAB
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My First App",),
//         backgroundColor: Colors.green[400],
//       ),
//       body:
//
//       // Center(
//       //   child:
//       // );
//
//       //? Images
//       // Image(
//           // image: NetworkImage("https://img.freepik.com/free-photo/cat_658691-312.jpg?w=1380&t=st=1679238425~exp=1679239025~hmac=66d8df6916c5cbfd41e315a82a3dd842e04dea5374c0d175a971e5f8cc20b4f6"),
//           // image: AssetImage('static/img/puppy.jpg')
//       //? Shorter Version of the previous lines
//       // Image.network("https://img.freepik.com/free-photo/cat_658691-312.jpg?w=1380&t=st=1679238425~exp=1679239025~hmac=66d8df6916c5cbfd41e315a82a3dd842e04dea5374c0d175a971e5f8cc20b4f6")
//       // Image.asset("static/img/puppy.jpg"),
//
//       //? Icons
//       // Icon(
//       //   Icons.airport_shuttle_rounded,
//       //   color: Colors.blue,
//       //   size: 50.0,
//       // ),
//
//       //? Elevated Button
//       // ElevatedButton(
//       //   onPressed: () {},
//       //   style: ElevatedButton.styleFrom(
//       //     backgroundColor: Colors.amberAccent,
//       //   ),
//       //   child: const Text(
//       //     "Click Me",
//       //     style: TextStyle(
//       //       color: Colors.black54,
//       //       fontFamily: 'Rubik',
//       //       fontWeight: FontWeight.bold,
//       //       fontSize: 24.0,
//       //     ),
//       //   ),
//       // ),
//
//       //? Normal Button
//       // TextButton(
//       //   onPressed: () {
//       //     print("You Clicked me");
//       //   },
//       //   style: TextButton.styleFrom(backgroundColor: Colors.amberAccent,
//       //   ),
//       //   child: const Text(
//       //     "Click Me",
//       //     style: TextStyle(
//       //       color: Colors.black54,
//       //       fontFamily: 'Rubik',
//       //       fontWeight: FontWeight.bold,
//       //       fontSize: 24.0,
//       //     ),
//       //   ),
//       // ),
//
//       //? Button with Icon and Text
//       // ElevatedButton.icon(
//       //   onPressed: () { },
//       //   icon: const Icon(Icons.mail_outlined),
//       //   label: const Text("Send Message"),
//       //   style: ElevatedButton.styleFrom(
//       //     backgroundColor: Colors.amber,
//       //     foregroundColor: Colors.black),
//       // ),
//
//       //? Icon Button
//       // IconButton(
//       //   icon: const Icon(Icons.delete_forever_outlined),
//       //   onPressed: () {  },
//       // )
//
//       //? Container
//       // Container(
//       //   color: Colors.red[100],
//       //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
//       //   margin: const EdgeInsets.all(40.0),
//       //   child: const Text("Hello, World!"),
//       // ),
//
//       //? Padding
//       // const Padding(
//       //   padding: EdgeInsets.all(100),
//       //   child: Text("Hello World!"),
//       // ),
//
//
//       //? Adding Multiple objects using Row
//       // Row(
//       //   // Control position of items on the main (x) axis
//       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //   // Control position of items on the cross (y) axis
//       //   crossAxisAlignment: CrossAxisAlignment.start,
//       //
//       //   children: <Widget>[
//       //     const Text("Hello, World!"),
//       //     TextButton(
//       //       onPressed: () {},
//       //       style: TextButton.styleFrom(backgroundColor: Colors.amberAccent, foregroundColor: Colors.black),
//       //       child: const Text("Click-Clack"),
//       //     ),
//       //     Container(
//       //       color: Colors.lightGreen,
//       //       padding: const EdgeInsets.all(40.0),
//       //       child: const Text("My Container"),
//       //     )
//       //   ],
//       // ),
//
//       //? Stacking multiple Widgets using Column
//       // Center(
//       //   child:
//       //   Column(
//       //     // In Columns mainAxisAlignment is a vertical axis
//       //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //     // While crossAxisAlignment is a horizontal axis
//       //     crossAxisAlignment: CrossAxisAlignment.center,
//       //     children: [
//       //       // We can add Rows inside of Columns combination
//       //       Row(
//       //         // Control position of items on the main (x) axis
//       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //         // Control position of items on the cross (y) axis
//       //         crossAxisAlignment: CrossAxisAlignment.center,
//       //
//       //         children: <Widget>[
//       //           const Text("Hello, World!"),
//       //           TextButton(
//       //             onPressed: () {},
//       //             style: TextButton.styleFrom(backgroundColor: Colors.amberAccent, foregroundColor: Colors.black),
//       //             child: const Text("Click-Clack"),
//       //           ),
//       //           Container(
//       //             color: Colors.lightGreen,
//       //             padding: const EdgeInsets.all(40.0),
//       //             child: const Text("My Container"),
//       //           )
//       //         ],
//       //       ),
//       //       Container(
//       //         padding: const EdgeInsets.all(20.0),
//       //         color: Colors.lightGreen,
//       //         child: const Text("First Container"),
//       //       ),
//       //       Container(
//       //         padding: const EdgeInsets.all(30.0),
//       //         color: Colors.pink[100],
//       //         child: const Text("Second Container"),
//       //       ),
//       //       Container(
//       //         padding: const EdgeInsets.all(40.0),
//       //         color: Colors.lightBlue,
//       //         child: const Text("Third Container"),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//
//       Row(
//         children: [
//           Expanded(
//               flex: 2,
//               child: Image.asset("static/img/puppy.jpg")
//           ),
//           // Expanded widget allows us to fill the remaining space
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: const EdgeInsets.all(30.0),
//               color: Colors.blue,
//               child: const Text("1"),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: const EdgeInsets.all(30.0),
//               color: Colors.green,
//               child: const Text("2"),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               padding: const EdgeInsets.all(30.0),
//               color: Colors.red,
//               child: const Text("3"),
//             ),
//           ),
//         ],
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {  },
//         backgroundColor: Colors.green[600],
//         child: const Text("Click"),
//       ),
//     );
//   }
// }
