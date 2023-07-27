import 'package:codefever/widgets/table.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/services/networkhelper.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.isDarkModeEnabled,
      required this.toggleDarkMode});

  final bool isDarkModeEnabled;
  final void Function() toggleDarkMode;

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
  String? ccstars;
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
          ccstars = ccData['stars'];
        },
      );
      await FirebaseFirestore.instance
          .collection('rankings')
          .doc(user.uid)
          .update(
        {
          'ccranking': ccranking,
          'ccstars': ccstars,
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

  void toggleTheme() {
    setState(() {
      widget.toggleDarkMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName ?? 'Profile'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkModeEnabled
                ? Icons.wb_sunny
                : Icons.nightlight_round),
            onPressed: toggleTheme,
          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 24),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userImage != null
                      ? userImage!
                      : 'https://cdn.vectorstock.com/i/preview-1x/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.jpg'),
                ),
                const SizedBox(width: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('0'),
                        Text(
                          'Followers',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    Column(
                      children: [
                        Text('0'),
                        Text(
                          'Following',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.update),
                      label: const Text('Update Profile'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 24),
                  child: Text(
                    'Rating',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16), // Add margin to the table
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TableWidget(
                    isCCLoading: isCCLoading,
                    ccranking: ccranking,
                    ccstars: ccstars,
                    isCFLoading: isCFLoading,
                    cfranking: cfranking,
                    isLCLoading: isLCLoading,
                    lcrankingint: lcrankingint,
                    noCC: noCC,
                    noCF: noCF,
                    noLC: noLC,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 24),
                  child: Text(
                    'Status of Total Submissions',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16), // Add margin to the table
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TableWidget(
                    isCCLoading: isCCLoading,
                    ccranking: ccranking,
                    ccstars: ccstars,
                    isCFLoading: isCFLoading,
                    cfranking: cfranking,
                    isLCLoading: isLCLoading,
                    lcrankingint: lcrankingint,
                    noCC: noCC,
                    noCF: noCF,
                    noLC: noLC,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
