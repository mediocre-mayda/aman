import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainCard extends StatelessWidget {
  @required
  final String title;
  @required
  final int icon;

  MainCard(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    var iosColor = CupertinoTheme.of(context).primaryColor;
    var androidColor = Theme.of(context).primaryColor;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Icon(
              FontAwesomeIcons.cashRegister,
              color: Platform.isAndroid ? androidColor : iosColor,
              size: 35,
            ),
            Expanded(
              child: Text(''),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
