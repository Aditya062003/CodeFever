import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/widgets/table.dart';
import 'package:codefever/widgets/github_heatmap.dart';
import 'package:codefever/services/networkhelper.dart';
import 'dart:io';

class OtherUserProfileScreen extends StatefulWidget {
  OtherUserProfileScreen({super.key, required this.profileUid});
  final String profileUid;

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  String? username;
  String? ccusername;
  String? cfusername;
  String? lcusername;
  String? ghusername;
  String? image_url;
  int? ccranking;
  int? cfranking;
  int? lcranking;
  int? ghcontributions;
  int? lcglobalranking;
  int? repos;
  String? cfrank;
  String? ccstars;
  Map<DateTime, int> heatmapData = {};

  bool noCC = false;
  bool noCF = false;
  bool noLC = false;
  bool noGH = false;
  bool isCCLoading = false;
  bool isCFLoading = false;
  bool isLCLoading = false;
  bool isGHLoading = false;
  bool invalidGHUsername = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch data on init
    getUserData();
    getTotalContributions();
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileUid)
        .get();
    setState(() {
      username = userData['username'] ?? '';
      ccusername = userData['ccusername'] ?? '';
      cfusername = userData['cfusername'] ?? '';
      lcusername = userData['lcusername'] ?? '';
      ghusername = userData['ghusername'] ?? '';
      image_url = userData['image_url'] ??
          'https://cdn.vectorstock.com/i/preview-1x/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.jpg';
    });

    final userRankings = await FirebaseFirestore.instance
        .collection('rankings')
        .doc(widget.profileUid)
        .get();
    setState(() {
      ccranking = userRankings['ccranking'] ?? 0;
      cfranking = userRankings['cfranking'] ?? 0;
      lcranking = userRankings['lcranking'] ?? 0;
      ghcontributions = userRankings['ghcontributions'] ?? 0;
      lcglobalranking = userRankings['lcglobalranking'] ?? 0;
      repos = userRankings['repos'] ?? 0;
      cfrank = userRankings['cfrank'] ?? '';
      ccstars = userRankings['ccstars'] ?? '';
      isLoading = false;
    });
  }

  Future<void> getTotalContributions() async {
    try {
      setState(() {
        isGHLoading = true;
      });
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.profileUid)
          .get();
      if (userData['ghusername'] == null || userData['ghusername'] == '') {
        setState(() {
          isGHLoading = false;
          noGH = true;
        });
        return;
      }
      DateTime currentDate = DateTime.now();
      DateTime threeMonthsAgo = currentDate.subtract(const Duration(days: 180));
      var url = Uri.parse(
          'https://github-contributions-api.jogruber.de/v4/${userData['ghusername']}?y=2023');
      NetWorkHelper netWorkHelper = NetWorkHelper(url);
      var response = await netWorkHelper.getData();
      if (response == null) {
        setState(() {
          isGHLoading = false;
          invalidGHUsername = true;
        });
        return;
      }
      var contributions = response['contributions'];
      for (var contribution in contributions) {
        var date = DateTime.parse(contribution['date']);
        if (date.isAfter(threeMonthsAgo) && date.isBefore(currentDate)) {
          int count = contribution['count'];
          heatmapData[date] = count;
        }
      }
      setState(() {
        isGHLoading = false;
      });
    } on SocketException catch (e) {
      print('Network Error: ${e.message}');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(username ?? ''),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 24),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(image_url!),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
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
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Follow'),
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
                            padding:
                                EdgeInsets.only(top: 8, bottom: 8, left: 24),
                            child: Text(
                              'Rating',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                              lcrankingint: lcranking,
                              noCC: ccranking == 0 ? true : noCC,
                              noCF: cfranking == 0 ? true : noCF,
                              noLC: lcranking == 0 ? true : noLC,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 8, bottom: 8, left: 24),
                            child: Text(
                              'Github Contributions',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GithubHeatMap(
                            heatmapData: heatmapData,
                            isGHLoading: isGHLoading,
                            totalContributions: ghcontributions!,
                            noGH: noGH,
                            invalidGHUsername: invalidGHUsername,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
