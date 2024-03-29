import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/models/lc_leaderboardentry.dart';
import 'package:codefever/screens/others_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LCLeaderboard extends StatelessWidget {
  const LCLeaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getUserImage(String uid) async {
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userData['image_url'];
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
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/1/19/LeetCode_logo_black.png'),
                ),
                SizedBox(width: 8),
                Text(
                  'LeetCode Rankings',
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

              List<LCLeaderboardEntry> leaderboard = snapshot.data!.docs
                  .where((doc) => doc['lcranking'] != 0)
                  .map((doc) {
                return LCLeaderboardEntry(
                  userId: doc.id,
                  rating: doc['lcranking'],
                  rank: doc['lcglobalranking'],
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
                            : const SizedBox(),
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
                          3: FlexColumnWidth(2),
                        },
                        border: TableBorder.symmetric(
                          outside: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'S.No.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
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
                                    'Global Rank',
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
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
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
                                      '${leaderboard[i].rank}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
