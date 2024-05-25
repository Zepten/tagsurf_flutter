import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'JetBrains Mono NL',
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.blue,
    elevation: 0,
    centerTitle: true,
  );
}
