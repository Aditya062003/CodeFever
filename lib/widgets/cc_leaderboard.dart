import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/models/cc_leaderboardentry.dart';
import 'package:codefever/screens/others_profile.dart';

class CCLeaderboard extends StatelessWidget {
  const CCLeaderboard({Key? key}) : super(key: key);

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
                      'https://pbs.twimg.com/profile_images/1477930785537605633/ROTVNVz7_400x400.jpg'),
                ),
                SizedBox(width: 8),
                Text(
                  'CodeChef Rankings',
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

              List<CCLeaderboardEntry> leaderboard = snapshot.data!.docs
                  .where((doc) =>
                      doc['ccranking'] !=
                      0) // Filter out docs without 'ccranking' field
                  .map((doc) {
                return CCLeaderboardEntry(
                  userId: doc.id,
                  rank: doc['ccranking'],
                  stars: doc['ccstars'],
                );
              }).toList();

              leaderboard.sort((a, b) => b.rank.compareTo(a.rank));
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
                                    'Rank',
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
                                    'Stars',
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
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 16,
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
                                      '${leaderboard[i].rank}',
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
                                      leaderboard[i].stars,
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
