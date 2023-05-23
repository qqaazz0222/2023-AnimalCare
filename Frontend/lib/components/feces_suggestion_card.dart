import 'package:flutter/material.dart';

class FecesSuggestionCard extends StatelessWidget {
  // final care_card_logo
  final String fecesSuggestionCardTitle;
  final String fecesSuggestionCardSubtitle;
  final String fecesSuggestionCardSubSubtitle;
  final String fecesSuggestionCardIconPath;

  const FecesSuggestionCard({
    Key? key,
    required this.fecesSuggestionCardTitle,
    required this.fecesSuggestionCardSubtitle,
    required this.fecesSuggestionCardSubSubtitle,
    required this.fecesSuggestionCardIconPath}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        leading: SizedBox(height: double.infinity, child: Image(image: AssetImage(fecesSuggestionCardIconPath), width: 60)),
        title: Text(fecesSuggestionCardTitle, style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            fontWeight: FontWeight.bold
        ),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fecesSuggestionCardSubtitle, style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize
            ),),
            Text(fecesSuggestionCardSubSubtitle, style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize
            ),),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}