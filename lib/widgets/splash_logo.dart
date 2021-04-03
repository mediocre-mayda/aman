import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            //   child: Center(), //TODO LOGO
            // ),

            Center(child: Text(
              "أمان",
              style: Theme.of(context).textTheme.headline1,
            ),)
          ]),
          color: Theme.of(context).primaryColor,
    );
  }
}
