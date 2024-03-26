import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
