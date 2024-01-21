import 'package:application_budget_app/pages/page-authentification/page-bienvenue.dart';
import 'package:flutter/material.dart';
import 'animation/temps-affichage-animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      debugShowCheckedModeBanner: false,
      home: bienvenuePage(),
    );
  }
}
