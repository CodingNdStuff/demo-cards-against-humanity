import 'package:flutter/material.dart';

class ViewControllerScope extends StatefulWidget {
  final Widget child;

  const ViewControllerScope({Key? key, required this.child}) : super(key: key);

  @override
  State<ViewControllerScope> createState() => _ViewControllerScopeState();
}

class _ViewControllerScopeState extends State<ViewControllerScope> {
  @override
  Widget build(BuildContext context) {
    //final vm = Provider.of<LobbyViewModel>(context);
    return Stack(
      children: [
        widget.child,
        if (false) //vm.isLoading)
          const Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ModalBarrier(
                  color: Colors.black,
                  dismissible: false,
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
      ],
    );
  }
}
