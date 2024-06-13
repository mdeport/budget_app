import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-revenu/page-revenu.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-depense/page-depense.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-objectif/page-objectif.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Page_budget_principal extends StatefulWidget {
  const Page_budget_principal({super.key});

  @override
  State<Page_budget_principal> createState() => _Page_budget_principalState();
}

// ignore: camel_case_types
class _Page_budget_principalState extends State<Page_budget_principal> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DepensePage(),
    const RevenuePage(),
    const ObjectifPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Text(
                        'Dépenses',
                        style: TextStyle(
                          color:
                              _selectedIndex == 0 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Text(
                        'Revenus',
                        style: TextStyle(
                          color:
                              _selectedIndex == 1 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: Text(
                        'Objectifs',
                        style: TextStyle(
                          color:
                              _selectedIndex == 2 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
