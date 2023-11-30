import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:kings_style_app/firebase/authentication_firebase.dart';
import 'package:kings_style_app/firebase/git_hub_auth.dart';
import 'package:kings_style_app/firebase/google_auth.dart';
import 'package:kings_style_app/models/product_model.dart';
import 'package:kings_style_app/models/user_model.dart';
import 'package:kings_style_app/provider/theme_provider.dart';
import 'package:kings_style_app/screens/details_product_screen.dart';
import 'package:kings_style_app/screens/login_screen.dart';
import 'package:kings_style_app/widgets/dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindProduct extends StatefulWidget {
  String category;
  FindProduct({super.key, required this.category});

  @override
  State<FindProduct> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<FindProduct> {
  late String category;
  AuthenticationFireBase authenticationFireBase = AuthenticationFireBase();
  GoogleAuth googleAuth = GoogleAuth();
  GithubAuth githubAuth = GithubAuth();
  DialogWidget dialogWidget = DialogWidget();
  late UserModel _user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      category = widget.category;
      UserModel? user = await UserModel.fromSharedPreferences();
      setState(() {
        _user = user!;
        isLoading = false;
      });
    } catch (e) {
      isLoading = true;
    }
  }

  Future<void> logOut() async {
    bool result = await dialogWidget.showMessageConfirm(
        title: "Are you sure?", message: "You'll log out from your account");
    if (result) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_user.accessProvider == 'email') {
        await authenticationFireBase.signOutFromEmail();
      } else {
        if (_user.accessProvider == 'github') {
          await githubAuth.signOutFromGitHub();
        } else {
          if (_user.accessProvider == 'google') {
            await googleAuth.signOutFromGoogle();
          }
        }
      }
      await prefs.remove('user');
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Elimina todas las pantallas en la pila
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(170),
              child: Builder(
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 30,
                                color: Colors.white,
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                              IconButton(
                                iconSize: 30,
                                color: Colors.white,
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/add_product');
                                },
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "Find your favorite items",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: const TextField(
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('name', isEqualTo: '%$category%')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var documentos = snapshot.data?.docs;
                  List<ProductModel> products = documentos?.map((doc) {
                        return ProductModel.fromMap(doc.data());
                      }).toList() ??
                      [];
                  return ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          crossAxisCount:
                              (MediaQuery.of(context).size.width ~/ 170)
                                  .toInt(),
                          childAspectRatio: (110 / 200),
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            //color: Colors.green,
                            padding: const EdgeInsets.all(5),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                    () => DetailsProductoScreen(
                                        productModel: products[index]),
                                    transition: Transition.downToUp,
                                    duration:
                                        const Duration(milliseconds: 500));
                              },
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 200,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                products[index].images![0]),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Text(
                                      products[index].name!,
                                      style: const TextStyle(fontSize: 12),
                                      softWrap: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "\$ ${products[index].price!}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ),
                          );
                        },
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  );
                }
              },
            ),
            drawer: Drawer(
                child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName:
                      Text('${_user.firstName} ${_user.lastName ?? ''}'),
                  accountEmail: Text(_user.email ?? ''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(_user.profilePicture ??
                        'https://www.shareicon.net/data/512x512/2016/05/24/770117_people_512x512.png'),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                ListTile(
                  title: const Text('Update your profile'),
                  onTap: () {
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                  leading: const Icon(Icons.account_circle),
                ),
                ListTile(
                  title: const Text('Add product'),
                  onTap: () {
                    Navigator.pushNamed(context, '/add_product');
                  },
                  leading: const Icon(Icons.account_circle),
                ),
                ListTile(
                  title: const Text('Log out'),
                  leading: Switch.adaptive(
                      value: themeProvider.isDarkMode,
                      onChanged: (bool value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('theme', value);
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.toggleTheme(value);
                      }),
                ),
                ListTile(
                  title: const Text('Log out'),
                  onTap: () async {
                    await logOut();
                  },
                  leading: const Icon(Icons.logout),
                ),
              ],
            )),
          );
  }

  Widget cardCategory({String? title, String? img}) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 120,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onErrorContainer,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(img!), fit: BoxFit.fill),
                ),
                margin: const EdgeInsets.all(10)),
            Text(
              title!,
              style: const TextStyle(color: Colors.black),
            )
          ]),
    );
  }
}
