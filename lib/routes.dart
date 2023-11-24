import 'package:flutter/material.dart';
import 'package:kings_style_app/screens/login_screen.dart';
import 'package:kings_style_app/screens/register_screen.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
  };
}
