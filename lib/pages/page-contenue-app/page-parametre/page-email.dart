import 'package:flutter/material.dart';

class UpdateEmailPage extends StatelessWidget {
  final String currentEmail;
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  UpdateEmailPage({required this.currentEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _newEmailController,
                decoration: const InputDecoration(labelText: 'Nouvel Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouvel email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmEmailController,
                decoration: const InputDecoration(labelText: 'Confirmer Email'),
                validator: (value) {
                  if (value != _newEmailController.text) {
                    return 'Les emails ne correspondent pas';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration:
                    const InputDecoration(labelText: 'Mot de passe actuel'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe actuel';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle email update
                  }
                },
                child: const Text('Mettre à jour l\'email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
