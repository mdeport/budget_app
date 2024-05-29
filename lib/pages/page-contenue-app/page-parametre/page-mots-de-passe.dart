import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;

        if (user != null) {
          // Reauthenticate user
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!, password: _currentPasswordController.text);
          await user.reauthenticateWithCredential(credential);

          // Update password
          await user.updatePassword(_newPasswordController.text);

          // Notify user of success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mot de passe mis à jour avec succès.'),
            ),
          );

          // Clear the fields
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de réinitialisation du mot de passe envoyé.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
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
              TextFormField(
                controller: _newPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Nouveau mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirmer mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePassword,
                child: const Text('Mettre à jour le mot de passe'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _resetPassword,
                child: const Text(
                  'Mot de passe oublié?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
