import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-objectif.dart';
import 'package:application_budget_app/base-de-donnees/page-objectif-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AjouterObjectifPage extends StatefulWidget {
  const AjouterObjectifPage({Key? key}) : super(key: key);

  @override
  State<AjouterObjectifPage> createState() => _AjouterObjectifPageState();
}

class _AjouterObjectifPageState extends State<AjouterObjectifPage> {
  String selectedCategory = '';
  IconData selectedIcon = Icons.shopping_basket;
  Color selectedColor = Colors.blue;
  Color selectedIconColor = Colors.blue;
  IconData? chosenIcon;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController montantController = TextEditingController();
  TextEditingController nomObjectifControlleur = TextEditingController();
  TextEditingController dateControlleur = TextEditingController();

  bool showAllIcons = false;

  // Méthode pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateControlleur.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ajouter un objectif',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2196F3), // Bleu pastel
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
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
                        chosenIcon = categoriesWithIcons.firstWhere((item) =>
                            item['category'] == selectedCategory)['icon'];
                      });
                    },
                    items: buildDropdownMenuItems(categoriesWithIcons),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Montant de l\'objectif',
                  style: TextStyle(fontSize: 20, color: Colors.indigo),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: montantController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Entrez le montant de l\'objectif',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Choix de la date',
                  style: TextStyle(fontSize: 20, color: Colors.indigo),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: dateControlleur,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Sélectionnez une date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    readOnly: true,
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
                                  selectedIconColor = color;
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
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    String prixSansVirgule =
                        montantController.text.replaceAll(",", ".");
                    if (selectedCategory.isEmpty ||
                        montantController.text.isEmpty ||
                        chosenIcon == '' ||
                        dateControlleur.text.isEmpty) {
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
                      String nomObjectif = selectedCategory;
                      double prix = double.parse(prixSansVirgule);
                      String iconName =
                          iconNamesobjectif[chosenIcon!] ?? 'icon_inconnu';
                      String iconUrl = iconName;
                      String couleur = selectedColor.value.toRadixString(16);
                      String date = dateControlleur.text;
                      ajoutObjectif(
                        userId,
                        nomObjectif,
                        prix,
                        iconUrl,
                        couleur,
                        date,
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
        ),
      ),
    );
  }
}
