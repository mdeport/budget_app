import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/page-objectif-controlleur.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-objectif/page-ajouts-objectif.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-objectif.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class ObjectifPage extends StatefulWidget {
  const ObjectifPage({super.key});

  @override
  State<ObjectifPage> createState() => _ObjectifPageState();
}

class _ObjectifPageState extends State<ObjectifPage> {
  double totalRevenu = 0;
  double totalDepense = 0;

  Map<String, double> totalDepensesParCategorie = {};

  void initState() {
    super.initState();
    ListDepense();
    ListRevenus();
    calculateTotalDepensesParCategorie().then((totals) {
      setState(() {
        totalDepensesParCategorie = totals;
      });
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      listObjectif();
    });
  }

  Future<void> ListDepense() async {
    List<RechercheDepense> depenses = await listDepense();
    double total = 0;
    for (var depense in depenses) {
      total += depense.prix;
    }
    setState(() {
      totalDepense = total;
    });
  }

  Future<void> ListRevenus() async {
    List<RechercheRevenu> revenus = await listRevenu();
    double total = 0;
    for (var revenu in revenus) {
      total += revenu.prix;
    }
    setState(() {
      totalRevenu = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              series: <CartesianSeries>[
                ColumnSeries<Map<String, dynamic>, String>(
                  dataSource: <Map<String, dynamic>>[
                    {'category': 'Revenu', 'amount': totalRevenu},
                    {'category': 'Dépense', 'amount': totalDepense}
                  ],
                  xValueMapper: (Map<String, dynamic> data, _) =>
                      data['category'] as String,
                  yValueMapper: (Map<String, dynamic> data, _) =>
                      data['amount'] as double,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              child: FutureBuilder<List<RechercheObjectif>>(
                future: listObjectif(),
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
                    List<RechercheObjectif>? listObjectif = snapshot.data;
                    return ListView.builder(
                      itemCount: listObjectif!.length,
                      itemBuilder: (context, index) {
                        RechercheObjectif objectif = listObjectif[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Dismissible(
                            key: Key(objectif.nom_objectif),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmation"),
                                    content: const Text(
                                        "Voulez-vous vraiment supprimer l'objectif ?"),
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
                              // Supprimer l'objectif de la base de données
                              supprimerObjectif(objectif.docId);
                              _refreshData();
                            },
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newNomObjectif =
                                        objectif.nom_objectif;
                                    String newPrix = objectif.prix.toString();
                                    final nomObjectifController =
                                        TextEditingController(
                                            text: newNomObjectif);
                                    final prixController =
                                        TextEditingController(text: newPrix);
                                    String selectedCategory =
                                        objectif.nom_objectif;

                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title:
                                              const Text("Modifier l'objectif"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Catégorie',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: selectedCategory,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedCategory =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    'Épicerie',
                                                    'Maison',
                                                    'Vêtements & Chaussures',
                                                    'Sorties au restaurant',
                                                    'Transport',
                                                    'Divertissement',
                                                    'Enfants',
                                                    'Voyage',
                                                    'Santé',
                                                    'Beauté',
                                                    'Communication',
                                                    'Voiture',
                                                    'Animaux de compagnie',
                                                    'Impôts',
                                                    'Education',
                                                    'Divers',
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  underline: Container(
                                                    height: 0,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Montant',
                                                ),
                                                controller: prixController,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Annuler"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                String newNomObjectif =
                                                    nomObjectifController.text;
                                                String newPrix =
                                                    prixController.text;
                                                double newPrice =
                                                    double.tryParse(newPrix) ??
                                                        0.0;
                                                updateObjectifPrix(
                                                    newPrice,
                                                    objectif.docId,
                                                    newNomObjectif);
                                                Navigator.of(context).pop();
                                                _refreshData();
                                              },
                                              child: const Text("Confirmer"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              leading: Icon(
                                icons[objectif.Icon],
                                color: Color(
                                    int.parse('0xff' + objectif.CouleurIcon)),
                              ),
                              title: Text(
                                objectif.nom_objectif,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${totalDepensesParCategorie[objectif.nom_objectif]?.toString() ?? '0'} / ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      objectif.prix.toStringAsFixed(
                                          objectif.prix.truncateToDouble() ==
                                                  objectif.prix
                                              ? 0
                                              : 2),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Text(
                                      '€',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
            MaterialPageRoute(
                builder: (context) => const AjouterObjectifPage()),
          ).then((refresh) {
            if (refresh != null && refresh) {
              _refreshData();
            }
          });
        },
        label: const Text('Ajouter des objectifs',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}

Future<Map<String, double>> calculateTotalDepensesParCategorie() async {
  Map<String, double> totalDepensesParCategorie = {};

  List<RechercheCategorieDepense> depenses = await listCategorieDepense();

  for (var depense in depenses) {
    if (totalDepensesParCategorie.containsKey(depense.nom_categorie)) {
      totalDepensesParCategorie[depense.nom_categorie] =
          (totalDepensesParCategorie[depense.nom_categorie] ?? 0) +
              depense.prix;
    } else {
      totalDepensesParCategorie[depense.nom_categorie] = depense.prix;
    }
  }

  return totalDepensesParCategorie;
}
