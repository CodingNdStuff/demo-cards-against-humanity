import 'package:cards_against_humanity/models/black_card.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key, required this.currentCard});
  final BlackCard currentCard;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.65,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Center(
        child: Text(
          parseText,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }

  String get parseText {
    return currentCard.text.replaceAll("_", "_______");
  }
}
