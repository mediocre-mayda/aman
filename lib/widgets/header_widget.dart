import 'dart:math';

import 'package:aman/utils/colors.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  String name;
  String description;
  IconData icon;
  HeaderWidget({this.name, this.description, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: Stack(
            children: [
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.only(top: 25, left: 5, right: 5, bottom: 25),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    //padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                            height: 172,
                            image: new AssetImage('assets/images/map.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(-2, -7),
                        blurRadius: 10.0,
                      )
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
