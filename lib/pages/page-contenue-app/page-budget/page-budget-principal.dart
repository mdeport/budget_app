import 'package:application_budget_app/pages/navbottombar/navbottombar.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-accueil/page-accueil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-conseil/page-conseil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-parametre-principal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class Page_budget_principal extends StatefulWidget {
  const Page_budget_principal({super.key});

  @override
  State<Page_budget_principal> createState() => _Page_budget_principalState();
}

class _Page_budget_principalState extends State<Page_budget_principal> {
  int _selectedIndex = 0; // Index de la page sélectionnée

  final List<Widget> _pages = [
    // Les pages correspondant aux options de navigation
    DepensePage(),
    RevenuePage(),
    ObjectifPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30.0)),
        automaticallyImplyLeading: false,
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
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Text(
                        'Dépenses',
                        style: TextStyle(
                          color:
                              _selectedIndex == 0 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Text(
                        'Revenus',
                        style: TextStyle(
                          color:
                              _selectedIndex == 1 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: Text(
                        'Objectifs',
                        style: TextStyle(
                          color:
                              _selectedIndex == 2 ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_accueil_principal(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_budget_principal(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_conseil_principal(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Page_parametre_principal(),
              ),
            );
          }
        },
      ),
    );
  }
}

class DepensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SfCircularChart(
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                dataSource: <ChartData>[
                  ChartData('Expense 1', 30),
                  ChartData('Expense 2', 20),
                  ChartData('Expense 3', 25),
                  ChartData('Expense 4', 15),
                  ChartData('Expense 5', 10),
                  ChartData('Expense 6', 60),
                  ChartData('Expense 7', 70),
                ],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterDepensePage()),
          );
        },
        label: const Text('Ajouter des dépenses'),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}

class AjouterDepensePage extends StatefulWidget {
  @override
  _AjouterDepensePageState createState() => _AjouterDepensePageState();
}

class _AjouterDepensePageState extends State<AjouterDepensePage> {
  IconData selectedIcon = FontAwesomeIcons.shoppingBasket; // Icone par défaut

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
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class RevenuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page Revenus'),
    );
  }
}

class ObjectifPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Page Objectifs'),
    );
  }
}
