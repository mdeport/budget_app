import 'package:application_budget_app/pages/page-contenue-app/page-bienvenue-app/page-accueil.dart';
import 'package:flutter/material.dart';
import 'package:application_budget_app/animation/temps-affichage-animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_budget_app/models/UserModel.dart';
import 'package:application_budget_app/pages/services/UserService.dart';

class page_connexion_compte extends StatefulWidget {
  const page_connexion_compte({super.key});

  @override
  State<page_connexion_compte> createState() => _page_connexion_compteState();
}

class _page_connexion_compteState extends State<page_connexion_compte> {
  UserService _userService = UserService();

  final _obsuretext1 = true;
  //var _obsuretext2 = true;
  var _email;
  var _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 21, 41, 255),
            Color.fromARGB(234, 91, 230, 255),
            Color.fromARGB(197, 91, 230, 255),
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(0),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 70, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connexion',
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        "Pour accéder à votre compte en toute sécurité, veuillez vous connecter avec votre adresse e-mail.",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) => setState(() => _email = value),
                          validator: (value) => emailRegex.hasMatch(value!)
                              ? null
                              : 'Entrez une adresse e-mail valide',
                          decoration: InputDecoration(
                            labelText: 'Adresse e-mail',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) =>
                              setState(() => _password = value),
                          validator: (value) => value!.length < 8
                              ? 'Le mot de passe doit contenir au moins 8 caractères'
                              : null,
                          obscureText: _obsuretext1,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            /*
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _obsuretext1 = !_obsuretext1;
                              },
                            );
                          },
                        ),*/
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 45),
                        TempsAnimation(
                          delai: 500,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 125,
                                vertical: 13,
                              ),
                            ),
                            child: Text(
                              "CONFIRMER",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _userService
                                    .auth(UserModel(
                                  email: _email,
                                  password: _password,
                                ))
                                    .then(
                                  (value) {
                                    if (value.uid != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Page_accueil(),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}








/*
class page_connexion_compte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connexion',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    "Pour accéder à votre compte en toute sécurité, veuillez vous connecter avec votre adresse e-mail.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            LoginForm(),
            SizedBox(height: 45),
            TempsAnimation(
              delai: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 125,
                    vertical: 13,
                  ),
                ),
                child: Text(
                  "CONNEXION",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _obsuretext1 = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Adresse e-mail',
              labelStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: _obsuretext1,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              labelStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              /*suffixIcon: IconButton(
                icon: const Icon(
                  Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(
                    () {
                      _obsuretext1 = !_obsuretext1;
                    },
                  );
                },
              ),*/
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/