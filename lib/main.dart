import 'package:flutter/material.dart';
import 'login_register.dart';
import 'favorites.dart';
import 'intro_page.dart';
import 'store.dart';
import 'search.dart';
import 'home.dart';

void main() {
  runApp(PharmacistApp());
}

class PharmacistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Our Medicine Whorehouse',
      initialRoute: IntroPage.route,
      routes: {
        LoginRegister.route: (context) => LoginRegister(),
        HomePage.route: (context) => HomePage(),
        Search.route: (context) => Search(),
        Store.route: (context) => Store(),
        Favorites.route: (context) => Favorites(),
        IntroPage.route: (context) => IntroPage(),
      },
    );
  }
}
