import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-accueil/page-accueil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-budget-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-conseil/page-conseil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-parametre-principal.dart';

class pageGeneral extends StatefulWidget {
  const pageGeneral({super.key});

  @override
  State<pageGeneral> createState() => _pageGeneralState();
}

class _pageGeneralState extends State<pageGeneral> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Page_accueil_principal(),
    const Page_budget_principal(),
    const Page_conseil_principal(),
    const Page_parametre_principal(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
            backgroundColor: Color.fromARGB(255, 33, 148, 241),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Budget',
            backgroundColor: Color.fromARGB(255, 33, 140, 241),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Conseils',
            backgroundColor: Color.fromARGB(255, 33, 130, 241),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
            backgroundColor: Color.fromARGB(255, 33, 120, 241),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
