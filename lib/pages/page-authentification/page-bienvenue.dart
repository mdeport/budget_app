import 'package:application_budget_app/animation/temps-affichage-animation.dart';
import 'package:application_budget_app/pages/page-authentification/page-social.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class bienvenuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 21, 41, 255),
            Color.fromARGB(234, 91, 230, 255),
            Color.fromARGB(197, 91, 230, 255),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 60,
              horizontal: 30,
            ),
            child: Column(children: [
              /*TempsAnimation(
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
              )),*/
              TempsAnimation(
                  delai: 2500,
                  child: Container(
                    height: 450,
                    child: Image.asset('assets/images/logo-budget.png'),
                  )),
              TempsAnimation(
                  delai: 3500,
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Text(
                      "Bienvenue sur une application dédiée à la gestion budgétaire",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              TempsAnimation(
                delai: 4500,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 0, 26, 255),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(13)),
                    child: const Text("CONTINUER"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageSocial(),
                          ));
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
