import 'package:flutter/material.dart';

class page_revenue extends StatefulWidget {
  const page_revenue({super.key});

  @override
  State<page_revenue> createState() => _page_revenueState();
}

class _page_revenueState extends State<page_revenue> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Revenu'),
      ),
    );
  }
}
