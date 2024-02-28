import 'package:application_budget_app/pages/page-authentification/page-bienvenue.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-bienvenue-app/page-accueil.dart';
import 'package:application_budget_app/pages/services/UserService.dart';
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: _userService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const Page_accueil();
            }
            return const bienvenuePage();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
