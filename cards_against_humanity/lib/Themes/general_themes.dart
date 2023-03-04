import 'package:flutter/material.dart';

abstract class AppThemes {
  static ThemeData themeData(context) {
    final ThemeData theme = Theme.of(context);
    return ThemeData(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.green,
            secondary: Colors.brown,
            background: Colors.orange[50],
          ),
      textTheme: Theme.of(context).textTheme.copyWith(
            headline1: theme.textTheme.headline1?.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
            headline3: theme.textTheme.headline3?.copyWith(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        fillColor: Colors.grey.shade50,
        filled: true,
      ),
    );
  }
}
