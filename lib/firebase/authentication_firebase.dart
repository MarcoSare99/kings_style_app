import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationFireBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createUserWithEmailAndPass(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      userCredential.user!.sendEmailVerification();
      return 'user-registered';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signInWithEmailAndPass(
      {required email, required password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.emailVerified) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromMap(userData);
        final prefs = await SharedPreferences.getInstance();
        userModel.deviceToken = prefs.getString('device_token');
        await userModel.saveToSharedPreferences(userModel);
        /* userCredential.user!.sendEmailVerification(); */
        //agregar información del usuario al provider o preferencias de usuario (SharedPreferences)
        //await Database.saveUserPrefs(userCredential);
        return 'logged-in-successfully';
      }
      return 'email-not-verified';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> resendVerification({required email, required password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user!.emailVerified == false) {
        userCredential.user!.sendEmailVerification();
        return 'email-resent';
      }
      return 'email-already-verified';
    } catch (e) {
      return 'error';
    }
  }

  Future<String> signOutFromEmail() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'successful-sign-out';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> createUser({required UserModel userModel}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.pass!,
      );

      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);
      final prefs = await SharedPreferences.getInstance();
      userModel.uid = userCredential.user!.uid;
      userModel.pass = null;
      userModel.accessProvider = "email";
      userModel.deviceToken = prefs.getString('device_token');
      final userJson = userModel.toJson();
      await docUser.set(userJson).then((value) async {
        userCredential.user!.sendEmailVerification();
      });
      //print('Usuario registrado con éxito: ${userCredential.user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Weak password');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Email already in use');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUser({required UserModel userModel}) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(userModel.uid);
      final userJson = userModel.toJson();
      await docUser.set(userJson);
      userModel.saveToSharedPreferences(userModel);
    } catch (e) {
      throw Exception(e);
    }
  }
}
