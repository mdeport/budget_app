import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Ajoutez un objectif en Base de données
Future<void> ajoutObjectif(String userId, String nomObjectif, double prix,
    String IconUrl, String CouleurIcon) async {
  try {
    await FirebaseFirestore.instance
        .collection('objectif')
        .doc(userId)
        .collection('objectifs')
        .add({
      'user_id': userId,
      'nom_objectif': nomObjectif,
      'prix': prix,
      'icon_url': IconUrl,
      'couleur_icon': CouleurIcon,
    });
    print('Expense added for user: $userId');
  } catch (e) {
    print('Error ajout objectif: $e');
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final String color;
}

// Récupérez les données d'objectif depuis Firestore pour un utilisateur connecté
Future<List<ChartData>> listObjectifChartDataList() async {
  List<ChartData> chartDataList = [];
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('objectif')
          .doc(user.uid)
          .collection('objectifs')
          .get();
      querySnapshot.docs.forEach((doc) {
        double prix = doc['prix'] ?? 0.0;
        String CouleurIcon = doc['couleur_icon'];
        chartDataList.add(ChartData(doc['nom_objectif'], prix, CouleurIcon));
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  return chartDataList;
}

class RechercheObjectif {
  final String nom_objectif;
  final double prix;
  final String Icon;
  var CouleurIcon;
  final String docId;

  RechercheObjectif({
    required this.nom_objectif,
    required this.prix,
    required this.Icon,
    required this.CouleurIcon,
    required this.docId,
  });
}

//recuperer les objectifs de la base de données
Future<List<RechercheObjectif>> listObjectif() async {
  List<RechercheObjectif> listObjectif = [];
  double totalObjectif = 0;
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('objectif')
          .doc(user.uid)
          .collection('objectifs')
          .get();
      querySnapshot.docs.forEach((doc) {
        RechercheObjectif objectif = RechercheObjectif(
          nom_objectif: doc['nom_objectif'],
          prix: doc['prix'],
          Icon: doc['icon_url'],
          CouleurIcon: doc['couleur_icon'],
          docId: doc.id,
        );
        listObjectif.add(objectif);
        totalObjectif += doc['prix'];
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Firestore: $e');
  }
  print('Total des revenus : $totalObjectif');
  return listObjectif;
}

// Supprimer un objectif de la base de données
Future<void> supprimerObjectif(String docId) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final objectifRef = FirebaseFirestore.instance
        .collection('objectif')
        .doc(user?.uid)
        .collection('objectifs')
        .doc(docId);

    await objectifRef.delete();
    print('L\'élément a été supprimé avec succès');
  } catch (error) {
    print('Erreur lors de la suppression de l\'élément: $error');
  }
}

// Mettre à jour le prix et le nom d'un objectif dans la base de données
Future<void> updateObjectifPrix(
    double newPrix, String docId, String newNomObjectif) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    final objectifRef = FirebaseFirestore.instance
        .collection('objectif')
        .doc(user?.uid)
        .collection('objectifs')
        .doc(docId);

    await objectifRef.update({'prix': newPrix, 'nom_objectif': newNomObjectif});
    print('Le prix de la objectif a été mis à jour avec succès');
  } catch (error) {
    print('Erreur lors de la mise à jour du prix de la objectif: $error');
  }
}
