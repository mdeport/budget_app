import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/Page-revenu/page-ajouts-revenu.dart';
import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-revenu.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  bool dataEmpty = true;
  DateTime selectedMonth = DateTime.now();

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

  void _previousMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    });
  }

  Future<List<ChartDatarevenu>> listRevenuChartDataList() async {
    List<ChartDatarevenu> chartDataList = [];
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('revenu')
            .doc(user.uid)
            .collection('revenus')
            .get();
        querySnapshot.docs.forEach((doc) {
          DateTime date = DateTime.parse(doc['date']);
          if (date.year == selectedMonth.year &&
              date.month == selectedMonth.month) {
            double prix = (doc['prix'] as num).toDouble();
            String CouleurIcon = doc['couleur_icon'];
            chartDataList
                .add(ChartDatarevenu(doc['nom_revenu'], prix, CouleurIcon));
          }
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données depuis Firestore: $e');
    }
    return chartDataList;
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> displayedIcons = revenuIcons;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Container(
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: _previousMonth,
                    ),
                    Text(
                      DateFormat.yMMM().format(selectedMonth),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                                  'Aucun revenu enregistré.\n\nAjoutez des revenus pour voir votre graphique ainsi que votre liste de revenus.',
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
                                        DoughnutSeries<ChartDatarevenu, String>(
                                          dataSource: chartDataList,
                                          pointColorMapper:
                                              (ChartDatarevenu data, _) =>
                                                  Color(int.parse(
                                                      '0xff' + data.color)),
                                          xValueMapper:
                                              (ChartDatarevenu data, _) =>
                                                  data.x,
                                          yValueMapper:
                                              (ChartDatarevenu data, _) =>
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
                                        '$totalValue',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
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
                    List<RechercheRevenu> filteredRevenus =
                        listRevenu!.where((revenu) {
                      DateTime date = DateTime.parse(revenu.date);
                      return date.year == selectedMonth.year &&
                          date.month == selectedMonth.month;
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredRevenus.length + 1,
                      itemBuilder: (context, index) {
                        if (index == filteredRevenus.length) {
                          return const SizedBox(height: 70);
                        }
                        RechercheRevenu revenu = filteredRevenus[index];
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

                                    DateTime selectedDate =
                                        DateTime.parse(revenu.date);
                                    Color selectedColor =
                                        revenu.CouleurIcon != null
                                            ? Color(int.parse(
                                                '0xff' + revenu.CouleurIcon))
                                            : Colors.blue;
                                    IconData? selectedIcon =
                                        iconsRevenus[revenu.Icon] ??
                                            Icons.help_outline;
                                    IconData? chosenIcon;
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
                                                  labelText: 'Nom du revenu',
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
                                              const SizedBox(height: 5),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Date',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: selectedDate,
                                                    firstDate: DateTime(
                                                        DateTime.now().year -
                                                            5),
                                                    lastDate: DateTime(
                                                        DateTime.now().year +
                                                            5),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return Theme(
                                                        data: ThemeData.light()
                                                            .copyWith(
                                                          colorScheme:
                                                              const ColorScheme
                                                                  .light(
                                                            primary: Colors
                                                                .indigoAccent,
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  ).then((newDate) {
                                                    if (newDate != null) {
                                                      setState(() {
                                                        selectedDate = newDate;
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.calendar_today),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      DateFormat.yMMMd()
                                                          .format(selectedDate),
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Choisir une icône'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Wrap(
                                                            spacing: 20,
                                                            runSpacing: 20,
                                                            children:
                                                                displayedIcons
                                                                    .map(
                                                                        (icon) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedIcon =
                                                                        icon;
                                                                    chosenIcon =
                                                                        icon;
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Icon(
                                                                  icon,
                                                                  color: selectedIcon ==
                                                                          icon
                                                                      ? selectedColor
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Annuler'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(selectedIcon,
                                                        color: selectedColor),
                                                    const SizedBox(width: 17),
                                                    const Text(
                                                        'Changer l\'icône',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Choisir une couleur'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child:
                                                              MaterialColorPicker(
                                                            selectedColor:
                                                                selectedColor,
                                                            onColorChange:
                                                                (Color color) {
                                                              setState(() {
                                                                selectedColor =
                                                                    color;
                                                              });
                                                            },
                                                            circleSize: 40.0,
                                                            spacing: 10.0,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'OK'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color: selectedColor,
                                                    ),
                                                    const SizedBox(width: 17),
                                                    const Text(
                                                      'Changer la couleur',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
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
                                                String newPrix = prixController
                                                    .text
                                                    .replaceAll(",", ".");
                                                double newPrice =
                                                    double.tryParse(newPrix) ??
                                                        0.0;

                                                IconData finalIcon =
                                                    chosenIcon ?? selectedIcon!;
                                                String iconName =
                                                    iconNamesRevenu[
                                                            finalIcon] ??
                                                        'icon_inconnu';
                                                String iconUrl = iconName;
                                                String couleur = selectedColor
                                                    .value
                                                    .toRadixString(16);
                                                updateRevenuPrix(
                                                  newPrice,
                                                  revenu.docId,
                                                  newNomRevenu,
                                                  selectedDate
                                                      .toIso8601String(),
                                                  couleur,
                                                  iconUrl,
                                                );
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
                              subtitle: Text(
                                DateFormat.yMMMd().format(
                                    DateTime.parse(revenu.date).toLocal()),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      revenu.prix.toStringAsFixed(
                                          revenu.prix.truncateToDouble() ==
                                                  revenu.prix
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
              builder: (context) => const AjouterRevenuPage(),
            ),
          ).then((refresh) {
            if (refresh != null && refresh) {
              refreshData();
            }
          });
        },
        label: const Text('Ajouter des revenus',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
