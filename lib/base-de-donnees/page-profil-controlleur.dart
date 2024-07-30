import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String telephone;
  final String prenom;
  final String genre;
  final String aniverssaire;
  final String pays;
  final String codePostal;

  UserProfile({
    required this.telephone,
    required this.prenom,
    required this.genre,
    required this.aniverssaire,
    required this.pays,
    required this.codePostal,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      telephone: data['telephone'],
      prenom: data['prenom'],
      genre: data['genre'],
      aniverssaire: data['aniverssaire'],
      pays: data['pays'],
      codePostal: data['codePostal'],
    );
  }
}

class PageProfilController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateProfile({
    required String prenom,
    required String telephone,
    required String genre,
    required String aniverssaire,
    required String pays,
    required String codePostal,
  }) async {
    User? user = _auth.currentUser;
    try {
      final profileRef = _firestore.collection('profiles').doc(user?.uid);

      await profileRef.set({
        'prenom': prenom,
        'telephone': telephone,
        'genre': genre,
        'aniverssaire': aniverssaire,
        'pays': pays,
        'codePostal': codePostal,
      });
      print('Profil mis à jour avec succès');
    } catch (error) {
      print('Erreur lors de la mise à jour du profil: $error');
    }
  }

  Future<UserProfile?> getProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('profiles').doc(user.uid).get();
        if (doc.exists) {
          return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
        }
      } catch (e) {
        print('Erreur lors de la récupération du profil: $e');
      }
    }
    return null;
  }
}
