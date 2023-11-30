import 'package:flutter/material.dart';
import 'package:kings_style_app/screens/add_product_screen.dart';
import 'package:kings_style_app/screens/dash_board_screen.dart';
import 'package:kings_style_app/screens/edit_profile_screen.dart';
import 'package:kings_style_app/screens/forgot_password_screen.dart';
import 'package:kings_style_app/screens/login_screen.dart';
import 'package:kings_style_app/screens/register_screen.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/forgot_password': (BuildContext context) => const ForgotPasswordScreen(),
    '/add_product': (BuildContext context) => const AddProductScreen(),
    '/dash_board': (BuildContext context) => const DashBoardScreen(),
    '/edit_profile': (BuildContext context) => const EditProfileScreen()
  };
}
