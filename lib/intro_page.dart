import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'loginpage.dart';

class IntroPage extends StatelessWidget {
  static final route = 'intro_page_route';

  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _IntroPage();
  }
}

class _IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 1, 32, 1),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(130, 130, 130, 20),
            child: Image(
                color: Colors.white54,
                image: AssetImage('assets/icons/caduceus-symbol.png'),
                fit: BoxFit.contain),
          ),
          const Text(
            'Welcome',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.white54),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Divider(
              color: Colors.grey,
              indent: 50,
              endIndent: 50,
              thickness: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(Loginpage.route),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.white),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Divider(
              color: Colors.grey,
              indent: 50,
              endIndent: 50,
              thickness: 3,
            ),
          ),
        ],
      ),
    );
  }
}