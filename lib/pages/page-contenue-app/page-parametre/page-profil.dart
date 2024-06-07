import 'package:flutter/material.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-email.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-mots-de-passe.dart';
import 'package:application_budget_app/base-de-donnees/page-profil-controlleur.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageProfil extends StatefulWidget {
  const PageProfil({super.key});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _birthDateController = TextEditingController();
  String _selectedGender = '';
  final PageProfilController _controller = PageProfilController();
  final _emailController = TextEditingController()
    ..text = FirebaseAuth.instance.currentUser!.email!;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    UserProfile? profileData = await _controller.getProfile();
    if (profileData != null) {
      setState(() {
        _firstNameController.text = profileData.prenom;
        _phoneController.text = profileData.telephone;
        _postalCodeController.text = profileData.codePostal;
        _countryController.text = profileData.pays;
        _birthDateController.text = profileData.aniverssaire;
        _selectedGender = profileData.genre;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: const Text('Email'),
                subtitle: Text(_emailController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateEmailPage(
                            currentEmail: _emailController.text),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                title: const Text('Mot de passe'),
                subtitle: const Text('********'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePasswordPage(),
                      ),
                    );
                  },
                ),
              ),
              buildProfileRow(
                'Numéro de téléphone',
                _phoneController,
                10,
                keyboardType: TextInputType.phone,
              ),
              buildProfileRow('Prénom', _firstNameController, 150),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Expanded(child: Text('Genre')),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        items: <String>['', 'Homme', 'Femme', 'Non défini']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner votre genre';
                          }
                          return null;
                        },*/
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Expanded(child: Text('Date de naissance')),
                    Expanded(
                      child: TextFormField(
                        controller: _birthDateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                            hintText: 'Sélectionner une date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _birthDateController.text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                        /*validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre date de naissance';
                          }
                          return null;
                        },*/
                      ),
                    ),
                  ],
                ),
              ),
              buildProfileRow('Pays', _countryController, 150),
              buildProfileRow('Code postal', _postalCodeController, 5,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _controller
                        .updateProfile(
                      prenom: _firstNameController.text,
                      telephone: _phoneController.text,
                      codePostal: _postalCodeController.text,
                      pays: _countryController.text,
                      aniverssaire: _birthDateController.text,
                      genre: _selectedGender,
                    )
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil mis à jour')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: $error')),
                      );
                    });
                  }
                },
                child: const Text('Mettre à jour le profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileRow(
      String label, TextEditingController controller, int maxLength,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Entrez $label'),
              textAlign: TextAlign.right,
              keyboardType: keyboardType,
              maxLength: maxLength,
              /*validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre $label';
                }
                return null;
              },*/
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}
