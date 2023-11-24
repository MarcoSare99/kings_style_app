import 'package:flutter/material.dart';
import 'package:kings_style_app/routes.dart';
import 'package:kings_style_app/screens/add_product_screen.dart';
import 'package:kings_style_app/screens/dash_board_screen.dart';
import 'package:kings_style_app/screens/details_product_screen.dart';
import 'package:kings_style_app/screens/login_screen.dart';
import 'package:kings_style_app/screens/on_boarding_screen.dart';
import 'package:kings_style_app/screens/register_screen.dart';
import 'package:kings_style_app/settings/style_setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: getAplicationRoutes(),
        title: 'Flutter Demo',
        theme: MyThemes.darkTheme,
        darkTheme: MyThemes.darkTheme,
        home: const AddProductScreen());
  }
}
