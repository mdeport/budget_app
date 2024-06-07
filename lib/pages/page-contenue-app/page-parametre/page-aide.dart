import 'package:flutter/material.dart';

class PageAide extends StatefulWidget {
  const PageAide({super.key});

  @override
  State<PageAide> createState() => _PageAideState();
}

class _PageAideState extends State<PageAide> {
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
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.feedback),
                label: const Text('Envoyer des commentaires'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
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
