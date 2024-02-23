import 'package:application_budget_app/models/UserModel.dart';
import 'package:application_budget_app/pages/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application_budget_app/animation/temps-affichage-animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-bienvenue-app/page-accueil.dart';

class page_creation_compte extends StatefulWidget {
  const page_creation_compte({super.key});

  @override
  State<page_creation_compte> createState() => _page_creation_compteState();
}

class _page_creation_compteState extends State<page_creation_compte> {
  UserService _userService = UserService();

  final _obsuretext1 = true;
  final _obsuretext2 = true;
  var _email;
  var _password;
  var _passwordconfirmation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

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
                    'Créer un compte',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "Il est recommandé de connecter votre adresse e-mail pour que nous puissions mieux protéger vos informations.",
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
                      onChanged: (value) => setState(() => _password = value),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) =>
                          setState(() => _passwordconfirmation = value),
                      validator: (value) => value != _password
                          ? 'Le mot de passe ne correspondent pas'
                          : null,
                      obscureText: _obsuretext2,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
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
                                _obsuretext2 = !_obsuretext2;
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
                                  (value) => print(value.toJson()),
                                );

                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Page_accueil(),
                              ),
                            );*/
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
      ),
    );
  }
}

/*class page_creation_compte extends StatelessWidget {
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
                    'Créer un compte',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "Il est recommandé de connecter votre adresse e-mail pour que nous puissions mieux protéger vos informations.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            LoginForm()
            const SizedBox(height: 45),
            TempsAnimation(
              delai: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
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
                  print('Création de compte');
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
  var _obsuretext2 = true;
  var _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
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
          const SizedBox(height: 20),
          TextFormField(
            obscureText: _obsuretext2,
            decoration: InputDecoration(
              labelText: 'Confirmer le mot de passe',
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
                      _obsuretext2 = !_obsuretext2;
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
