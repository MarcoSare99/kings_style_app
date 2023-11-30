import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? id;
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? pass;
  String? accessProvider;
  String? profilePicture;
  String? deviceToken;

  UserModel(
      {this.id,
      this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.pass,
      this.profilePicture,
      this.accessProvider,
      this.deviceToken});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      uid: map['uid'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      profilePicture: map['profile_picture'],
      accessProvider: map['access_provider'],
      deviceToken: map['device_token'],
    );
  }
  static Future<UserModel?> fromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');

    if (jsonString != null) {
      final Map<String, dynamic> map = json.decode(jsonString);
      return UserModel.fromMap(map);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'pass': pass,
        'profile_picture': profilePicture,
        'access_provider': accessProvider,
        'device_token': deviceToken
      };

  Future<void> saveToSharedPreferences(UserModel userModel) async {
    String user = json.encode(userModel);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
  }
}
