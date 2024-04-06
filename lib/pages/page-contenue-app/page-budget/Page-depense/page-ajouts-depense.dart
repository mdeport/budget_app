import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-budget-principal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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

  List<IconData> depenseIcons = [
    FontAwesomeIcons.shoppingBasket,
    FontAwesomeIcons.car,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.home,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.medkit,
    FontAwesomeIcons.paw,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.book,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.bus,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.coffee,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.cut,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.cocktail,
    FontAwesomeIcons.fileInvoiceDollar,
    FontAwesomeIcons.gasPump,
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.hamburger,
    FontAwesomeIcons.heartbeat,
    FontAwesomeIcons.mortarPestle,
    FontAwesomeIcons.music,
    FontAwesomeIcons.paintBrush,
    FontAwesomeIcons.paperPlane,
    FontAwesomeIcons.pencilAlt,
    FontAwesomeIcons.phone,
    FontAwesomeIcons.running,
    FontAwesomeIcons.snowflake,
    FontAwesomeIcons.smoking,
    FontAwesomeIcons.shoppingBag,
    FontAwesomeIcons.spa,
    FontAwesomeIcons.suitcase,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.swimmingPool,
    FontAwesomeIcons.taxi,
    FontAwesomeIcons.ticketAlt,
    FontAwesomeIcons.train,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.tv,
    FontAwesomeIcons.wineBottle,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.video,
    FontAwesomeIcons.shoppingCart,
  ];

  bool showAllIcons = false;

  @override
  Widget build(BuildContext context) {
    List<IconData> displayedIcons =
        showAllIcons ? depenseIcons : depenseIcons.take(10).toList();

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
                return IconButton(
                  icon: Icon(icon, color: selectedColor),
                  onPressed: () {
                    setState(() {
                      selectedIcon = icon;
                      chosenIcon = icon;
                    });
                  },
                  color: selectedIcon == icon ? Colors.indigo : Colors.grey,
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

Map<IconData, String> iconNames = {
  FontAwesomeIcons.shoppingBasket: 'shopping_basket',
  FontAwesomeIcons.car: 'car',
  FontAwesomeIcons.utensils: 'utensils',
  FontAwesomeIcons.home: 'home',
  FontAwesomeIcons.heart: 'heart',
  FontAwesomeIcons.medkit: 'medkit',
  FontAwesomeIcons.paw: 'paw',
  FontAwesomeIcons.bolt: 'bolt',
  FontAwesomeIcons.book: 'book',
  FontAwesomeIcons.briefcase: 'briefcase',
  FontAwesomeIcons.bus: 'bus',
  FontAwesomeIcons.plane: 'plane',
  FontAwesomeIcons.coffee: 'coffee',
  FontAwesomeIcons.creditCard: 'credit_card',
  FontAwesomeIcons.cut: 'cut',
  FontAwesomeIcons.bed: 'bed',
  FontAwesomeIcons.dumbbell: 'dumbbell',
  FontAwesomeIcons.cocktail: 'cocktail',
  FontAwesomeIcons.fileInvoiceDollar: 'file_invoice_dollar',
  FontAwesomeIcons.gasPump: 'gas_pump',
  FontAwesomeIcons.graduationCap: 'graduation_cap',
  FontAwesomeIcons.hamburger: 'hamburger',
  FontAwesomeIcons.heartbeat: 'heartbeat',
  FontAwesomeIcons.mortarPestle: 'mortar_pestle',
  FontAwesomeIcons.music: 'music',
  FontAwesomeIcons.paintBrush: 'paint_brush',
  FontAwesomeIcons.paperPlane: 'paper_plane',
  FontAwesomeIcons.pencilAlt: 'pencil_alt',
  FontAwesomeIcons.phone: 'phone',
  FontAwesomeIcons.running: 'running',
  FontAwesomeIcons.snowflake: 'snowflake',
  FontAwesomeIcons.smoking: 'smoking',
  FontAwesomeIcons.shoppingBag: 'shopping_bag',
  FontAwesomeIcons.spa: 'spa',
  FontAwesomeIcons.suitcase: 'suitcase',
  FontAwesomeIcons.sun: 'sun',
  FontAwesomeIcons.swimmingPool: 'swimming_pool',
  FontAwesomeIcons.taxi: 'taxi',
  FontAwesomeIcons.ticketAlt: 'ticket_alt',
  FontAwesomeIcons.train: 'train',
  FontAwesomeIcons.tree: 'tree',
  FontAwesomeIcons.tv: 'tv',
  FontAwesomeIcons.wineBottle: 'wine_bottle',
  FontAwesomeIcons.wallet: 'wallet',
  FontAwesomeIcons.video: 'video',
  FontAwesomeIcons.shoppingCart: 'shopping_cart',
};
