import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData LightTheme(BuildContext context) => ThemeData(
      hintColor: Color.fromARGB(255, 184, 10, 10),
      focusColor: Colors.black,
      highlightColor: Colors.black,
      primaryColor: ThemeColor,
      cardColor: Colors.white,
      canvasColor: creamcolor,
      fontFamily: GoogleFonts.poppins().fontFamily,
      shadowColor: bluishcolor,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ));
  static ThemeData DarkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.black,
      canvasColor: DarkColor,
      hintColor: Colors.yellow,
      primaryColor: Colors.white,
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(
      //     backgroundColor: WidgetStatePropertyAll(DarkColor),
      //   ),
      // ),
      highlightColor: Colors.white,
      focusColor: Colors.yellow,
      shadowColor: ThemeColor,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ));
  static Color creamcolor = Color(0xfff5f5f5);
  static Color bluishcolor = Color(0xff403b58);
  static Color DarkColor = Vx.gray900;
  static Color ThemeColor = Color.fromARGB(255, 2, 99, 144);
}
