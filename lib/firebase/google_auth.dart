import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuth {
  GoogleSignIn? _googleSignIn;
  bool? hasData;

  Future<void> signInWithGoogle() async {
    try {
      _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        UserModel? userFound = await findByEmail(googleUser.email);
        if (userFound == null) {
          //logea y crea
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          final user =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final docUser = FirebaseFirestore.instance
              .collection('users')
              .doc(user.user!.uid);
          final prefs = await SharedPreferences.getInstance();

          UserModel userModel = UserModel(
              firstName: user.user!.displayName,
              uid: user.user!.uid,
              email: user.user!.email,
              profilePicture: user.user!.photoURL,
              accessProvider: 'google',
              deviceToken: prefs.getString('device_token'));

          final userJson = userModel.toJson();
          await docUser.set(userJson);
          await userModel.saveToSharedPreferences(userModel);
        } else {
          if (userFound.accessProvider == 'google') {
            //logea
            final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;
            final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken);
            await FirebaseAuth.instance.signInWithCredential(credential);
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: googleUser.email)
                .get();
            Map<String, dynamic> userData =
                querySnapshot.docs.first.data() as Map<String, dynamic>;
            UserModel userModel = UserModel.fromMap(userData);
            final prefs = await SharedPreferences.getInstance();
            userModel.deviceToken = prefs.getString('device_token');
            await userModel.saveToSharedPreferences(userModel);
          } else {
            await _googleSignIn?.disconnect();
            await FirebaseAuth.instance.signOut();
            throw EmailAlreadyInUseException();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } on EmailAlreadyInUseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<String> signOutFromGoogle() async {
    _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn?.disconnect();
      await FirebaseAuth.instance.signOut();
      //Limpiar preferencias de usuario?
      return 'succesful-sign-out';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<bool> hasUserData(String id) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    final doc = await docUser.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel?> findByEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return UserModel.fromMap(querySnapshot.docs[0].data());
    } else {
      return null;
    }
  } //true: esta registrado
}

class EmailAlreadyInUseException implements Exception {
  final String message = 'Email already in use';
}
/* 
FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference documentReference =
          firestore.collection('users').doc(user.user!.uid);
      //await documentReference.update({'tokenDevice': tokenDevice});

*/
