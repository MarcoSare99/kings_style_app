import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GithubAuth {
  bool? hasData;

  Future<String> signInWithGitHub(BuildContext context) async {
    //String tokenDevice = AppPreferences.token;
    final GitHubSignIn gitSignIn = GitHubSignIn(
        clientId: "fa04bfe27969b853c4ab",
        clientSecret: "71f5cf5c6b849bb150bd67bcaf42b3d68f19c592",
        redirectUrl: 'https://kingstyle-164e8.firebaseapp.com/__/auth/handler');
    final result = await gitSignIn.signIn(context);

    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        {
          try {
            final gitAuthCredential =
                GithubAuthProvider.credential(result.token!);
            final user = await FirebaseAuth.instance
                .signInWithCredential(gitAuthCredential);
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            DocumentReference documentReference =
                firestore.collection('users').doc(user.user!.uid);
            //await documentReference.update({'tokenDevice': tokenDevice});
            if (await hasUserData(user.user!.uid)) {
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: user.user!.email)
                  .get();
              Map<String, dynamic> userData =
                  querySnapshot.docs.first.data() as Map<String, dynamic>;
              UserModel userModel = UserModel.fromMap(userData);
              final prefs = await SharedPreferences.getInstance();
              userModel.deviceToken = prefs.getString('device_token');
              await userModel.saveToSharedPreferences(userModel);

              print('logged-succesful');
              return 'logged-succesful';
            } else {
              final prefs = await SharedPreferences.getInstance();

              UserModel userModel = UserModel(
                  firstName: user.user!.displayName,
                  uid: user.user!.uid,
                  email: user.user!.email,
                  profilePicture: user.user!.photoURL,
                  accessProvider: 'github',
                  deviceToken: prefs.getString('device_token'));
              final userJson = userModel.toJson();
              await documentReference.set(userJson);
              await userModel.saveToSharedPreferences(userModel);
              print('logged-without-info');
              return 'logged-without-info';
            }
          } on FirebaseAuthException catch (e) {
            return e.code;
          }
        }

      case GitHubSignInResultStatus.cancelled:
        {
          print('canceled');
          return 'sign-in-cancelled';
        }

      case GitHubSignInResultStatus.failed:
        {
          print('failed');
          return 'sign-in-failed';
        }
    }
  }

  Future<String> signOutFromGitHub() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'successful-sign-out';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<bool> hasUserData(String idUser) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(idUser);
    final snapshot = await userDoc.get();
    if (snapshot.exists) {
      return true;
    }
    return false;
  }
}
