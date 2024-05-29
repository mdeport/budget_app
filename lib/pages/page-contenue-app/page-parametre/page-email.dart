import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateEmailPage extends StatefulWidget {
  final String currentEmail;

  UpdateEmailPage({required this.currentEmail});

  @override
  _UpdateEmailPageState createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updateEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;

        if (user != null) {
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!, password: _passwordController.text);
          await user.reauthenticateWithCredential(credential);

          await user.verifyBeforeUpdateEmail(_newEmailController.text);
          await user.sendEmailVerification();

          // Notify user to check email for verification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Email mis à jour. Veuillez vérifier votre boîte de réception pour confirmer le nouvel email.'),
            ),
          );
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

  @override
  void dispose() {
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                onPressed: _updateEmail,
                child: const Text('Mettre à jour l\'email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
