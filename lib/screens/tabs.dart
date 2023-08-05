import 'package:codefever/screens/profile.dart';
import 'package:codefever/screens/rankings.dart';
import 'package:codefever/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final userid = FirebaseAuth.instance.currentUser!.uid;


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
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (_selectedPageIndex == 1) {
      return const RankingsScreen();
    }
    if (_selectedPageIndex == 2) {
      return SearchScreen();
    } else {
      return Profile(
        isDarkModeEnabled: widget.isDarkModeEnabled,
        toggleDarkMode: widget.toggleDarkMode,
        profileUid: userid,
      );
    }
  }
}
