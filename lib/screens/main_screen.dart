import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/providers/icon_color_provider.dart';
import 'package:luna/screens/diary/diary.dart';
import 'package:luna/screens/analytics/analytics.dart';
import 'package:luna/screens/calendary/calendary.dart';
import 'package:luna/screens/profile/profile.dart';
import 'package:luna/screens/diary/components/buttons/add_diary.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  final GlobalKey<DiaryState> _diaryKey = GlobalKey<DiaryState>(); 
  final GlobalKey<CalendaryState> _calendaryKey = GlobalKey<CalendaryState>();
  late List<_NavbarItem> _navbarItems;

  @override
  void initState() {
    super.initState();
    _navbarItems = [
      _NavbarItem(icon: Icons.menu_book_rounded, screen: Diary(key: _diaryKey)),
      _NavbarItem(icon: Icons.calendar_month_rounded, screen: Calendary(key: _calendaryKey)),
      _NavbarItem(icon: Icons.analytics_rounded, screen: const Analytics()),
      _NavbarItem(icon: Icons.account_circle_rounded, screen: const Profile()),
    ];
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final iconColor = Provider.of<IconColorProvider>(context).iconColor;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _navbarItems.map((item) => item.screen).toList(),
      ),
      floatingActionButton: AddDiary(
        iconColor: iconColor,
        onEntryAdded: () {
          if (_selectedIndex == 0) {
            _diaryKey.currentState?.refreshDiaryList();
          }
          if (_selectedIndex == 1) {
            _calendaryKey.currentState?.refreshCalendar();
          }
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(theme, iconColor),
    );
  }

  Widget _buildBottomNavigationBar(ThemeData theme, Color iconColor) {
    return Container(
      height: 55.0, 
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: theme.brightness == Brightness.dark
          ? NavbarBackground.darkNavBackground
          : NavbarBackground.lightNavBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavBarItem(_navbarItems[0], 0, iconColor),
            _buildNavBarItem(_navbarItems[1], 1, iconColor),
            const SizedBox(width: 65),
            _buildNavBarItem(_navbarItems[2], 2, iconColor),
            _buildNavBarItem(_navbarItems[3], 3, iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(_NavbarItem item, int index, Color iconColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Center(
          child: Icon(
            item.icon,
            size: 25,
            color: _selectedIndex == index ? iconColor : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}

class _NavbarItem {
  final IconData icon;
  final Widget screen;

  const _NavbarItem({required this.icon, required this.screen});
}
