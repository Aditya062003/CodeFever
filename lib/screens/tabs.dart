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
    Widget activePage = Profile(
        isDarkModeEnabled: widget.isDarkModeEnabled,
        toggleDarkMode: widget.toggleDarkMode);
    // var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activePage = const RankingsScreen();
      // activePageTitle = 'Rankings';
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(activePageTitle),
      // ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar_alt_fill), label: 'Rankings'),
        ],
      ),
    );
  }
}
