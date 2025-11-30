import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/exercise_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  int _safeIndex(int index, int total) {
    if (index < 0) return 0;
    if (index >= total) return total - 1;
    return index;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ExercisesPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const totalItems = 3;

    return BottomNavigationBar(
      currentIndex: _safeIndex(currentIndex, totalItems),
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.black,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedItemColor: Colors.black38,
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: const IconThemeData(color: Colors.black, size: 28),
      unselectedIconTheme: const IconThemeData(color: Colors.black38, size: 24),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book_rounded),
          label: 'Diário',
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
