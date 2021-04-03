import 'package:aman/widgets/cutsom_animated_splash.dart';
import 'package:aman/widgets/splash_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class LoadingScreen extends StatelessWidget {
//  static bool isLoggedIn = false;
  static int customerId;
  static String password;
  LoadingScreen() {
    _userData();
  }
  static _userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    isLoggedIn = prefs.getBool('is_logged_in');
    customerId = prefs.getInt('customer_id');
    password = prefs.getString('token');
    print("LoadingScreen: _userData(): customer_id = $customerId");
    print("LoadingScreen: _userData(): password = $password");
  }

  Function loadingSplash = () {
    print('Loading background process...');
//    _userData().then((cusId) {
//      print("loadingSplash: cusId = $cusId");
//    });
    print("LoadingScreen: loadingSplash(): customer_id = $customerId");
    print("LoadingScreen: loadingSplash(): password = $password");
    if ((password == "" || password == null)) {
      return 2;
    }
    return 1;

    // Test to return home widget
  };

  //setup the return value correctly for proper navigation
  Map<int, Widget> op = {1: HomeScreen(), 2: LoginScreen()};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomAnimatedSplash(
          customWidget: SplashLogo(),
          home: MainScreen(), //TODO replace with Login screen
          duration: 2500,
          customFunction: loadingSplash,
          type: AnimatedSplashType.BackgroundProcess,
          outputAndHome: op,
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
