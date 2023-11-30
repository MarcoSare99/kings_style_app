import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kings_style_app/firebase/authentication_firebase.dart';
import 'package:kings_style_app/responsive.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:kings_style_app/widgets/email_field_widget.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthenticationFireBase authenticationFireBase = AuthenticationFireBase();
  DialogWidget dialogWidget = DialogWidget();

  EmailFieldWidget email = EmailFieldWidget(
      label: 'Email',
      hint: 'Enter your email',
      msgError: 'This field is required');

  bool validateForm() {
    return (email.formkey.currentState!.validate());
  }

  @override
  Widget build(BuildContext context) {
    final btnOk = TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: const Text('Ok'));

    final btnSend = SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      onPressed: () async {
        dialogWidget.showProgress();
        if (email.formkey.currentState!.validate()) {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: email.controlador!);
          dialogWidget.closeProgress();
          dialogWidget.showMessageWithActions(
              title: "Succesful",
              message: "We've sent an email to reset your password",
              actions: [btnOk]);
        }
      },
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 35.0, // Ajusta según tus necesidades
              height: 35.0, // Ajusta según tus necesidades
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54, // Color de fondo del botón
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white, // Color del icono
                ),
              ),
            ),
          ),
        ),
      ),
      body: Responsive(
        mobile: MobileLoginScreen(
          dataLogin: dataLogin(context, btnSend, false),
        ),
        tablet: TabletLoginScreen(dataLogin: dataLogin(context, btnSend, true)),
        desktop: DesktopLoginScreen(
          dataLogin: dataLogin(context, btnSend, false),
        ),
      ),
    );
  }

  Widget dataLogin(
      BuildContext context, SocialLoginButton btnSend, bool isTablet) {
    // ignore: unused_local_variable
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    const Text(
                      "King's style",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Color del fondo
                      ),
                    ),
                    // Texto sin contorno (texto principal)
                    Text(
                      "King's style",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2.0
                          ..color = Colors.black, // Color del contorno
                      ),
                    ),
                  ],
                ),
                Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo_head.png"),
                          fit: BoxFit.fill),
                    ),
                    margin: const EdgeInsets.all(10)),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                margin: isTablet
                    ? EdgeInsets.only(
                        left: screenWidth * 0.15, right: screenWidth * 0.15)
                    : const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(children: [
                  const Text(
                    "You forgot your password?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "We'll help you",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  email,
                  btnSend,
                ]),
              ),
            ),
          ),
        ]);
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
    required this.dataLogin,
  }) : super(key: key);

  final Widget dataLogin;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/login_background.png"),
            fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(child: dataLogin),
    );
  }
}

class TabletLoginScreen extends StatelessWidget {
  const TabletLoginScreen({
    Key? key,
    required this.dataLogin,
  }) : super(key: key);

  final Widget dataLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/login_background.png"),
            fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(child: dataLogin),
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({
    Key? key,
    required this.dataLogin,
  }) : super(key: key);

  final Widget dataLogin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
                decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login_background.png"),
                  fit: BoxFit.cover),
            )),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(child: dataLogin),
          ),
        ],
      ),
    );
  }
}
