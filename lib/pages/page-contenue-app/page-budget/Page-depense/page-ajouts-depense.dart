import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-objectif.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-depense.dart';
import 'package:flutter/material.dart';

class AjouterDepensePage extends StatefulWidget {
  @override
  _AjouterDepensePageState createState() => _AjouterDepensePageState();
}

class _AjouterDepensePageState extends State<AjouterDepensePage> {
  IconData selectedIcon = Icons.shopping_basket;
  String selectedCategory = '';
  Color selectedColor = Colors.blue;
  Color selectedIconColor = Colors.blue;
  IconData? chosenIcon;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController prixControlleur = TextEditingController();
  TextEditingController nomDepenseControlleur = TextEditingController();

  bool showAllIcons = false;

  List<DropdownMenuItem<String>> buildDropdownMenuItems(
      List categoriesWithIcons) {
    List<DropdownMenuItem<String>> items = [];
    for (var item in categoriesWithIcons) {
      items.add(
        DropdownMenuItem<String>(
          value: item['category'],
          child: Row(
            children: [
              Icon(item['icon'], color: selectedIconColor),
              const SizedBox(width: 10),
              Text(item['category']),
            ],
          ),
        ),
      );
    }
    return items;
  }

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
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            const Text(
              'Choix de la catégorie',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.indigo),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: buildDropdownMenuItems(categoriesWithIcons),
                underline: Container(
                  height: 0,
                  color: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nom de la dépense',
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
                  hintText: 'Entrez le nom de la dépense',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                String prixSansVirgule =
                    prixControlleur.text.replaceAll(",", ".");
                if (nomDepenseControlleur.text.isEmpty ||
                    prixControlleur.text.isEmpty ||
                    chosenIcon == null ||
                    selectedCategory == '') {
                  // Afficher un message d'alerte si un champ est vide ou si aucune icône n'est choisie
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Veuillez remplir tous les champs et choisir une icône.'),
                    ),
                  );
                } else if (double.tryParse(prixSansVirgule) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Le montant n'est pas valide."),
                    ),
                  );
                } else {
                  User? user = _auth.currentUser;
                  String userId = user!.uid;
                  String nomDepense = nomDepenseControlleur.text;
                  String nomCategorie = selectedCategory;
                  double prix = double.parse(prixSansVirgule);
                  String iconName = iconNames[chosenIcon!] ?? 'icon_inconnu';
                  String iconUrl = iconName;
                  String couleur = selectedColor.value.toRadixString(16);
                  ajoutDepense(
                    userId,
                    nomDepense,
                    nomCategorie,
                    prix,
                    iconUrl,
                    couleur,
                  ).then((_) {
                    Navigator.of(context).pop(true);
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
