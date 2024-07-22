import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application_budget_app/base-de-donnees/page-aide-controlleur.dart';

class PageAide extends StatefulWidget {
  const PageAide({super.key});

  @override
  State<PageAide> createState() => _PageAideState();
}

class _PageAideState extends State<PageAide> {
  final _emailController = TextEditingController()
    ..text = FirebaseAuth.instance.currentUser!.email!;
  final _commentaireController = TextEditingController();
  final _nomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide & commentaires'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue dans l\'application de gestion de budget',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Cette application vous permet de gérer vos finances en suivant vos dépenses, vos revenus et en définissant des objectifs financiers.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('💸 Gestion des Dépenses'),
            _buildSectionContent(
              'Vous pouvez ajouter, modifier et supprimer des dépenses. Pour ajouter une dépense, suivez ces étapes :\n'
              '1. Appuyez sur le bouton "Ajouter Dépense".\n'
              '2. Entrez le montant, sélectionnez une catégorie (ex. : alimentation, transport, divertissement), et ajoutez une description.\n'
              '3. Choisissez une date pour la dépense.\n'
              '4. Enregistrez la dépense.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('💰 Gestion des Revenus'),
            _buildSectionContent(
              'Pour suivre vos revenus, vous pouvez ajouter, modifier et supprimer des entrées de revenus. Pour ajouter un revenu :\n'
              '1. Appuyez sur le bouton "Ajouter Revenu".\n'
              '2. Entrez le montant, sélectionnez une catégorie (ex. : salaire, cadeaux, autres), et ajoutez une description.\n'
              '3. Choisissez une date pour le revenu.\n'
              '4. Enregistrez le revenu.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('🎯 Définir des Objectifs'),
            _buildSectionContent(
              'Fixez-vous des objectifs financiers pour économiser ou planifier de grandes dépenses. Pour définir un objectif :\n'
              '1. Accédez à la section "Objectifs".\n'
              '2. Appuyez sur "Ajouter Objectif".\n'
              '3. Entrez le montant que vous souhaitez économiser ou atteindre.\n'
              '4. Donnez un nom à votre objectif et ajoutez une description si nécessaire.\n'
              '5. Définissez une date limite pour atteindre cet objectif.\n'
              '6. Enregistrez l\'objectif.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('📊 Suivi et Analyses'),
            _buildSectionContent(
              'Utilisez les graphiques et rapports pour analyser vos dépenses et revenus. Vous pouvez voir la répartition par catégorie, les tendances mensuelles, et plus encore.',
            ),
            const SizedBox(height: 24.0),
            _buildSectionTitle('💡 Conseils & Astuces'),
            _buildSectionContent(
              '1. Enregistrez vos transactions quotidiennement pour ne rien oublier.\n'
              '2. Utilisez des catégories spécifiques pour avoir une meilleure vue d\'ensemble.\n'
              '3. Consultez régulièrement vos objectifs pour rester motivé.',
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFeedbackForm,
        elevation: 4.0,
        icon: const Icon(Icons.feedback, color: Colors.white),
        label: const Text('Envoyer un commentaire',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }

  void _showFeedbackForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Envoyer un commentaire',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Votre Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Votre Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _commentaireController,
                decoration: const InputDecoration(
                  labelText: 'Vos Commentaires',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final nom = _nomController.text;
                  final mail = _emailController.text;
                  final commentaire = _commentaireController.text;
                  ajoutCommentaire(nom, mail, commentaire);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Merci pour votre commentaire!'),
                    ),
                  );
                  Navigator.pop(context);
                  _nomController.text = '';
                  _emailController.text =
                      FirebaseAuth.instance.currentUser!.email!;
                  _commentaireController.text = '';
                },
                child: const Text('Envoyer'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16),
    );
  }
}
