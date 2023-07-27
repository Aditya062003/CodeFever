import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/services/networkhelper.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  dynamic userData;
  String? userName;
  String? userImage;
  int? cfranking;
  int? ccranking;
  int? lcrankingint;

  @override
  void initState() {
    super.initState();
    getUserName();
    getCCStats();
    getCFStats();
    getLCStats();
  }

  Future<dynamic> getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
  }

  void getUserName() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      userName = data['username'];
      userImage = data['image_url'];
    });
  }

  void getCCStats() async {
    userData = await getUserData();
    var url =
        Uri.parse('https://codechef-api.vercel.app/${userData['ccusername']}');
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var ccData = await netWorkHelper.getData();
    setState(
      () {
        ccranking = ccData['currentRating'];
      },
    );
    await FirebaseFirestore.instance
        .collection('rankings')
        .doc(user.uid)
        .update(
      {
        'ccranking': ccranking,
      },
    );
  }

  void getCFStats() async {
    userData = await getUserData();
    var url = Uri.parse(
        'https://codeforces.com/api/user.info?handles=${userData['cfusername']}');
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var cfData = await netWorkHelper.getData();
    setState(
      () {
        cfranking = cfData['result'][0]['rating'];
      },
    );
    await FirebaseFirestore.instance
        .collection('rankings')
        .doc(user.uid)
        .update(
      {
        'cfranking': cfranking,
      },
    );
  }

  void getLCStats() async {
    userData = await getUserData();
    var url = Uri.parse(
        'https://leetcode.com/graphql?query=query{userContestRanking(username:%22${userData['lcusername']}%22){attendedContestsCount%20rating%20globalRanking%20totalParticipants%20topPercentage}%20userContestRankingHistory(username:%22rutor%22){attended%20trendDirection%20problemsSolved%20totalProblems%20finishTimeInSeconds%20rating%20ranking%20contest{title%20startTime}}}');
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var lcData = await netWorkHelper.getData();
    setState(
      () {
        double lcranking = lcData['data']['userContestRanking']['rating'];
        lcrankingint = lcranking.toInt();
      },
    );
    await FirebaseFirestore.instance
        .collection('rankings')
        .doc(user.uid)
        .update(
      {
        'lcranking': lcrankingint,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName ?? 'Profile'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: Center(
        child: (ccranking != null && cfranking != null && lcrankingint != null)
            ? Column(
                children: [
                  SizedBox(height: 24), // Add some padding below AppBar
                  Row(
                    children: [
                      SizedBox(width: 24), // Add some padding before text
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userImage ?? ''),
                      ),
                      SizedBox(width: 40), 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8), 
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text('Followers'),
                                  Text('0'),
                                ],
                              ),
                              SizedBox(
                                  width: 16), 
                              Column(
                                children: [
                                  Text('Followers'),
                                  Text('0'),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 16), // Add some padding below the CircleAvatar
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16), // Add margin to the table
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8), // Add padding to the text inside cell
                                child: Center(child: Text('CodeChef')),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8), // Add padding to the text inside cell
                                child: Center(child: Text('CodeForces')),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8), // Add padding to the text inside cell
                                child: Center(child: Text('LeetCode')),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8), // Add padding to the text inside cell
                                child: Center(child: Text('$ccranking')),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8), // Add padding to the text inside cell
                                child: Center(child: Text('$cfranking')),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    8), // Add padding to the text inside cell
                                child: Center(child: Text('$lcrankingint')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
