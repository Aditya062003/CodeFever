import 'package:codefever/screens/profile.dart';
import 'package:codefever/screens/rankings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen(
      {super.key,
      required this.isDarkModeEnabled,
      required this.toggleDarkMode});

  final bool isDarkModeEnabled;
  final void Function() toggleDarkMode;
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedPageIndex != 0) {
          setState(() {
            _selectedPageIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _buildPage(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar_alt_fill),
              label: 'Rankings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (_selectedPageIndex == 1) {
      return const RankingsScreen();
    } else {
      return Profile(
        isDarkModeEnabled: widget.isDarkModeEnabled,
        toggleDarkMode: widget.toggleDarkMode,
      );
    }
  }
}
