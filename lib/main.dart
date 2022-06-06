import 'package:flutter/material.dart';
import 'package:message/view/login/loginview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message',
      theme: ThemeData(primaryColor: Colors.blue),
      home: LoginView(),
    );
  }
}
