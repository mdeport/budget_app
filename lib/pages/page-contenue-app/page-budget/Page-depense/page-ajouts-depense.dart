import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-budget-principal.dart';
import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:application_budget_app/base-de-donnees/list-icon.dart';
import 'package:flutter/material.dart';

class AjouterDepensePage extends StatefulWidget {
  @override
  _AjouterDepensePageState createState() => _AjouterDepensePageState();
}

class _AjouterDepensePageState extends State<AjouterDepensePage> {
  IconData selectedIcon = Icons.shopping_basket;
  Color selectedColor = Colors.blue;
  IconData? chosenIcon;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController prixControlleur = TextEditingController();
  TextEditingController nomDepenseControlleur = TextEditingController();

  bool showAllIcons = false;

  @override
  Widget build(BuildContext context) {
    List<IconData> displayedIcons =
        showAllIcons ? depenseIcons : depenseIcons.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une dépense',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 23)),
        flexibleSpace: Container(
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
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
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: displayedIcons.length,
              itemBuilder: (context, index) {
                final icon = displayedIcons[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIcon = icon;
                      chosenIcon = icon;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: selectedIcon == icon
                          ? Colors.indigo.withOpacity(0.2)
                          : null,
                    ),
                    child: Icon(icon, color: selectedColor),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            if (!showAllIcons)
              TextButton(
                onPressed: () {
                  setState(() {
                    showAllIcons = true;
                  });
                },
                child: const Text(
                  'Voir plus',
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            if (showAllIcons)
              TextButton(
                onPressed: () {
                  setState(() {
                    showAllIcons = false;
                  });
                },
                child: const Text(
                  'Voir moins',
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            const SizedBox(height: 30),
            const Text(
              'Choisissez une couleur',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choisir une couleur'),
                      content: SingleChildScrollView(
                        child: MaterialColorPicker(
                          selectedColor: selectedColor,
                          onColorChange: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          circleSize: 40.0,
                          spacing: 10.0,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Choisir'),
            ),
            const SizedBox(height: 30),
            const Text(
              'Nom de la catégorie',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
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
                if (nomDepenseControlleur.text.isEmpty ||
                    prixControlleur.text.isEmpty ||
                    chosenIcon == null) {
                  // Afficher un message d'alerte si un champ est vide ou si aucune icône n'est choisie
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Veuillez remplir tous les champs et choisir une icône.'),
                    ),
                  );
                } else {
                  // Tous les champs sont remplis, procéder à l'ajout de la dépense
                  User? user = _auth.currentUser;
                  String userId = user!.uid;
                  String nomDepense = nomDepenseControlleur.text;
                  double prix = double.parse(prixControlleur.text);
                  String iconName = iconNames[chosenIcon!] ?? 'icon_inconnu';
                  String iconUrl = iconName;
                  String couleur = selectedColor.value.toRadixString(16);
                  print(
                      'Ajout de la dépense: $nomDepense, $prix, $iconUrl, $couleur');
                  ajoutDepense(
                    userId,
                    nomDepense,
                    prix,
                    iconUrl,
                    couleur,
                  ).then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Page_budget_principal(),
                      ),
                    );
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Valider',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
