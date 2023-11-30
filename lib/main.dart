import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:kings_style_app/notifications.dart';
import 'package:kings_style_app/provider/theme_provider.dart';
import 'package:kings_style_app/routes.dart';
import 'package:kings_style_app/screens/add_product_screen.dart';
import 'package:kings_style_app/screens/dash_board_screen.dart';
import 'package:kings_style_app/screens/details_product_screen.dart';
import 'package:kings_style_app/screens/edit_profile_screen.dart';
import 'package:kings_style_app/screens/login_screen.dart';
import 'package:kings_style_app/screens/on_boarding_screen.dart';
import 'package:kings_style_app/screens/register_screen.dart';
import 'package:kings_style_app/settings/style_setting.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  showNotificacion(message.notification!.title!, message.notification!.body!);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserModel? _user;
  bool? theme;
  bool isLoading = true;
  bool isOnBoarding = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showNotificacion(
            message.notification!.title!, message.notification!.body!);
        // Mostrar la notificación recibida
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('La notificación fue abierta desde una app en segundo plano');
        showNotificacion(
            message.notification!.title!, message.notification!.body!);
        // Realizar acciones necesarias al abrir la notificación en segundo plano
      });

      await getDeviceToken();
      UserModel? user = await UserModel.fromSharedPreferences();
      final prefs = await SharedPreferences.getInstance();

      theme = prefs.getBool('theme');
      isOnBoarding = prefs.getBool('is_onBoarding') ?? false;
      setState(() {
        _user = user;
        isLoading = false;
      });
    } catch (e) {
      isLoading = true;
    }
  }

  Future<void> getDeviceToken() async {
    FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await firebaseMessage.getToken();
    print("token device $deviceToken");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('device_token', deviceToken ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MaterialApp(
            home: Center(child: CircularProgressIndicator()),
          )
        : ChangeNotifierProvider(
            create: (context) => ThemeProvider()..init(theme),
            builder: (context, child) {
              final themeProvider = Provider.of<ThemeProvider>(context);
              return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  navigatorKey: DialogWidget.navigatorKey,
                  routes: getAplicationRoutes(),
                  title: 'Flutter Demo',
                  theme: MyThemes.lightTheme,
                  darkTheme: MyThemes.darkTheme,
                  themeMode: themeProvider.themeMode,
                  home: !isOnBoarding
                      ? const OnBoardingScreen()
                      : _user == null
                          ? const LoginScreen()
                          : const DashBoardScreen());
            });
  }
}
