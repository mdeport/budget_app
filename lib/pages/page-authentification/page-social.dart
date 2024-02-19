import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_budget_app/animation/temps-affichage-animation.dart';
import 'package:application_budget_app/pages/page-authentification/page-creer-compte.dart';
import 'package:application_budget_app/pages/page-authentification/page-connexion.dart';

class PageSocial extends StatelessWidget {
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TempsAnimation(
                  delai: 250,
                  child: Container(
                    height: 290,
                    child: Image.asset('assets/images/image-gestion.png'),
                  )),
              TempsAnimation(
                  delai: 750,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 135, horizontal: 40),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => page_connexion_compte(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[900],
                                shape: StadiumBorder(),
                                padding: EdgeInsets.all(13)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.contact_mail),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Se Connecter",
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => page_creation_compte(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[900],
                                shape: StadiumBorder(),
                                padding: EdgeInsets.all(13)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.mail_outline_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Créer un Compte",
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
