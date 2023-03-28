import 'package:flutter/material.dart';

class PetCard extends StatefulWidget {
  const PetCard({Key? key}) : super(key: key);

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {
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
            Text("Name"),
            Text("Breed")
          ],
        ),
      ),
    );
  }
}
