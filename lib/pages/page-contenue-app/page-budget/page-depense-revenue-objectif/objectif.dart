import 'package:flutter/material.dart';

class page_objectif extends StatefulWidget {
  const page_objectif({super.key});

  @override
  State<page_objectif> createState() => _page_objectifState();
}

class _page_objectifState extends State<page_objectif> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Objectif'),
      ),
    );
  }
}
