import 'package:application_budget_app/pages/page-contenue-app/page-budget/Page-depense/page-ajouts-depense.dart';
import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-depense.dart';
import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class DepensePage extends StatefulWidget {
  const DepensePage({super.key});

  @override
  State<DepensePage> createState() => _DepensePageState();
}

class _DepensePageState extends State<DepensePage> {
  double totalRevenu = 0;
  bool dataEmpty = true;
  @override
  void initState() {
    super.initState();
    fetchRevenus();
  }

  Future<void> _refreshData() async {
    setState(() {
      listDepenseChartDataList();
    });
  }

  Future<void> fetchRevenus() async {
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
            child: FutureBuilder<List<ChartData>>(
              future: listDepenseChartDataList(),
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
                  double totalValue = calculTotalDepense(chartDataList!);
                  double Reste = totalRevenu - totalValue;
                  Reste = double.parse(Reste.toStringAsFixed(2));
                  dataEmpty = chartDataList.isEmpty;
                  return Stack(
                    children: [
                      Center(
                        child: chartDataList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Aucune dépense enregistré.\n\nAjoutez des dépenses pour voir votre graphique ainsi que votre liste de dépense.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Center(
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        DoughnutSeries<ChartData, String>(
                                          dataSource: chartDataList,
                                          pointColorMapper:
                                              (ChartData data, _) => Color(
                                                  int.parse(
                                                      '0xff' + data.color)),
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true),
                                          innerRadius: '60%',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    child: Center(
                                      child: Text(
                                        '$totalValue €',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total des revenues : $totalRevenu €',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Reste : $Reste €',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                future: listDepense(),
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
                              supprimerDepense(depense.docId);
                              _refreshData();
                            },
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newNomDepense = depense.nom_depense;
                                    String newPrix = depense.prix.toString();
                                    final nomDepenseController =
                                        TextEditingController(
                                            text: newNomDepense);
                                    final prixController =
                                        TextEditingController(text: newPrix);

                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title:
                                              const Text("Modifier la dépense"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Nom de la dépense',
                                                ),
                                                controller:
                                                    nomDepenseController,
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
                                                String newNomDepense =
                                                    nomDepenseController.text;
                                                String newPrix =
                                                    prixController.text;
                                                double newPrice =
                                                    double.tryParse(newPrix) ??
                                                        0.0;
                                                updateDepensePrix(
                                                    newPrice,
                                                    depense.docId,
                                                    newNomDepense);
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
                                icons[depense.Icon],
                                color: Color(
                                    int.parse('0xff' + depense.CouleurIcon)),
                              ),
                              title: Text(
                                depense.nom_depense,
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
                                      depense.prix.toStringAsFixed(
                                          depense.prix.truncateToDouble() ==
                                                  depense.prix
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
            MaterialPageRoute(builder: (context) => AjouterDepensePage()),
          ).then((refresh) {
            if (refresh != null && refresh) {
              _refreshData();
            }
          });
        },
        label: const Text('Ajouter des dépenses',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }

  double calculTotalDepense(List<ChartData> data) {
    double total = 0;
    for (var item in data) {
      total += item.y;
    }
    return double.parse(total.toStringAsFixed(2));
  }
}
