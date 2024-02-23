import 'package:application_budget_app/pages/page-authentification/page-bienvenue.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAilwGywwv13MP1IviUdFy1JOvb3pxbM_U',
        messagingSenderId: '116906204764',
        projectId: 'budgetapp-4854a',
        appId: '1:116906204764:web:1ebff71da50255b2a19099',
        storageBucket: 'budgetapp-4854a.appspot.com',
        authDomain: "budgetapp-4854a.firebaseapp.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Budget App',
      debugShowCheckedModeBanner: false,
      home: bienvenuePage(),
    );
  }
}
