import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-budget-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-conseil/page-conseil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-parametre-principal.dart';
import 'package:application_budget_app/pages/navbottombar/navbottombar.dart';

class Page_accueil_principal extends StatefulWidget {
  const Page_accueil_principal({super.key});

  @override
  State<Page_accueil_principal> createState() => _Page_accueil_principalState();
}

class _Page_accueil_principalState extends State<Page_accueil_principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Accueil'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_accueil_principal(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_budget_principal(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_conseil_principal(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
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
