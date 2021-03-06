import 'dart:convert';
import 'dart:io';

import 'package:aman/data/network/services/auth_service.dart';
import 'package:aman/screens/main_screen.dart';
import 'package:aman/utils/helpers.dart';
import 'package:easy_text_input/easy_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final AuthService auth = AuthService();
  SharedPreferences prefs;

  RoundedLoadingButtonController _roundedButtonController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();

    //getDeviceId();
  }

  // login route
  Future _postLogin(String email, String password) async {
    print("_postLogin started:");
    prefs = await SharedPreferences.getInstance();

    await auth.login(email, password).then((response) async {
      print("response: ${response.body}");
      //return;
      var jsonData = json.decode(response.body);
      print("jsonData: $jsonData");
      if (response.statusCode == 200) {
        _roundedButtonController.success();
        prefs.setString("token", jsonData["token"]);
        prefs.setString("userId", jsonData["user"]["_id"]);
        //print("jsonData[0]['ID'] = ${jsonData[0]['ID']}");
        _goToMainScreen(context);
      } else if (response.statusCode == 400) {
        print("400: jsonData == $jsonData");
        _roundedButtonController.error();
        Toast.show("?????? ???? ?????????? ????????????", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        _roundedButtonController.reset();
      } else {
        _roundedButtonController.error();
        Toast.show("?????? ???? ?????????? ????????????", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        _roundedButtonController.reset();
      }
    }).timeout(Duration(seconds: 10), onTimeout: () {
      print('Timeout');
      Toast.show('???????????? ??????????!', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      _roundedButtonController.reset();
    });
    _roundedButtonController.reset();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      body: ColorFiltered(
        colorFilter: ColorFilter.mode(
            Theme.of(context).primaryColor.withOpacity(0.4), BlendMode.srcOver),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Theme.of(context).primaryColor,
                ],
                stops: [
                  0.0,
                  1.0
                ]),
            image: DecorationImage(
              image: AssetImage("assets/images/login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              // Container(
              //   height: 150,
              //   width: 150,
              //   decoration: BoxDecoration(boxShadow: [
              //     BoxShadow(
              //       color: Colors.black38,
              //       offset: Offset(-2, -7),
              //       blurRadius: 10.0,
              //     )
              //   ], color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              //   child:
              Center(
                child: Image(
                  width: 200,
                  height: 200,
                  image: AssetImage("assets/images/splash.png"),
                ),
              ),

              // SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "????????",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 70.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              //),
              SizedBox(height: 40),
              InputField(
                stream: null,
                labelText: '????????????',
                keyboardType: TextInputType.phone,
                borderRadius: 20.0,
                controller: _emailController,
                onChanged: (val) {
                  print('email: ' + val);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              InputField(
                stream: null,
                labelText: '???????? ????????',
                obscureText: true,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                borderRadius: 20.0,
                controller: _passwordController,
                onChanged: (val) {
                  print('password: ' + val);
                },
              ),
              // TextField(
              //   enabled: true,
              //   maxLines: 1,
              //   textDirection: TextDirection.rtl,
              //   keyboardType: TextInputType.numberWithOptions(
              //       signed: false, decimal: false),
              //   textInputAction: TextInputAction.done,
              //   style: TextStyle(color: Colors.black87, fontFamily: 'Hacen'),
              //   //              obscureText: true,
              //   decoration: InputDecoration(
              //     prefixIcon: Icon(
              //       FontAwesomeIcons.key,
              //       color: Theme.of(context).accentColor,
              //     ),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: Platform.isAndroid
              //           ? BorderSide(color: Theme.of(context).accentColor)
              //           : BorderSide(
              //               color: CupertinoTheme.of(context).primaryColor),
              //     ),
              //     hintText: '???????? ????????',
              //     alignLabelWithHint: true,
              //     hintStyle: TextStyle(color: Colors.black54),
              //   ),
              //   controller: _passwordController,
              //   onChanged: (val) {
              //     print('password: ' + val);
              //   },
              //   onSubmitted: _passwordSubmission,
              // ),
              SizedBox(
                height: 20,
              ),
              RoundedLoadingButton(
                color: Theme.of(context).primaryColor,
                controller: _roundedButtonController,
                onPressed: () {
                  if (_passwordController.text.isEmpty ||
                      _emailController.text.isEmpty) {
                    Toast.show("???????? ???????????? ??????????", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                    _roundedButtonController.error();
                    _roundedButtonController.reset();
                    return;
                  }

                  // if (!isNumeric(_passwordController.text)) {
                  //   Toast.show("?????? ???? ??????????????!", context,
                  //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                  //   _roundedButtonController.error();

                  //   return;
                  // }
                  _postLogin(_emailController.text.trim(),
                      _passwordController.text.trim());
                },
                child: Container(
                  width: 120.0,
                  child: Center(
                    child: PlatformText(
                      '?????????? ????????????',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Hacen',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(child: Text('')),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  InkWell(
                    child: Text(
                      "???? ???? ???????????? ????????",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),

                  // Text(
                  //   "Powered By Tatweer Research",
                  //   style: TextStyle(
                  //       fontSize: 11,
                  //       color: Colors.black54,
                  //       fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _passwordSubmission(String password) {
    print(_passwordController.text);
    // Check if test is digits  only.
  }

  _goToMainScreen(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            //settings: RouteSettings(name: RoutesSettings.MAIN_ROUTE),
            fullscreenDialog: true,
            builder: (BuildContext context) => MainScreen()),
        (Route<dynamic> route) => false);
  }

  // _goToChooseDatabaseScreen(BuildContext context, List<Database> databases) {
  //   Navigator.of(context).pop();
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //           settings: RouteSettings(name: RoutesSettings.DATABASES_ROUTE),
  //           fullscreenDialog: true,
  //           builder: (BuildContext context) =>
  //               DatabasesScreen(databases: databases)),
  //       (Route<dynamic> route) => false);
  // }
}
