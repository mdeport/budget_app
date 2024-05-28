import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-email.dart';
import 'package:application_budget_app/pages/page-contenue-app/page-parametre/page-mots-de-passe.dart';
import 'package:flutter/material.dart';

class PageProfil extends StatefulWidget {
  const PageProfil({super.key});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _birthDateController = TextEditingController();
  String _selectedGender = '';

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
                subtitle: Text(_emailController.text.isEmpty
                    ? 'user@example.com'
                    : _emailController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateEmailPage(
                            currentEmail: _emailController.text.isEmpty
                                ? 'user@example.com'
                                : _emailController.text),
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
              buildProfileRow('Numéro de téléphone', _phoneController,
                  keyboardType: TextInputType.phone),
              buildProfileRow('Prénom', _firstNameController),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner votre genre';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre date de naissance';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              buildProfileRow('Pays', _countryController),
              buildProfileRow('Code postal', _postalCodeController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle profile update
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

  Widget buildProfileRow(String label, TextEditingController controller,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}