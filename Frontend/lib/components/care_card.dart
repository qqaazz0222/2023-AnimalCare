import 'package:flutter/material.dart';

class CareCard extends StatelessWidget {
  // final care_card_logo
  final String careCardTitle;
  final String careCardSubtitle;
  final bool careCardStatus;
  final String careCardIconPath;

  const CareCard({
    Key? key,
    required this.careCardTitle,
    required this.careCardSubtitle,
    required this.careCardStatus,
    required this.careCardIconPath}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget trailing;
    // final BorderSide border;
    if(careCardStatus){
      trailing = Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary,);
      // border = BorderSide.none;
    }else{
      trailing = Icon(Icons.check_circle, color: Colors.grey,);
    }

      return Card(
        elevation: 3,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.background,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          // side: border,
          borderRadius: BorderRadius.circular(24),
        ),
        child: ListTile(
          leading: Image(image: AssetImage(careCardIconPath), width: 60,),
          title: Text(careCardTitle, style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text(careCardSubtitle, style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize
          ),),
          trailing: trailing,
          isThreeLine: false,
        ),
    );
  }
}
