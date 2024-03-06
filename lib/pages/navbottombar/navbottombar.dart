import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
          backgroundColor: Color.fromARGB(255, 33, 148, 241),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Budget',
          backgroundColor: Color.fromARGB(255, 33, 140, 241),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb),
          label: 'Conseils',
          backgroundColor: Color.fromARGB(255, 33, 130, 241),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
          backgroundColor: Color.fromARGB(255, 33, 120, 241),
        ),
      ],
    );
  }
}
