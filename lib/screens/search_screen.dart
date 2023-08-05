import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codefever/screens/others_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  String username;
  String imageUrl;
  String userId;

  UserModel(
      {required this.username, required this.imageUrl, required this.userId});
}

class SearchScreen extends StatefulWidget {
  @override
  createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId,
              isNotEqualTo:
                  _currentUserId) // Filter out the current user's document
          .get();

      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel(
              username: doc['username'].toString(),
              imageUrl: doc['image_url'].toString(),
              userId: doc.id))
          .toList();

      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _filteredUsers = _allUsers
          .where((user) =>
              user.username.toLowerCase().startsWith(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBar(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              leading: const Icon(Icons.search),
              hintText: 'Search Usernames',
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: ElevatedButton(
                      child: const Text('Follow'),
                      onPressed: () {},
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_filteredUsers[index].imageUrl),
                    ),
                    title: Text(_filteredUsers[index].username),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OtherUserProfileScreen(
                              profileUid: _filteredUsers[index].userId),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
