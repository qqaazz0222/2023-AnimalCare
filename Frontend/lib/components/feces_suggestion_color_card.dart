import 'package:flutter/material.dart';

class FecesSuggestionColorCard extends StatelessWidget {
  // final care_card_logo
  final Color? color;
  final bool visibility;

  const FecesSuggestionColorCard({
    Key? key,
    required this.color, required this.visibility}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      //? Hide image if visibility is False
      visible: visibility,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Card(
        elevation: 3,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.background,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          // side: border,
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            height: 72,
            width: 72,
            child: Icon(Icons.circle, color: color,)
          ),
        ),
      ),
    );
  }
}