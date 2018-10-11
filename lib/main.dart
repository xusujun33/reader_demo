import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';


void main() => runApp(new Myapp());

class Myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reader Demo',
      home: new HomeReader(),
    );
  }
}
