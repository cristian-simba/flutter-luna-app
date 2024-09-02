import 'package:flutter/material.dart';
import 'package:luna/screens/profile/profile.dart';
import 'package:luna/screens/analytics/analytics.dart';
import 'package:luna/screens/calendary/calendary.dart';
import 'package:luna/screens/diary/diary.dart';
import 'package:provider/provider.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/constants/colors.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  static const List<_NavbarItem> _navbarItems = [
    _NavbarItem(icon: Icons.menu_book_rounded, label: 'Diario', screen: Diary()),
    _NavbarItem(icon: Icons.calendar_month_rounded, label: 'Calendario', screen: Calendary()),
    _NavbarItem(icon: Icons.analytics_rounded, label: 'Analíticas', screen: Analytics()),
    _NavbarItem(icon: Icons.account_circle_rounded, label: 'Perfil', screen: Profile()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _navbarItems.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(theme, iconColor),
    );
  }

  Widget _buildBottomNavigationBar(ThemeData theme, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ],
      ),
      child: ClipRRect(
        child: BottomNavigationBar(
          items: _navbarItems.map((item) => _buildBottomNavigationBarItem(item, theme)).toList(),
          currentIndex: _selectedIndex,
          selectedItemColor: iconColor,
          unselectedItemColor: Colors.grey[400],
          onTap: _onItemTapped,
          iconSize: 25.0,
          selectedLabelStyle: const TextStyle(
            fontSize: 14.0, 
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12.0, 
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(_NavbarItem item, ThemeData theme) {
    return BottomNavigationBarItem(
      icon: Icon(item.icon),
      label: item.label,
      backgroundColor: theme.brightness == Brightness.dark
          ? NavbarBackground.darkNavBackground
          : NavbarBackground.lightNavBackground,
    );
  }
}

class _NavbarItem {
  final IconData icon;
  final String label;
  final Widget screen;

  const _NavbarItem({required this.icon, required this.label, required this.screen});
}