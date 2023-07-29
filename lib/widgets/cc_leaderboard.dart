import 'package:codefever/models/cc_leaderboardentry.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CCLeaderboard extends StatelessWidget {
  const CCLeaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'CodeChef Leaderboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('rankings').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Process the snapshot data and create a list of leaderboard entries
                List<CCLeaderboardEntry> leaderboard =
                    snapshot.data!.docs.map((doc) {
                  return CCLeaderboardEntry(
                    userId: doc.id,
                    rank: doc['ccranking'],
                    stars: doc['ccstars'],
                  );
                }).toList();

                // Sort the leaderboard entries based on the rank
                leaderboard.sort((a, b) => a.rank.compareTo(b.rank));

                // Create the leaderboard UI using the sorted leaderboard list
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    
                    columnWidths: {
                      0: FlexColumnWidth(3), // Rank column
                      1: FlexColumnWidth(1), // Username column
                      2: FlexColumnWidth(1), // Stars column
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      // Table header
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Username'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Rank'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Stars'),
                            ),
                          ),
                        ],
                      ),
                      // Leaderboard entries
                      for (final entry in leaderboard)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(entry.userId)
                                      .snapshots(),
                                  builder: (context, userSnapshot) {
                                    if (!userSnapshot.hasData) {
                                      return Text('Loading...');
                                    }
                                    final userData = userSnapshot.data!;
                                    final username = userData['username'];
                                    return Text(username);
                                  },
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${entry.rank}'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${entry.stars}'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
