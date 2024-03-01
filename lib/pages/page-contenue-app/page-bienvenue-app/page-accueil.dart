import 'package:application_budget_app/pages/page-authentification/page-bienvenue.dart';
import 'package:application_budget_app/pages/page-authentification/page-social.dart';
import 'package:application_budget_app/pages/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Page_accueil extends StatefulWidget {
  const Page_accueil({super.key});

  @override
  State<Page_accueil> createState() => _Page_accueilState();
}

class _Page_accueilState extends State<Page_accueil> {
  UserService _userService = UserService();

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
    );
  }
}
