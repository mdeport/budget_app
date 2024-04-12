import 'package:flutter/material.dart';

class page_depense extends StatefulWidget {
  const page_depense({super.key});

  @override
  State<page_depense> createState() => _page_depenseState();
}

class _page_depenseState extends State<page_depense> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Dépense'),
      ),
    );
  }
}
