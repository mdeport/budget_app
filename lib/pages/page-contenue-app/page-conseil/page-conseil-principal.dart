import 'package:flutter/material.dart';

class Page_conseil_principal extends StatefulWidget {
  const Page_conseil_principal({super.key});

  @override
  State<Page_conseil_principal> createState() => _Page_conseil_principalState();
}

class _Page_conseil_principalState extends State<Page_conseil_principal> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Conseil'),
      ),
    );
  }
}
