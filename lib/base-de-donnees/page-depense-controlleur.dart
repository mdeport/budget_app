import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Ajoutez une dépense en Base de données
Future<void> ajoutDepense(String userId, String nomDepense, String nomCategorie,
    double prix, String IconUrl, String CouleurIcon, String date) async {
  try {
    await FirebaseFirestore.instance
        .collection('depense')
        .doc(userId)
        .collection('depenses')
        .add({
      'user_id': userId,
      'nom_depense': nomDepense,
      'nom_categorie': nomCategorie,
      'prix': prix,
      'icon_url': IconUrl,
      'couleur_icon': CouleurIcon,
      'date': date,
    });
    print('Expense added for user: $userId');
  } catch (e) {
    print('Error ajout dépense: $e');
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final String color;
}

// Récupérez les données de dépenses depuis Firestore pour un utilisateur connecté
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
        double prix = doc['prix'] ?? 0.0;
        String CouleurIcon = doc['couleur_icon'];
        chartDataList.add(ChartData(doc['nom_depense'], prix, CouleurIcon));
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return chartDataList;
}

class RechercheDepense {
  final String nom_depense;
  final String nom_categorie;
  final double prix;
  late final String Icon;
  var CouleurIcon;
  final String docId;
  String date;

  RechercheDepense({
    required this.nom_depense,
    required this.nom_categorie,
    required this.prix,
    required this.Icon,
    required this.CouleurIcon,
    required this.docId,
    required this.date,
  });
}

//recuperer les depenses de la base de données
Future<List<RechercheDepense>> listDepense() async {
  List<RechercheDepense> listDepense = [];
  double totalDepense = 0;
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('depense')
          .doc(user.uid)
          .collection('depenses')
          .get();
      querySnapshot.docs.forEach((doc) {
        RechercheDepense depense = RechercheDepense(
          nom_depense: doc['nom_depense'],
          nom_categorie: doc['nom_categorie'],
          prix: doc['prix'],
          Icon: doc['icon_url'],
          CouleurIcon: doc['couleur_icon'],
          docId: doc.id,
          date: doc['date'],
        );
        listDepense.add(depense);
        totalDepense += doc['prix'];
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  print('Total des revenus : $totalDepense');
  return listDepense;
}

// Supprimer une dépense de la base de données
Future<void> supprimerDepense(String docId) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final depenseRef = FirebaseFirestore.instance
        .collection('depense')
        .doc(user?.uid)
        .collection('depenses')
        .doc(docId);

    await depenseRef.delete();
    print('L\'élément a été supprimé avec succès');
  } catch (error) {
    print('Erreur lors de la suppression de l\'élément: $error');
  }
}

// Mettre à jour le prix et le nom d'une dépense dans la base de données
Future<void> updateDepensePrix(double newPrix, String docId,
    String newNomDepense, String NewNomCategorie, String newDate) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final depenseRef = FirebaseFirestore.instance
        .collection('depense')
        .doc(user?.uid)
        .collection('depenses')
        .doc(docId);

    await depenseRef.update({
      'prix': newPrix,
      'nom_depense': newNomDepense,
      'nom_categorie': NewNomCategorie,
      'date': newDate,
    });
    print('Le prix de la dépense a été mis à jour avec succès');
  } catch (error) {
    print('Erreur lors de la mise à jour du prix de la dépense: $error');
  }
}

class RechercheCategorieDepense {
  final String nom_categorie;
  final double prix;
  final String docId;

  RechercheCategorieDepense({
    required this.nom_categorie,
    required this.prix,
    required this.docId,
  });
}

//recuperer les depenses de la base de données
Future<List<RechercheCategorieDepense>> listCategorieDepense() async {
  List<RechercheCategorieDepense> listCategorieDepense = [];
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('depense')
          .doc(user.uid)
          .collection('depenses')
          .get();
      querySnapshot.docs.forEach((doc) {
        RechercheCategorieDepense depense = RechercheCategorieDepense(
          nom_categorie: doc['nom_categorie'],
          prix: doc['prix'],
          docId: doc.id,
        );
        listCategorieDepense.add(depense);
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return listCategorieDepense;
}
