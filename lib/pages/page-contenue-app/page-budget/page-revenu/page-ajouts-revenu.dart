import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-revenu.dart';
import 'package:flutter/material.dart';

class AjouterRevenuPage extends StatefulWidget {
  const AjouterRevenuPage({super.key});

  @override
  State<AjouterRevenuPage> createState() => _AjouterRevenuPage();
}

class _AjouterRevenuPage extends State<AjouterRevenuPage> {
  IconData selectedIcon = Icons.shopping_basket;
  Color selectedColor = Colors.blue;
  IconData? chosenIcon;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController prixControlleur = TextEditingController();
  TextEditingController nomRevenuControlleur = TextEditingController();
  TextEditingController dateControlleur = TextEditingController();

  bool showAllIcons = false;

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

  @override
  Widget build(BuildContext context) {
    List<IconData> displayedIcons =
        showAllIcons ? revenuIcons : revenuIcons.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ajouter un revenu',
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: dateControlleur,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Date du revenu',
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
              const SizedBox(height: 20),
              const Text(
                'Nom du revenu',
                style: TextStyle(fontSize: 20, color: Colors.indigo),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nomRevenuControlleur,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Entrez le nom du revenu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
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
                    suffixText: '€',
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
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
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  String prixSansVirgule =
                      prixControlleur.text.replaceAll(",", ".");
                  if (nomRevenuControlleur.text.isEmpty ||
                      prixControlleur.text.isEmpty ||
                      chosenIcon == null ||
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
                    String nomRevenue = nomRevenuControlleur.text;
                    double prix = double.parse(prixSansVirgule);
                    String iconName =
                        iconNamesRevenu[chosenIcon!] ?? 'icon_inconnu';
                    String iconUrl = iconName;
                    String couleur = selectedColor.value.toRadixString(16);
                    String date = dateControlleur.text;
                    ajoutRevenu(
                      userId,
                      nomRevenue,
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
    );
  }
}
