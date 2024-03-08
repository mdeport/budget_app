import 'package:application_budget_app/pages/navbottombar/navbottombar.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-accueil/page-accueil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-depense-revenue-objectif/depense.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-depense-revenue-objectif/objectif.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-depense-revenue-objectif/revenue.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-conseil/page-conseil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-parametre-principal.dart';
import 'package:flutter/material.dart';

class Page_budget_principal extends StatefulWidget {
  const Page_budget_principal({super.key});

  @override
  State<Page_budget_principal> createState() => _Page_budget_principalState();
}

class _Page_budget_principalState extends State<Page_budget_principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
      ),
      body: const Text('Budget'),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_accueil_principal(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_budget_principal(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_conseil_principal(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_parametre_principal(),
              ),
            );
          }
        },
      ),
    );
  }
}
