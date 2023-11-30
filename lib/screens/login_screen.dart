import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kings_style_app/firebase/authentication_firebase.dart';
import 'package:kings_style_app/firebase/git_hub_auth.dart';
import 'package:kings_style_app/firebase/google_auth.dart';
import 'package:kings_style_app/responsive.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:kings_style_app/widgets/email_field_widget.dart';
import 'package:kings_style_app/widgets/pass_field_widget.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //UserPreferences userPreferences = UserPreferences();
  //final GoogleSignIn googleSignIn = GoogleSignIn();
  //emailFormField email =
  //emailFormField("Email", "Ingresa tu email", "Llene este campo");
  //textFieldPass pass = textFieldPass();
  GoogleAuth googleAuth = GoogleAuth();
  final GithubAuth _githubAuth = GithubAuth();
  AuthenticationFireBase authenticationFireBase = AuthenticationFireBase();
  DialogWidget dialogWidget = DialogWidget();
  bool loginFailed = false;

  PassFieldWidget pass = PassFieldWidget(
      label: 'Password',
      hint: 'Enter your password',
      msgError: 'Email or password wrong');
  EmailFieldWidget email = EmailFieldWidget(
      label: 'Email',
      hint: 'Enter your email',
      msgError: 'Email or password wrong');

  Future<void> signInWithGoogle() async {
    try {
      await googleAuth.signInWithGoogle();
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/dash_board');
    } catch (e) {
      dialogWidget.showMessage(message: e.toString(), title: "Error");
    }
  }

  bool validateForm() {
    if (loginFailed) {
      if (email.msgError == "Email or password wrong" &&
          !email.formkey.currentState!.validate()) {
        return true;
      } else if (pass.msgError == "Email or password wrong" &&
          !pass.formkey.currentState!.validate()) {
        return true;
      }
    }
    if (email.formkey.currentState!.validate()) {
      if (pass.formkey.currentState!.validate()) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final btnGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      onPressed: signInWithGoogle,
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      text: "",
    );

    final btnGitHub = SocialLoginButton(
      buttonType: SocialLoginButtonType.github,
      onPressed: () {
        _githubAuth.signInWithGitHub(context).then((value) {
          dialogWidget.showProgress();
          if (value == 'logged-succesful' || value == 'logged-without-info') {
            dialogWidget.closeProgress();
            Navigator.pushNamed(context, '/dash_board');
          } else if (value == 'account-exists-with-different-credential') {
            dialogWidget.closeProgress();
            dialogWidget.showMessage(
                message: 'Account exists with different credential',
                title: "Error");
          } else {
            dialogWidget.closeProgress();
            dialogWidget.showMessage(message: 'Error', title: "Error");
          }
        });
      },
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      text: "",
    );

    final btnResend = TextButton(
        onPressed: () {
          authenticationFireBase
              .resendVerification(
                  email: email.controlador, password: pass.controlador)
              .then((value) {
            if (value == 'email-resent') {
              Navigator.pop(context);
              dialogWidget.showMessage(
                  message: 'Email verefication resend', title: "Info");
            } else {
              dialogWidget.showMessage(message: 'Error', title: "Error");
            }
          });
        },
        child: const Text('Reenviar verificación'));

    final btnOk = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Ok'));

    List<Widget> optionsResend = [btnResend, btnOk];

    final rowBtnSocial = SizedBox(
      width: 250,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [btnGoogle, btnGitHub]),
    );

    Future<void> signIn() async {
      if (validateForm()) {
        dialogWidget.showProgress();
        String result = await authenticationFireBase.signInWithEmailAndPass(
            email: email.controlador, password: pass.controlador);
        if (result == 'logged-in-successfully') {
          // ignore: use_build_context_synchronously
          dialogWidget.closeProgress();
          Navigator.pushNamed(context, '/dash_board');
        } else {
          if (result == 'email-not-verified') {
            dialogWidget.closeProgress();
            dialogWidget.showMessageWithActions(
                title: "Error",
                message: "Email not verified",
                actions: optionsResend);
          } else {
            dialogWidget.closeProgress();
            if (result == 'invalid-credential') {
              loginFailed = true;
              email.error = true;
              email.formkey.currentState!.validate();
              pass.error = true;
              pass.formkey.currentState!.validate();
            }
            //credenciales incorrectas
          }
        }

        print("result: $result");
      }
    }

    final btnSend = SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      onPressed: signIn,
      mode: SocialLoginButtonMode.single,
      borderRadius: 15,
      backgroundColor: Theme.of(context).primaryColor,
    );

    final btnForgotPass = TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/forgot_password');
        },
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.zero,
            child: const Text(
              "Forgot your password?",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            )));

    final rowRegister = Row(children: [
      const Text("Do you have an acount?"),
      Expanded(
          child: TextButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                "Create your acount",
                style: TextStyle(fontWeight: FontWeight.bold),
              )))
    ]);

    return Scaffold(
      //appBar: AppBar(title: Text("Login")),
      body: Responsive(
        mobile: MobileLoginScreen(
          dataLogin: dataLogin(context, btnSend, rowBtnSocial, rowRegister,
              btnForgotPass, false),
        ),
        tablet: TabletLoginScreen(
            dataLogin: dataLogin(context, btnSend, rowBtnSocial, rowRegister,
                btnForgotPass, true)),
        desktop: DesktopLoginScreen(
          dataLogin: dataLogin(context, btnSend, rowBtnSocial, rowRegister,
              btnForgotPass, false),
        ),
      ),
    );
  }

  Widget dataLogin(
      BuildContext context,
      SocialLoginButton btnSend,
      SizedBox rowBtnSocial,
      Row rowRegister,
      Widget btnForgotPass,
      bool isTablet) {
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
                    "Hello again!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Your Destination for Men's Fashion",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  email,
                  pass,
                  btnForgotPass,
                  btnSend,
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Or continue with",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  rowBtnSocial,
                  rowRegister
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
