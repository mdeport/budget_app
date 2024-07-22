import 'package:cloud_firestore/cloud_firestore.dart';

//ajout d'un commentaire en base de données
Future<void> ajoutCommentaire(
    String nom, String mail, String commentaire) async {
  try {
    await FirebaseFirestore.instance.collection('commentaires').add({
      'nom': nom,
      'mail': mail,
      'commentaire': commentaire,
      'date': DateTime.now(),
    });
    print('Commentaire ajouté pour l\'utilisateur: $mail');
  } catch (e) {
    print('Erreur ajout commentaire: $e');
  }
}
