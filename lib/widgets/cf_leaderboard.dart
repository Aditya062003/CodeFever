import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/models/cf_leaderboardentry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:codefever/screens/others_profile.dart';

class CFLeaderboard extends StatelessWidget {
  const CFLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> getUserImage(String uid) async {
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userData['image_url'];
    }

    Color getTextColor(String rank) {
      rank = rank.toLowerCase();
      if (rank.contains('legendary grandmaster') ||
          rank.contains('international grandmaster') ||
          rank.contains('grandmaster')) {
        return Colors.red;
      } else if (rank.contains('international master') ||
          rank.contains('master')) {
        return Colors.orange;
      } else if (rank.contains('candidate master')) {
        return Colors.purple;
      } else if (rank.contains('expert')) {
        return Colors.blue;
      } else if (rank.contains('specialist')) {
        return Colors.green;
      } else if (rank.contains('pupil')) {
        return Colors.green[700]!;
      } else if (rank.contains('newbie')) {
        return Colors.grey;
      }
      // Default color (black) if the rank doesn't match any condition
      return Colors.black;
    }

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                      'https://store-images.s-microsoft.com/image/apps.48094.14504742535903781.aedbca21-113a-48f4-b001-4204e73b22fc.503f883f-8339-4dc5-8609-81713a59281f'),
                ),
                SizedBox(width: 8),
                Text(
                  'CodeForces Rankings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('rankings').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<CFLeaderboardEntry> leaderboard = snapshot.data!.docs
                  .where((doc) =>
                      doc['cfranking'] !=
                      0) // Filter out docs without 'ccranking' field
                  .map((doc) {
                return CFLeaderboardEntry(
                  userId: doc.id,
                  rating: doc['cfranking'],
                  rank: doc['cfrank'],
                );
              }).toList();

              leaderboard.sort((a, b) => b.rating.compareTo(a.rating));
              final uid1 = leaderboard[0].userId;
              var uid2 = '';
              var uid3 = '';
              if (leaderboard.length >= 2) {
                uid2 = leaderboard[1].userId;
              }
              if (leaderboard.length >= 3) {
                uid3 = leaderboard[2].userId;
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        leaderboard.length >= 2
                            ? FutureBuilder<String>(
                                future: getUserImage(uid2),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return const Icon(Icons.error);
                                  }
                                  final img = snapshot.data;
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.blueGrey,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundImage: NetworkImage(img!),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox(),
                        FutureBuilder<String>(
                          future: getUserImage(uid1),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            }
                            final img = snapshot.data;
                            return CircleAvatar(
                              radius: 65,
                              backgroundColor: const Color(0xffFDCF09),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(img!),
                              ),
                            );
                          },
                        ),
                        leaderboard.length >= 3
                            ? FutureBuilder<String>(
                                future: getUserImage(uid3),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return const Icon(Icons.error);
                                  }
                                  final img = snapshot.data;
                                  return CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.brown[300],
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundImage: NetworkImage(img!),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(3),
                        },
                        border: TableBorder.symmetric(
                          outside: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        children: [
                          // Table header
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'S.No.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Username',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Rating',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Rank',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Leaderboard entries
                          for (int i = 0; i < leaderboard.length; i++)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${i + 1}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(leaderboard[i].userId)
                                          .snapshots(),
                                      builder: (context, userSnapshot) {
                                        if (!userSnapshot.hasData) {
                                          return const Text('Loading...');
                                        }
                                        final userData = userSnapshot.data!;
                                        final username = userData['username'];
                                        return FirebaseAuth.instance
                                                    .currentUser!.uid ==
                                                leaderboard[i].userId
                                            ? Text(
                                                username,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OtherUserProfileScreen(
                                                              profileUid:
                                                                  leaderboard[i]
                                                                      .userId),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  username,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    decoration: TextDecoration.underline,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${leaderboard[i].rating}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      leaderboard[i].rank,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            getTextColor(leaderboard[i].rank),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
