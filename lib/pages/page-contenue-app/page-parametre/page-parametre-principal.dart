import 'package:application_budget_app/pages/page-contenue-app/page-accueil/page-accueil-principal.dart';
import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/navbottombar/navbottombar.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-budget-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-conseil/page-conseil-principal.dart';
import 'package:application_budget_app/pages/page-authentification/page-social.dart';
import 'package:application_budget_app/pages/services/UserService.dart';

class Page_parametre_principal extends StatefulWidget {
  const Page_parametre_principal({super.key});

  @override
  State<Page_parametre_principal> createState() =>
      _Page_parametre_principalState();
}

class _Page_parametre_principalState extends State<Page_parametre_principal> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _userService.signOut();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageSocial(),
                ),
                (route) => false);
          },
          child: const Text('Se déconnecter'),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
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
