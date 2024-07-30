import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Ajoutez un revenu en Base de données
Future<void> ajoutRevenu(String userId, String nomRevenu, double prix,
    String IconUrl, String CouleurIcon, String date) async {
  try {
    await FirebaseFirestore.instance
        .collection('revenu')
        .doc(userId)
        .collection('revenus')
        .add({
      'user_id': userId,
      'nom_revenu': nomRevenu,
      'prix': prix,
      'icon_url': IconUrl,
      'couleur_icon': CouleurIcon,
      'date': date,
    });
    print('Expense added for user: $userId');
  } catch (e) {
    print('Error ajout revenu: $e');
  }
}

class ChartDatarevenu {
  ChartDatarevenu(this.x, this.y, this.color);
  final String x;
  final double y;
  final String color;
}

// Récupérez les données de revenu depuis Firestore pour un utilisateur connecté
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
        double prix = doc['prix'] ?? 0.0;
        String CouleurIcon = doc['couleur_icon'];
        chartDataList
            .add(ChartDatarevenu(doc['nom_revenu'], prix, CouleurIcon));
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return chartDataList;
}

class RechercheRevenu {
  final String nom_revenu;
  final double prix;
  final String Icon;
  var CouleurIcon;
  final String docId;
  final String date;

  RechercheRevenu({
    required this.nom_revenu,
    required this.prix,
    required this.Icon,
    required this.CouleurIcon,
    required this.docId,
    required this.date,
  });
}

//recuperer les revenus de la base de données
Future<List<RechercheRevenu>> listRevenu() async {
  List<RechercheRevenu> listRevenu = [];
  double totalRevenu = 0;
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('revenu')
          .doc(user.uid)
          .collection('revenus')
          .get();
      querySnapshot.docs.forEach((doc) {
        RechercheRevenu revenu = RechercheRevenu(
          nom_revenu: doc['nom_revenu'],
          prix: doc['prix'],
          Icon: doc['icon_url'],
          CouleurIcon: doc['couleur_icon'],
          docId: doc.id,
          date: doc['date'],
        );
        listRevenu.add(revenu);
        totalRevenu += doc['prix'];
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  print('Total des revenus : $totalRevenu');
  return listRevenu;
}

// Supprimer un revenu de la base de données
Future<void> supprimerRevenu(String docId) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final revenuRef = FirebaseFirestore.instance
        .collection('revenu')
        .doc(user?.uid)
        .collection('revenus')
        .doc(docId);

    await revenuRef.delete();
    print('L\'élément a été supprimé avec succès');
  } catch (error) {
    print('Erreur lors de la suppression de l\'élément: $error');
  }
}

// Mettre à jour le prix et le nom d'un revenu dans la base de données
Future<void> updateRevenuPrix(
  double newPrix,
  String docId,
  String newNomRevenu,
  String newDate,
  String newCouleur,
  String newIconUrl,
) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final revenuRef = FirebaseFirestore.instance
        .collection('revenu')
        .doc(user?.uid)
        .collection('revenus')
        .doc(docId);

    await revenuRef.update({
      'prix': newPrix,
      'nom_revenu': newNomRevenu,
      'date': newDate,
      'couleur_icon': newCouleur,
      'icon_url': newIconUrl,
    });
    print('Le prix du revenu a été mis à jour avec succès');
  } catch (error) {
    print('Erreur lors de la mise à jour du prix du revenu: $error');
  }
}
