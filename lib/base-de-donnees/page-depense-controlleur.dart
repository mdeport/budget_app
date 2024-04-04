import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Ajoutez une dépense en Base de données
Future<void> ajoutDepense(String userId, String nomDepense, double prix,
    String IconUrl, String CouleurIcon) async {
  try {
    await FirebaseFirestore.instance
        .collection('depense')
        .doc(userId)
        .collection('depenses')
        .doc(nomDepense)
        .set({
      'user_id': userId,
      'nom_depense': nomDepense,
      'prix': prix,
      'icon_url': IconUrl,
      'couleur_icon': CouleurIcon,
    });
    print('Expense added for user: $userId');
  } catch (e) {
    print('Error ajout dépense: $e');
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

// Récupérez les données de dépenses depuis Firestore pour un utilisateur connecté
Future<List<ChartData>> fetchChartDataFromFirestore() async {
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
        chartDataList.add(ChartData(doc['nom_depense'], prix));
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return chartDataList;
}

class RechercheDepense {
  final String nom_depense;
  final double prix;
  final String? Icon;

  RechercheDepense({
    required this.nom_depense,
    required this.prix,
    this.Icon,
  });
}

//recuperer les depenses de la base de données
Future<List<RechercheDepense>> fetchExpensesFromFirestore() async {
  List<RechercheDepense> listDepense = [];
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
          prix: doc['prix'],
          Icon: doc['icon_url'],
        );
        listDepense.add(depense);
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return listDepense;
}

// Supprimer une dépense de la base de données
Future<void> supprimerDepense(String nomDepense) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final depenseRef = FirebaseFirestore.instance
        .collection('depense')
        .doc(user?.uid)
        .collection('depenses')
        .doc(nomDepense);

    await depenseRef.delete();
    print('L\'élément a été supprimé avec succès');
  } catch (error) {
    print('Erreur lors de la suppression de l\'élément: $error');
  }
}

// Mettre à jour le prix et le nom d'une dépense dans la base de données
Future<void> updateDepensePrix(
    String nomDepense, double newPrix /*, String newNomDepense*/) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    // Référence à l'élément à mettre à jour
    final depenseRef = FirebaseFirestore.instance
        .collection('depense')
        .doc(user?.uid)
        .collection('depenses')
        .doc(nomDepense);

    // Mise à jour du prix de la dépense
    await depenseRef.update({
      'prix': newPrix, /*'nom_depense': newNomDepense*/
    });
    print('Le prix de la dépense a été mis à jour avec succès');
  } catch (error) {
    print('Erreur lors de la mise à jour du prix de la dépense: $error');
    // Gérer l'erreur selon vos besoins
  }
}
