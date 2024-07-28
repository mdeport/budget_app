import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-budget/Page-depense/page-ajouts-depense.dart';
import 'package:application_budget_app/base-de-donnees/page-revenu-controlleur.dart';
import 'package:application_budget_app/base-de-donnees/Icons/list-icon-depense.dart';
import 'package:application_budget_app/base-de-donnees/page-depense-controlleur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DepensePage extends StatefulWidget {
  const DepensePage({Key? key}) : super(key: key);

  @override
  State<DepensePage> createState() => _DepensePageState();
}

class _DepensePageState extends State<DepensePage> {
  double totalRevenu = 0;
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchRevenus();
    listDepenseChartDataList();
    listDepense();
  }

  Future<void> _refreshData() async {
    setState(() {});
    fetchRevenus();
    listDepenseChartDataList();
    listDepense();
  }

  Future<void> fetchRevenus() async {
    List<RechercheRevenu> revenus = await listRevenu();
    double total = 0;
    for (var revenu in revenus) {
      DateTime dateRevenu = DateTime.parse(revenu.date);
      if (dateRevenu.year == selectedMonth.year &&
          dateRevenu.month == selectedMonth.month) {
        total += revenu.prix;
      }
    }
    setState(() {
      totalRevenu = total;
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

  List<RechercheDepense> _filterDepensesByMonth(
      List<RechercheDepense> depenses) {
    return depenses.where((depense) {
      DateTime date = DateTime.parse(depense.date);
      return date.year == selectedMonth.year &&
          date.month == selectedMonth.month;
    }).toList();
  }

  Future<List<ChartData>> listDepenseChartDataList() async {
    List<ChartData> chartDataList = [];
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('depense')
            .doc(user.uid)
            .collection('depenses')
            .get();
        querySnapshot.docs.forEach((doc) {
          DateTime date = DateTime.parse(doc['date']);
          if (date.year == selectedMonth.year &&
              date.month == selectedMonth.month) {
            double prix = doc['prix'] ?? 0.0;
            String CouleurIcon = doc['couleur_icon'];
            chartDataList.add(ChartData(doc['nom_depense'], prix, CouleurIcon));
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
    List<IconData> displayedIcons = depenseIcons;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
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
            flex: 5,
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
                  double rest = totalRevenu - totalValue;
                  rest = double.parse(rest.toStringAsFixed(2));

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
                                  'Aucune dépense enregistrée.\n\nAjoutez des dépenses pour voir votre graphique ainsi que votre liste de dépenses.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : Center(
                                child: SfCircularChart(
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: chartDataList,
                                      pointColorMapper: (ChartData data, _) =>
                                          Color(int.parse('0xff' + data.color)),
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
                      ),
                      if (chartDataList.isNotEmpty)
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
                      if (chartDataList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total des revenus : $totalRevenu €',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Reste : $rest €',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
            flex: 5,
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
                  List<RechercheDepense> filteredDepenses =
                      _filterDepensesByMonth(listDepense!);

                  return ListView.builder(
                    itemCount: filteredDepenses.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredDepenses.length) {
                        return const SizedBox(height: 30);
                      }
                      RechercheDepense depense = filteredDepenses[index];
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
                                      "Voulez-vous vraiment supprimer la dépense ?"),
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
                              TextEditingController nomDepenseController =
                                  TextEditingController(
                                      text: depense.nom_depense);
                              TextEditingController prixController =
                                  TextEditingController(
                                      text: depense.prix.toString());
                              String selectedCategory = depense.nom_categorie;
                              DateTime selectedDate =
                                  DateTime.parse(depense.date);
                              Color selectedColor = depense.CouleurIcon != null
                                  ? Color(
                                      int.parse('0xff' + depense.CouleurIcon))
                                  : Colors.blue;
                              IconData? selectedIcon =
                                  icons[depense.Icon] ?? Icons.help_outline;
                              IconData? chosenIcon;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("Modifier dépense"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller:
                                                    nomDepenseController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      "Nom de la dépense",
                                                ),
                                              ),
                                              TextField(
                                                controller: prixController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Prix",
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                              const SizedBox(height: 5),
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
                                              const SizedBox(height: 5),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: selectedCategory,
                                                    onChanged: (newValue) {
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
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
                                              String newPrix = prixController
                                                  .text
                                                  .replaceAll(",", ".");
                                              double newPrice =
                                                  double.tryParse(newPrix) ??
                                                      0.0;
                                              String newCategorie =
                                                  selectedCategory;
                                              IconData finalIcon =
                                                  chosenIcon ?? selectedIcon!;
                                              String iconName =
                                                  iconNames[finalIcon] ??
                                                      'icon_inconnu';
                                              String iconUrl = iconName;
                                              String couleur = selectedColor
                                                  .value
                                                  .toRadixString(16);
                                              updateDepensePrix(
                                                newPrice,
                                                depense.docId,
                                                newNomDepense,
                                                newCategorie,
                                                selectedDate.toIso8601String(),
                                                couleur,
                                                iconUrl,
                                              );
                                              setState(() {
                                                _refreshData();
                                              });
                                              Navigator.of(context).pop();
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  depense.nom_categorie,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd().format(
                                    DateTime.parse(depense.date),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
