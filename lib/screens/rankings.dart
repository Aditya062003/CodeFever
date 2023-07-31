import 'package:codefever/widgets/cc_leaderboard.dart';
import 'package:codefever/widgets/cf_leaderboard.dart';
import 'package:codefever/widgets/github_leaderboard.dart';
import 'package:codefever/widgets/lc_leaderboard.dart';
import 'package:flutter/material.dart';

enum LeaderboardType {
  CodeChef,
  LeetCode,
  Codeforces,
  GitHub,
}

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  State<RankingsScreen> createState() {
    return _RankingsScreenState();
  }
}

class _RankingsScreenState extends State<RankingsScreen> {
  LeaderboardType selectedLeaderboard = LeaderboardType.GitHub;

  Widget _buildLeaderboard() {
    switch (selectedLeaderboard) {
      case LeaderboardType.CodeChef:
        return const CCLeaderboard();
      case LeaderboardType.LeetCode:
        return const LCLeaderboard();
      case LeaderboardType.Codeforces:
        return const CFLeaderboard();
      case LeaderboardType.GitHub:
      default:
        return const GHLeaderboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedLeaderboard = LeaderboardType.CodeChef;
                });
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://pbs.twimg.com/profile_images/1477930785537605633/ROTVNVz7_400x400.jpg'),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedLeaderboard = LeaderboardType.LeetCode;
                });
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/1/19/LeetCode_logo_black.png'),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedLeaderboard = LeaderboardType.Codeforces;
                });
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://store-images.s-microsoft.com/image/apps.48094.14504742535903781.aedbca21-113a-48f4-b001-4204e73b22fc.503f883f-8339-4dc5-8609-81713a59281f'),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedLeaderboard = LeaderboardType.GitHub;
                });
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
              ),
            ),
          ],
        ),
      ),
      body: _buildLeaderboard(),
    );
  }
}
