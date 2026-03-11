import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBottom extends StatelessWidget {
  final Function(int) onTabChange;
  final int currentIndex;

  const NavBottom({
    super.key,
    required this.onTabChange,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 3),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GNav(
        gap: 8,
        activeColor: colorScheme.onPrimary,
        iconSize: 24,
        padding: EdgeInsets.all(12),
        duration: Duration(milliseconds: 300),
        tabBackgroundColor: colorScheme.primary,
        color: colorScheme.onSurface,
        backgroundColor: Colors.transparent,
        selectedIndex: currentIndex,
        onTabChange: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/memes');
              break;
            case 1:
              Navigator.pushNamed(context, '/generate');
              break;
            case 2:
              Navigator.pushNamed(context, '/favourite');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        tabs: const [
          GButton(icon: Icons.search, text: 'Поиск'),
          GButton(icon: Icons.lightbulb_outline, text: 'Генерация'),
          GButton(icon: Icons.favorite_border, text: 'Избранное'),
          GButton(icon: Icons.settings_outlined, text: 'Настройки'),
        ],
      ),
    );
  }
}
