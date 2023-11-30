import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kings_style_app/firebase/authentication_firebase.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:kings_style_app/widgets/email_field_widget.dart';
import 'package:kings_style_app/widgets/pass_field_widget.dart';
import 'package:kings_style_app/widgets/text_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserModel _user;
  AuthenticationFireBase authenticationFireBase = AuthenticationFireBase();
  DialogWidget dialogWidget = DialogWidget();
  late File newImage;
  bool isLoading = true;
  bool selecImg = false;

  late TextFieldWidget firstName;
  late TextFieldWidget lastName;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      UserModel? user = await UserModel.fromSharedPreferences();
      setState(() {
        _user = user!;
        firstName = TextFieldWidget(
          label: 'First name',
          hint: "Enter your first name",
          msgError: 'This field is required',
          icono: Icons.verified_user,
          inputType: 1,
          controlador: user.firstName,
        );
        lastName = TextFieldWidget(
          label: 'Last name',
          hint: "Enter your last name",
          msgError: 'This field is required',
          icono: Icons.verified_user,
          inputType: 1,
          controlador: user.lastName,
        );
        isLoading = false;
      });
    } catch (e) {
      isLoading = true;
    }
  }

  Future<void> seleFromGalery() async {
    if (_user.accessProvider == 'email') {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          newImage = File(image.path);
          selecImg = true;
        });
      }
    } else {
      dialogWidget.showMessage(
          title: 'Error',
          message:
              "You can't change your profile picture because you did login with ${_user.accessProvider}");
    }
  }

  bool validateForm() {
    return (firstName.formkey.currentState!.validate() &&
        lastName.formkey.currentState!.validate());
  }

  Future<void> updateProfile() async {
    if (validateForm()) {
      try {
        dialogWidget.showProgress();
        String? profilePicture = _user.profilePicture;
        if (selecImg) {
          profilePicture = await uploadImage();
        }
        _user.profilePicture = profilePicture;
        _user.firstName = firstName.controlador;
        _user.lastName = lastName.controlador;
        await authenticationFireBase.updateUser(userModel: _user);
        dialogWidget.closeProgress();
        var snackBar = const SnackBar(content: Text("Profile updated"));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/dash_board');
      } catch (e) {
        var snackBar = const SnackBar(content: Text("Error"));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<String> uploadImage() async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();
      final imageRef =
          storageRef.child('images/${DateTime.now().toString()}.jpg');
      final uploadTask = imageRef.putFile(newImage);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(padding: const EdgeInsets.all(10), children: [
              SizedBox(
                height: 200,
                width: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    selecImg
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            height: 150,
                            width: 150,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: CircleAvatar(
                              backgroundImage: FileImage(newImage),
                            ))
                        : Container(
                            padding: const EdgeInsets.all(5),
                            height: 150,
                            width: 150,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(_user
                                      .profilePicture ??
                                  'https://www.shareicon.net/data/512x512/2016/05/24/770117_people_512x512.png'),
                            )),
                    Positioned(
                      bottom: 0,
                      right: 50,
                      left: 50,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () async {
                            seleFromGalery();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              firstName,
              lastName
            ]),
            floatingActionButton: FloatingActionButton.large(
              onPressed: updateProfile,
              child: const Icon(Icons.upgrade),
            ),
          );
  }
}
