import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, this.currentIndex = 0});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        // Página Insights (exemplo)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Página Insights em desenvolvimento")),
        );
        break;
      case 2:
        // Página Exercícios (exemplo)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Página Exercícios em desenvolvimento")),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book_rounded),
          label: 'Diário',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insights_rounded),
          label: 'Insights',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement_rounded),
          label: 'Exercícios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
