import 'package:flutter/material.dart';
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
    );
  }
}
