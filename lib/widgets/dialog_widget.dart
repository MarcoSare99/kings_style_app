import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DialogWidget {
  ProgressDialog? pd;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  DialogWidget() {
    pd = ProgressDialog(context: navigatorKey.currentState!.context);
  }

  Future<void> showMessage(
      {required String title, required String message}) async {
    await showDialog(
        context: navigatorKey.currentState!.context,
        builder: (context) => FadeInDown(
              delay: const Duration(microseconds: 700),
              child: AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.all(10)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok'))
                ],
              ),
            ));
  }

  Future<void> showMessageWithActions(
      {required String title,
      required String message,
      required List<Widget> actions}) async {
    showDialog(
        context: navigatorKey.currentState!.context,
        builder: (context) => FadeInDown(
              delay: const Duration(microseconds: 700),
              child: AlertDialog(
                  title: Text(title), content: Text(message), actions: actions),
            ));
  }

  Future<bool> showMessageConfirm(
      {required String title, required String message}) async {
    bool result = false;
    await showDialog(
        context: navigatorKey.currentState!.context,
        builder: (context) => FadeInDown(
              delay: const Duration(microseconds: 700),
              child: AlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: [
                    TextButton(
                        onPressed: () {
                          result = true;
                          Navigator.pop(context);
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'))
                  ]),
            ));

    return result;
  }

  void showProgress() {
    pd!.show(
        msg: "Wait Please",
        msgColor:
            Theme.of(navigatorKey.currentState!.context).colorScheme.scrim,
        backgroundColor: Theme.of(navigatorKey.currentState!.context)
            .scaffoldBackgroundColor,
        progressBgColor:
            Theme.of(navigatorKey.currentState!.context).primaryColor,
        progressValueColor: Theme.of(navigatorKey.currentState!.context)
            .colorScheme
            .onErrorContainer,
        barrierColor: Colors.white.withOpacity(0.2));
  }

  void closeProgress() {
    pd!.close();
  }
}
