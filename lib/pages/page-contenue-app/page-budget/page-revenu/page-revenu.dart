import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/Page-revenu/page-ajouts-revenu.dart';
import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-revenu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  bool dataEmpty = true;
  @override
  void initState() {
    super.initState();
    listRevenuChartDataList();
  }

  Future<void> refreshData() async {
    setState(() {
      listRevenuChartDataList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<List<ChartDatarevenu>>(
              future: listRevenuChartDataList(),
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
                  List<ChartDatarevenu>? chartDataList = snapshot.data;
                  double totalValue = calculateTotalValue(chartDataList!);
                  dataEmpty = chartDataList.isEmpty;
                  return Stack(
                    children: [
                      if (chartDataList.isEmpty)
                        const Center(
                          child: Text(
                            'Veuillez ajouter des revenus pour commencer a voir le graphique et les revenus.',
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
                              DoughnutSeries<ChartDatarevenu, String>(
                                dataSource: chartDataList,
                                pointColorMapper: (ChartDatarevenu data, _) =>
                                    Color(int.parse('0xff' + data.color)),
                                xValueMapper: (ChartDatarevenu data, _) =>
                                    data.x,
                                yValueMapper: (ChartDatarevenu data, _) =>
                                    data.y,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                innerRadius: '60%',
                              ),
                            ],
                          ),
                        ),
                      if (chartDataList.isEmpty)
                        const Center(
                          child: Text(
                            'Veuillez ajouter des revenus pour commencer a voir le graphique et les revenus.',
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
          /*
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Total des revenues :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Reste :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),*/
          Expanded(
            child: SizedBox(
              child: FutureBuilder<List<RechercheRevenu>>(
                future: listRevenu(),
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
                    List<RechercheRevenu>? listRevenu = snapshot.data;
                    return ListView.builder(
                      itemCount: listRevenu!.length,
                      itemBuilder: (context, index) {
                        RechercheRevenu revenu = listRevenu[index];
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
                            key: Key(revenu.nom_revenu),
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
                                        "Voulez-vous vraiment supprimer le revenu ?"),
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
                              supprimerRevenu(revenu.docId);
                              refreshData();
                            },
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newNomRevenu = revenu.nom_revenu;
                                    String newPrix = revenu.prix.toString();
                                    final nomRevenuController =
                                        TextEditingController(
                                            text: newNomRevenu);
                                    final prixController =
                                        TextEditingController(text: newPrix);

                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title:
                                              const Text("Modifier le revenu"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Nom de la dépense',
                                                ),
                                                controller: nomRevenuController,
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
                                                String newNomRevenu =
                                                    nomRevenuController.text;
                                                String newPrix =
                                                    prixController.text;
                                                double newPrice =
                                                    double.tryParse(newPrix) ??
                                                        0.0;
                                                updateRevenuPrix(newPrice,
                                                    revenu.docId, newNomRevenu);
                                                Navigator.of(context).pop();
                                                refreshData();
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
                                iconsRevenus[revenu.Icon],
                                color: Color(
                                    int.parse('0xff' + revenu.CouleurIcon)),
                              ),
                              title: Text(
                                revenu.nom_revenu,
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
                                      revenu.prix.toString(),
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
            MaterialPageRoute(builder: (context) => AjouterRevenuPage()),
          );
        },
        label: const Text('Ajouter des revenus',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }

  double calculateTotalValue(List<ChartDatarevenu> data) {
    double total = 0;
    for (var item in data) {
      total += item.y;
    }
    return double.parse(total.toStringAsFixed(2));
  }
}
