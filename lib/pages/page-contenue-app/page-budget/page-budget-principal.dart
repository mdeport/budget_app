import 'package:application_budget_app/pages/navbottombar/navbottombar.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-accueil/page-accueil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-conseil/page-conseil-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-parametre-principal.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/Page-depense/page-ajouts-depense.dart';
import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class Page_budget_principal extends StatefulWidget {
  const Page_budget_principal({super.key});

  @override
  State<Page_budget_principal> createState() => _Page_budget_principalState();
}

class _Page_budget_principalState extends State<Page_budget_principal> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
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
          Expanded(
            child: FutureBuilder<List<ChartData>>(
              future: fetchChartDataFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                } else {
                  List<ChartData>? chartDataList = snapshot.data;
                  double totalValue = calculateTotalValue(chartDataList!);
                  return Stack(
                    children: [
                      if (chartDataList.isEmpty)
                        const Center(
                          child: Text(
                            'Veuillez ajouter des dépenses pour commencer a voir le graphique et les dépenses.',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                      else
                        Center(
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                dataSource: chartDataList,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                innerRadius: '50%',
                              )
                            ],
                          ),
                        ),
                      if (chartDataList.isEmpty)
                        const Center(
                          child: Text(
                            'Veuillez ajouter des dépenses pour commencer a voir le graphique et les dépenses.',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                      else
                        Center(
                          child: Text(
                            '$totalValue',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              child: FutureBuilder<List<RechercheDepense>>(
                future: fetchExpensesFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erreur: ${snapshot.error}'),
                    );
                  } else {
                    List<RechercheDepense>? listDepense = snapshot.data;
                    return ListView.builder(
                      itemCount: listDepense!.length,
                      itemBuilder: (context, index) {
                        RechercheDepense depense = listDepense[index];
                        return Dismissible(
                          key: Key(depense.nom_depense),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            // cela va afficher une boîte de dialogue de confirmation pour supprimer la dépense
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmation"),
                                  content: const Text(
                                      "Voulez-vous vraiment supprimer la depense ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Annuler"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Supprimer"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            // Supprimer la dépense de la base de données
                            supprimerDepense(depense.nom_depense);
                          },
                          child: ListTile(
                            leading: const Icon(Icons.money),
                            title: Text(depense.nom_depense),
                            trailing: SizedBox(
                              width: 100,
                              child: TextFormField(
                                initialValue: depense.prix.toString(),
                                onChanged: (newValue) {
                                  // Mettre à jour la valeur dans la base de données
                                  double newPrice =
                                      double.tryParse(newValue) ?? 0.0;
                                  updateDepensePrix(
                                      depense.nom_depense, newPrice);
                                  // ou dans une liste temporaire selon vos besoins
                                  print(newValue);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    /*return ListView.builder(
                      itemCount: listDepense!.length,
                      itemBuilder: (context, index) {
                        RechercheDepense expense = listDepense[index];
                        return ListTile(
                          leading: Icon(Icons.money),
                          title: Text(expense.nom_depense),
                          trailing: SizedBox(
                            width: 100,
                            child: TextFormField(
                              initialValue: expense.prix.toString(),
                              onChanged: (newValue) {
                                // Mettre à jour la valeur dans la base de données
                                // ou dans une liste temporaire selon vos besoins
                              },
                            ),
                          ),
                        );
                      },
                    );*/
                  }
                },
              ),
            ),
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

  double calculateTotalValue(List<ChartData> data) {
    double total = 0;
    for (var item in data) {
      total += item.y;
    }
    return double.parse(total.toStringAsFixed(2));
  }
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
