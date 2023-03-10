import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Hand extends StatelessWidget {
  Hand({super.key});

  @override
  Widget build(BuildContext context) {
    final MqttWrapper = Provider.of<MqttClientWrapper>(context);
    final hand = MqttWrapper.hand!;
    final numberOfBlanks = MqttWrapper.lobby!.currentBlackCard!.numberOfBlanks;
    final currentBlackCard = MqttWrapper.lobby!.currentBlackCard!;
    bool canAdd() {
      return currentBlackCard.placedCards.length < numberOfBlanks;
    }

    void placeCard(double index) {
      MqttWrapper.placeCard(hand.singleWhere((c) => c.id == index),
          currentBlackCard.placedCards.length);
      hand.removeWhere((c) => c.id == index);
      print("Played card");
      print(MqttWrapper.lobby!.currentBlackCard);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 200,
      child: ScrollConfiguration(
        behavior: _MyBehavior(),
        child: SingleChildScrollView(
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

  void _handleStartGame() {
    SchedulerBinding.instance.addPostFrameCallback((_) {});
  }

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
            //   return showDialog(
            //       context: context,
            //       builder: (ctx) => AlertDialog(
            //             title: const Text("Are you sure?"),
            //             content: const Text(
            //               "Do you want to remove the item from the cart?",
            //             ),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () => Navigator.of(ctx).pop(false),
            //                 child: Text(
            //                   "Keep it",
            //                   style: TextStyle(
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                 ),
            //               ),
            //               TextButton(
            //                 onPressed: () => Navigator.of(ctx).pop(true),
            //                 child: Text(
            //                   "Remove it",
            //                   style: TextStyle(
            //                     color: Theme.of(context).errorColor,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ));
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

  void _handlePlayCard(double cardId) async {
    print("played");
    // final playerData = Provider.of<User>(context, listen: false).playerData;
    // await API.setPlayerReady(lobbyId, playerData.id).then((success) {
    //   if (!success) return;
    //   setState(() {
    //     isReady = true;
    //   });
    // });
  }
}
