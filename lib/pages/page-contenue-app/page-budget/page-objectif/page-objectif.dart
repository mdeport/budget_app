import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/page-objectif/page-ajouts-objectif.dart';
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

  void initState() {
    super.initState();
    ListDepense();
    ListRevenus();
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
                height: 200,
                child: Text(
                    'Total Revenu: $totalRevenu\nTotal Dépense: $totalDepense')),
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
            if (refresh != null && refresh) {}
          });
        },
        label: const Text('Ajouter des objectifs',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}
