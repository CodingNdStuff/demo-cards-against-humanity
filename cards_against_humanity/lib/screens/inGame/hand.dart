import 'package:cards_against_humanity/models/white_card.dart';
import 'package:flutter/material.dart';

class Hand extends StatelessWidget {
  const Hand({super.key});
  static List<WhiteCard> cards = [
    WhiteCard(0, "TEst"),
    WhiteCard(1, "Adolf"),
    WhiteCard(2, "La meloni"),
    WhiteCard(3, "Attacco terroristico"),
    WhiteCard(4, "Anal shipment"),
    WhiteCard(5, "Donga"),
    WhiteCard(6, "Mea CUM laida"),
  ];
  @override
  Widget build(BuildContext context) {
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
              ...cards
                  .map(
                    (e) => CardItem(
                        key: ValueKey(e.id),
                        text: e.text,
                        index: e.id.toDouble()),
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
  const CardItem({super.key, required this.text, required this.index});
  final String text;
  final double index;
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
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
