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
      body: CarouselSlider(
          items: [CCLeaderboard(), CCLeaderboard(), CCLeaderboard()].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: i);
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: double.infinity,
            aspectRatio: 1 / 1,
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}
