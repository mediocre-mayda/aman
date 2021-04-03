import 'package:aman/screens/loading_screen.dart';
import 'package:aman/utils/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
//import 'package:flutter_stetho/flutter_stetho.dart';
import 'utils/colors.dart';

void main() {
  //Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // List all of the app's supported locales here
        supportedLocales: [
          Locale('ar', 'LY'),
          Locale('ar', 'EG'),
          Locale('ar', 'SA'),
          Locale('ar', 'AE'),
          Locale('ar', 'DZ'),
          Locale('ar', 'TN'),
//        Locale('en', 'US'),
//        Locale('en', 'UK'),
        ],
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            debugPrint("*language locale is null!!!");
            return supportedLocales.first;
          }
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define the default brightness and colors.
          backgroundColor: background,
          primaryColor: primary,
          accentColor: primary,

          // Define the default font family.
          fontFamily: 'Hacen',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            headline4: TextStyle(fontSize: 84.0, fontWeight: FontWeight.bold),
            headline1: TextStyle(fontSize: 84.0, fontWeight: FontWeight.bold, color: Colors.white),

            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hacen'),
          ),
        ),
        title: 'أمان',
        
      home: LoadingScreen(),
    );
  }
}
