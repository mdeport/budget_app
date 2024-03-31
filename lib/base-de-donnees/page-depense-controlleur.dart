import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Ajoutez une dépense en Base de données
Future<void> ajoutDepense(
    String userId, String nomDepense, double prix, String IconUrl) async {
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

  RechercheDepense({
    required this.nom_depense,
    required this.prix,
  });
}

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
        RechercheDepense expense = RechercheDepense(
          nom_depense: doc['nom_depense'],
          prix: doc['prix'],
        );
        listDepense.add(expense);
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return listDepense;
}
