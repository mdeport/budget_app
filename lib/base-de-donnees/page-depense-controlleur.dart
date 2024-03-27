// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Ajoutez une dépense en Base de données
Future<void> ajoutDepense(
    String userId, String nomDepense, double prix, String IconUrl) async {
  try {
    await FirebaseFirestore.instance.collection('depense').doc(userId).set({
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
          .where('user_id', isEqualTo: user.uid)
          .get();
      querySnapshot.docs.forEach((doc) {
        double prix = doc['prix'] ?? 0.0;
        chartDataList.add(ChartData(doc.id, prix));
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return chartDataList;
}
