import 'package:flutter/material.dart';

class PageAPropos extends StatefulWidget {
  const PageAPropos({super.key});

  @override
  State<PageAPropos> createState() => _PageAProposState();
}

class _PageAProposState extends State<PageAPropos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'À propos de l\'application',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Notre application de gestion de budget est conçue pour vous aider à suivre vos finances personnelles de manière simple et efficace. Que vous souhaitiez suivre vos dépenses, gérer vos revenus ou fixer des objectifs financiers, notre application est là pour vous aider à atteindre vos objectifs.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Fonctionnalités principales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildFeature(
              icon: Icons.attach_money,
              title: 'Suivi des Dépenses',
              description:
                  'Enregistrez vos dépenses et obtenez une vue d\'ensemble de vos habitudes de consommation.',
            ),
            _buildFeature(
              icon: Icons.account_balance_wallet,
              title: 'Gestion des Revenus',
              description:
                  'Suivez vos sources de revenus et gérez votre budget mensuel.',
            ),
            _buildFeature(
              icon: Icons.flag,
              title: 'Définition des Objectifs',
              description:
                  'Fixez des objectifs financiers et suivez votre progression pour les atteindre.',
            ),
            _buildFeature(
              icon: Icons.insights,
              title: 'Analyses et Rapports',
              description:
                  'Visualisez vos données financières sous forme de graphiques et de rapports détaillés.',
            ),
            const SizedBox(height: 24.0),
            const Text(
              'L\'équipe de développement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Nous sommes une équipe passionnée de développeurs, dédiée à la création d\'outils financiers utiles et faciles à utiliser.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Contactez-nous',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Si vous avez des questions, des commentaires ou des suggestions, n\'hésitez pas à nous contacter :',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            const Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8.0),
                Text(
                  'supportbudgetapp@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(
      {required IconData icon,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 40),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
