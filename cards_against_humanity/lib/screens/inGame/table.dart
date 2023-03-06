import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCard =
        Provider.of<MqttClientWrapper>(context).lobby!.currentBlackCard;
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.65,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Center(
        child: AutoSizeText(
          maxLines: 5,
          wrapWords: false,
          currentCard!.text.replaceAll("_", "_______"),
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}
