import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/services/networkhelper.dart';
import 'dart:io';
import 'package:percent_indicator/percent_indicator.dart';

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
  bool noCC = false;
  bool noCF = false;
  bool noLC = false;
  bool isCCLoading = false;
  bool isCFLoading = false;
  bool isLCLoading = false;

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

  Future<void> getCCStats() async {
    try {
      setState(() {
        isCCLoading = true;
      });
      userData = await getUserData();
      if (userData['ccusername'] == null || userData['ccusername'] == '') {
        noCC = true;
        setState(() {
          isCCLoading = false;
        });
        return;
      }
      var url = Uri.parse(
          'https://codechef-api.vercel.app/${userData['ccusername']}');
      NetWorkHelper netWorkHelper = NetWorkHelper(url);
      var ccData = await netWorkHelper.getData();
      if (ccData['success'] == false) {
        print('CC Error:  Invalid UserName');
        setState(() {
          isCCLoading = false;
        });
        return;
      }

      setState(
        () {
          isCCLoading = false;
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
    } on SocketException catch (e) {
      // Handle network-related errors (e.g., no internet connection)
      print('Network Error: ${e.message}');
      // Perform appropriate error handling, such as showing an error message to the user or logging the error.
    } catch (e) {
      // Catch any other unexpected errors
      print('Error: ${e.toString()}');
      // Perform appropriate error handling, such as showing an error message to the user or logging the error.
    }
  }

  Future<void> getCFStats() async {
    try {
      setState(() {
        isCFLoading = true;
      });
      userData = await getUserData();
      if (userData['cfusername'] == null || userData['cfusername'] == '') {
        noCF = true;
        setState(() {
          isCFLoading = false;
        });
        return;
      }
      var url = Uri.parse(
          'https://codeforces.com/api/user.info?handles=${userData['cfusername']}');
      NetWorkHelper netWorkHelper = NetWorkHelper(url);
      var cfData = await netWorkHelper.getData();

      if (cfData['status'] != 'OK') {
        print('CF Error: ${cfData['comment']}');
        setState(() {
          isCFLoading = false;
        });
        return;
      }

      setState(
        () {
          isCFLoading = false;
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
    } on SocketException catch (e) {
      // Handle network-related errors (e.g., no internet connection)
      print('Network Error: ${e.message}');
      // Perform appropriate error handling, such as showing an error message to the user or logging the error.
    } catch (e) {
      // Catch any other unexpected errors
      print('Error: ${e.toString()}');
      // Perform appropriate error handling, such as showing an error message to the user or logging the error.
    }
  }

  Future<void> getLCStats() async {
    try {
      setState(() {
        isLCLoading = true;
      });
      userData = await getUserData();
      if (userData['lcusername'] == null || userData['lcusername'] == '') {
        noLC = true;
        setState(() {
          isLCLoading = false;
        });
        return;
      }
      var url = Uri.parse(
          'https://leetcode.com/graphql?query=query{userContestRanking(username:%22${userData['lcusername']}%22){attendedContestsCount%20rating%20globalRanking%20totalParticipants%20topPercentage}%20userContestRankingHistory(username:%22rutor%22){attended%20trendDirection%20problemsSolved%20totalProblems%20finishTimeInSeconds%20rating%20ranking%20contest{title%20startTime}}}');
      NetWorkHelper netWorkHelper = NetWorkHelper(url);
      var lcData = await netWorkHelper.getData();

      if (lcData.containsKey('errors')) {
        setState(() {
          isLCLoading = false;
        });
        // Handle GraphQL errors
        String errorMessage = lcData['errors'][0]['message'];
        print('GraphQL Error: $errorMessage');
        // Perform appropriate error handling, such as showing an error message to the user or logging the error.
        return;
      }

      double lcranking = lcData['data']['userContestRanking']['rating'];
      setState(() {
        isLCLoading = false;
        lcrankingint = lcranking.toInt();
      });

      await FirebaseFirestore.instance
          .collection('rankings')
          .doc(user.uid)
          .update(
        {
          'lcranking': lcrankingint,
        },
      );
    } on SocketException catch (e) {
      // Handle network-related errors (e.g., no internet connection)
      print('Network Error: ${e.message}');
      // Perform appropriate error handling, such as showing an error message to the user or logging the error.
    } catch (e) {
      // Catch any other unexpected errors
      print('Error: ${e.toString()}');
      // Perform appropriate error handling, such as showing an error message to the user or logging the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName ?? 'Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 24),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userImage != null
                    ? userImage!
                    : 'https://cdn.vectorstock.com/i/preview-1x/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.jpg'),
              ),
              const SizedBox(width: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName ?? '',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Column(
                        children: [
                          Text('0'),
                          Text(
                            'Followers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          Text('0'),
                          Text(
                            'Following',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.update),
                label: const Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 16), // Add margin to the table
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: const [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                            child: Text(
                          'CodeChef',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                            child: Text(
                          'CodeForces',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                            child: Text(
                          'LeetCode',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: isCCLoading
                            ? CircularPercentIndicator(
                                radius: 8.0,
                                lineWidth: 2.0,
                                percent: 1.0,
                                progressColor: Colors.blue,
                              )
                            : Center(
                                child: ccranking != null
                                    ? Text('$ccranking')
                                    : noCC
                                        ? const Text('-')
                                        : const Text('Invalid User')),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: isCFLoading
                            ? CircularPercentIndicator(
                                radius: 8.0,
                                lineWidth: 2.0,
                                percent: 1.0,
                                progressColor: Colors.blue,
                              )
                            : Center(
                                child: cfranking != null
                                    ? Text('$cfranking')
                                    : noCF
                                        ? const Text('-')
                                        : const Text('Invalid User')),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: isLCLoading
                            ? CircularPercentIndicator(
                                radius: 8.0,
                                lineWidth: 2.0,
                                percent: 1.0,
                                progressColor: Colors.blue,
                              )
                            : Center(
                                child: lcrankingint != null
                                    ? Text('$lcrankingint')
                                    : noLC
                                        ? const Text('-')
                                        : const Text('Invalid User'),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
