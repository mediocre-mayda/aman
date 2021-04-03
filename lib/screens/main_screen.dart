import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Henlo"),),
      body: Container(
        color: Colors.white,
        child: Text(
          "Hello Main",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
