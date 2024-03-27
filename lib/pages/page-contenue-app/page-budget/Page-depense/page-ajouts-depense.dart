import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AjouterDepensePage extends StatefulWidget {
  @override
  _AjouterDepensePageState createState() => _AjouterDepensePageState();
}

class _AjouterDepensePageState extends State<AjouterDepensePage> {
  IconData selectedIcon = FontAwesomeIcons.shoppingBasket;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController prixControlleur = TextEditingController();
  TextEditingController nomDepenseControlleur = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une dépense'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Montant',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: TextField(
                controller: prixControlleur,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Entrez le montant',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Choisissez une icône',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.shoppingBasket),
                  onPressed: () {
                    setState(() {
                      selectedIcon = FontAwesomeIcons.shoppingBasket;
                    });
                  },
                  color: selectedIcon == FontAwesomeIcons.shoppingBasket
                      ? Colors.indigo
                      : Colors.grey,
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.car),
                  onPressed: () {
                    setState(() {
                      selectedIcon = FontAwesomeIcons.car;
                    });
                  },
                  color: selectedIcon == FontAwesomeIcons.car
                      ? Colors.indigo
                      : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Nom de la catégorie',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: TextField(
                controller: nomDepenseControlleur,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Entrez le nom de la catégorie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                User? user = _auth.currentUser;

                String userId = user!.uid;
                String nomDepense = nomDepenseControlleur.text;
                double prix = double.parse(prixControlleur.text);
                String iconUrl = "test";
                ajoutDepense(userId, nomDepense, prix, iconUrl).then((_) {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Valider',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
