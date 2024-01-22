import 'package:application_budget_app/animation/temps-affichage-animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class bienvenuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 60,
          horizontal: 30,
        ),
        child: Column(children: [
          TempsAnimation(
              delai: 1500,
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "Budget App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                      color: Colors.blue[900],
                      fontSize: 60,
                      fontWeight: FontWeight.bold),
                ),
              )),
          TempsAnimation(
              delai: 2500,
              child: Container(
                margin: const EdgeInsets.only(
                  right: 40,
                ),
                height: 400,
                child: Image.asset('assets/images/logo-budget.png'),
              )),
          TempsAnimation(
              delai: 3500,
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Bienvenue sur une appli de gestion de budget",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )),
          TempsAnimation(
              delai: 4500,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Continuer"),
                  onPressed: () {},
                ),
              )),
        ]),
      ),
    ));
  }
}
