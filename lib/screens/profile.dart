import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/services/networkhelper.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  int? ccranking;

  @override
  void initState() {
    super.initState();
    getCCStats();
  }

  void getCCStats() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    var url =
        Uri.parse('https://codechef-api.vercel.app/${userData['ccusername']}');
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var ccData = await netWorkHelper.getData();
    setState(
      () {
        ccranking = ccData['currentRating'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
        child: ccranking != null
            ? Text('CodeChef: $ccranking')
            : const CircularProgressIndicator(), // Show a loading indicator while fetching data
      ),
    );
  }
}
