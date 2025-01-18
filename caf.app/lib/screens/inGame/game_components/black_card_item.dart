import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BlackCardItem extends StatelessWidget {
  const BlackCardItem({super.key, required this.displayText, this.action});
  final String displayText;
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.65,
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
      padding: const EdgeInsets.all(15),
      color: Colors.black,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: AutoSizeText(
              maxLines: 5,
              wrapWords: false,
              displayText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (action != null)
            Container(
              alignment: Alignment.bottomRight,
              child: action!,
            ),
        ],
      ),
    );
  }
}
