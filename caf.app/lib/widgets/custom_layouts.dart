import 'package:flutter/material.dart';

abstract class CustomLayouts {
  static Widget mainLayout(List<Widget> children, BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        foregroundColor: Theme.of(ctx).colorScheme.secondary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Theme.of(ctx).colorScheme.surface),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
