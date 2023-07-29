import 'package:codefever/widgets/cc_leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  State<RankingsScreen> createState() {
    return _RankingsScreenState();
  }
}

class _RankingsScreenState extends State<RankingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rankings'),
      ),
      body: CCLeaderboard(),
    );
  }
}
