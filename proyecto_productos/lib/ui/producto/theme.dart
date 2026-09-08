import 'package:flutter/material.dart';

const _semilla = Color.fromARGB(255, 221, 103, 103);

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _semilla),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  ),
  chipTheme: const ChipThemeData(showCheckmark: false, side: BorderSide.none),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 12),
  ),
);
