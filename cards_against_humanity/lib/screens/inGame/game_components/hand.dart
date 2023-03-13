import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hand extends StatelessWidget {
  const Hand({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttWrapper = Provider.of<MqttClientWrapper>(context);
    final userData = Provider.of<User>(context, listen: false);
    final hand = mqttWrapper.hand!;
    final lobby = mqttWrapper.lobby!;
    final numberOfBlanks = lobby.currentBlackCard!.numberOfBlanks;
    final currentBlackCard = lobby.currentBlackCard!;
    final isMyTurn = lobby.isMyTurn(userData.playerData.id);
    bool canAdd() {
      return currentBlackCard.placedCards.length < numberOfBlanks;
    }

    void placeCard(double index) {
      mqttWrapper.placeCard(hand.singleWhere((c) => c.id == index));
      hand.removeWhere((c) => c.id == index);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 150,
      child: ScrollConfiguration(
        behavior: _MyBehavior(),
        child: isMyTurn
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.center,
                  "Wait for the players to pick . . .",
                  style: Theme.of(context).textTheme.headline4,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ...hand
                        .map(
                          (e) => CardItem(
                              key: ValueKey(e.id),
                              text: e.text,
                              index: e.id.toDouble(),
                              canAdd: canAdd,
                              placeCard: placeCard),
                        )
                        .toList(),
                  ],
                ),
              ),
      ),
    );
  }
}

class _MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class CardItem extends StatefulWidget {
  const CardItem(
      {super.key,
      required this.text,
      required this.index,
      required this.canAdd,
      required this.placeCard});
  final String text;
  final double index;
  final Function canAdd;
  final Function placeCard;
  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _isSelected = !_isSelected;
      }),
      child: Dismissible(
          key: ValueKey(widget.index),
          direction: DismissDirection.up,
          onDismissed: (direction) => widget.placeCard(widget.index),
          confirmDismiss: (direction) {
            return Future.value(widget.canAdd());
          },
          child: Container(
            width: _isSelected ? 200 : 150,
            height: _isSelected ? 200 : 150,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: const Color(0xFFFFFFFF),
              ),
              color: Colors.grey,
            ),
            child: AutoSizeText(
              maxLines: 8,
              widget.text,
              wrapWords: false,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
    );
  }
}
