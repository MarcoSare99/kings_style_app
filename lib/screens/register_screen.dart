import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kings_style_app/firebase/authentication_firebase.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:kings_style_app/responsive.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:kings_style_app/widgets/email_field_widget.dart';
import 'package:kings_style_app/widgets/pass_field_widget.dart';
import 'package:kings_style_app/widgets/text_field_widget.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  AuthenticationFireBase authenticationFireBase = AuthenticationFireBase();
  DialogWidget dialogWidget = DialogWidget();

  TextFieldWidget firstName = TextFieldWidget(
    label: 'First name',
    hint: "Enter your first name",
    msgError: 'This field is required',
    icono: Icons.verified_user,
    inputType: 1,
  );
  TextFieldWidget lastName = TextFieldWidget(
    label: 'Last name',
    hint: "Enter your last name",
    msgError: 'This field is required',
    icono: Icons.verified_user,
    inputType: 1,
  );
  PassFieldWidget pass = PassFieldWidget(
      label: 'Password',
      hint: 'Enter your password',
      msgError: 'This field is required');
  EmailFieldWidget email = EmailFieldWidget(
      label: 'Email',
      hint: 'Enter your email',
      msgError: 'This field is required');

  final btnGitHub = SocialLoginButton(
    buttonType: SocialLoginButtonType.github,
    onPressed: () {},
    mode: SocialLoginButtonMode.single,
    borderRadius: 15,
    text: "",
  );

  final btnForgotPass = TextButton(
      onPressed: () {},
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: const Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          )));

  Future<void> _registerUser() async {
    if (validateForm()) {
      try {
        dialogWidget.showProgress();
        UserModel userModel = UserModel(
            firstName: firstName.controlador,
            lastName: lastName.controlador,
            email: email.controlador,
            pass: pass.controlador);
        await authenticationFireBase.createUser(userModel: userModel);
        dialogWidget.closeProgress();
        // ignore: use_build_context_synchronously
        await dialogWidget
            .showMessage(message: "User registered", title: "Succesful")
            .then((value) => {Navigator.pushNamed(context, '/login')});
      } catch (e) {
        dialogWidget.closeProgress();
        dialogWidget.showMessage(message: e.toString(), title: "Error");
      }
    }
  }

  bool validateForm() {
    return (firstName.formkey.currentState!.validate() &&
        lastName.formkey.currentState!.validate() &&
        email.formkey.currentState!.validate() &&
        pass.formkey.currentState!.validate());
  }

  @override
  Widget build(BuildContext context) {
    final btnGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      onPressed: () {},
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      text: "",
    );

    /* 
    final btnFacebook = SocialLoginButton(
      buttonType: SocialLoginButtonType.facebook,
      onPressed: () async {},
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      width: 77,
      text: "",
    );
    */

    final btnSend = SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      onPressed: _registerUser,
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      backgroundColor: Theme.of(context).primaryColor,
    );

    final rowBtnSocial = SizedBox(
      width: 250,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [btnGoogle, btnGitHub]),
    );

    final rowRegister = Row(children: [
      const Text("Do you have an acount?"),
      Expanded(
          child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                "Create your acount",
                style: TextStyle(fontWeight: FontWeight.bold),
              )))
    ]);

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
          dataLogin:
              dataLogin(context, btnSend, rowBtnSocial, rowRegister, false),
        ),
        tablet: TabletLoginScreen(
            dataLogin:
                dataLogin(context, btnSend, rowBtnSocial, rowRegister, true)),
        desktop: DesktopLoginScreen(
          dataLogin:
              dataLogin(context, btnSend, rowBtnSocial, rowRegister, false),
        ),
      ),
    );
  }

  Widget dataLogin(BuildContext context, SocialLoginButton btnSend,
      SizedBox rowBtnSocial, Row rowRegister, bool isTablet) {
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
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                margin: isTablet
                    ? EdgeInsets.only(
                        left: screenWidth * 0.15, right: screenWidth * 0.15)
                    : const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(children: [
                  const Text(
                    "Create Your Profile",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Make it personal! Create your profile to access exclusive features",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  firstName,
                  lastName,
                  email,
                  pass,
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
