import 'package:application_budget_app/pages/page-contenue-app/page-general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Page_accueil_principal extends StatefulWidget {
  const Page_accueil_principal({Key? key});

  @override
  State<Page_accueil_principal> createState() => _Page_accueil_principalState();
}

class _Page_accueil_principalState extends State<Page_accueil_principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accueil',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          buildShadowedBox(
            'Gérez facilement vos dépenses !',
            'BudgetApp est une solution pour que vous puissiez gérer et adopter des stratégies afin de vous aider à économiser de l’argent et en gagner. Il suffit d aller sur la page budget.',
            'budget', // mot cliquable
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const pageGeneral(
                    initialIndex: 1,
                  ),
                ),
              );
            },
          ),
          buildShadowedBox(
            'Gagnez du temps !',
            'BudgetApp vous propose de gagner du temps perdu à chercher des moyens d’économiser car nous vous mettons en place différentes dispositions pour des conseils personnalisés ! Il suffit d aller sur la page Conseil.',
            'Conseil', // mot cliquable
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const pageGeneral(
                    initialIndex: 2,
                  ),
                ),
              );
            },
          ),
          buildShadowedBox(
            'Maitrisez toutes vos dépenses !',
            'Avec BudgetApp vous aurez juste à mettre vos dépenses quotidiennes avec une personnalisation dans les ajouts de catégorie de dépense !',
            '', // pas de mot cliquable
            null, // pas de fonction associée
          ),
          buildShadowedBox(
            'Analyse et Compétence !',
            'BudgetApp vous propose un contenu clair et simple pour que chaque utilisateur puisse voir clairement ses dépenses via un graphique et un historique des dépenses faites.',
            '', // pas de mot cliquable
            null, // pas de fonction associée
          ),
          buildShadowedBox(
            'Personnalisation !',
            'BudgetApp vous propose une personnalisation de l’application à votre souhait de manière à améliorer l’expérience utilisateur. Il suffit d aller sur la page Paramètre.',
            'Paramètre', // mot cliquable
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const pageGeneral(
                    initialIndex: 3,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildShadowedBox(String title, String description,
      String clickableWord, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          title: Text(title),
          subtitle: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: description,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          if (clickableWord.isNotEmpty && onPressed != null)
                            TextSpan(
                              text: ' $clickableWord',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = onPressed,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
