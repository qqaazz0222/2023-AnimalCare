import 'package:flutter/material.dart';

class CareCard extends StatelessWidget {
  // final care_card_logo
  final String careCardTitle;
  final String careCardSubtitle;
  final bool careCardStatus;

  const CareCard(
      {Key? key, required this.careCardTitle, required this.careCardSubtitle, required this.careCardStatus}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget trailing;
    if(careCardStatus){
      trailing = const Icon(Icons.check_circle, color: Colors.green,);
    }else{
      trailing = const Icon(Icons.check_circle, color: Colors.grey,);
    }

      return Card(
      child: ListTile(
        //TODO: get image from assets
        leading: Image.asset("assets/img/logo.png"),
        title: Text(careCardTitle),
        subtitle: Text(careCardSubtitle),
        trailing: trailing,
        isThreeLine: true,
      ),
    );
  }
}
