import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  @override
  createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _form = GlobalKey<FormState>();

  var _isUpdating = false;
  late TextEditingController _ghController;
  late TextEditingController _ccController;
  late TextEditingController _lcController;
  late TextEditingController _cfController;

  @override
  void initState() {
    super.initState();
    _ghController = TextEditingController();
    _ccController = TextEditingController();
    _lcController = TextEditingController();
    _cfController = TextEditingController();
    _fetchUserData();
  }

  @override
  void dispose() {
    _ghController.dispose();
    _ccController.dispose();
    _lcController.dispose();
    _cfController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

    try {
      final userData = await userDoc.get();
      setState(() {
        _ghController.text =
            userData['ghusername'] ?? ''; // If null, set to empty string
        _ccController.text = userData['ccusername'] ?? '';
        _lcController.text = userData['lcusername'] ?? '';
        _cfController.text = userData['cfusername'] ?? '';
      });
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle the error as per your application's requirements
    }
  }

  void _submit() async {
    _form.currentState!.save();
    try {
      setState(() {
        _isUpdating = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'ccusername': _ccController.text,
        'lcusername': _lcController.text,
        'cfusername': _cfController.text,
        'ghusername': _ghController.text,
      });
      setState(() {
        _isUpdating = false;
      });
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isUpdating = false;
      });
    } catch (error) {
      print('Error updating profile: $error');
      // Handle the error as per your application's requirements
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 20, left: 20, right: 20),
                  width: 200,
                  child: Image.asset('assets/images/codefever.png'),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _ghController,
                            decoration: InputDecoration(
                              labelText: 'Github Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            enableSuggestions: false,
                            onSaved: (value) {
                              // No need to set the value here
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _ccController,
                            decoration: InputDecoration(
                              labelText: 'CodeChef Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            enableSuggestions: false,
                            onSaved: (value) {
                              // No need to set the value here
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _lcController,
                            decoration: InputDecoration(
                              labelText: 'LeetCode Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            enableSuggestions: false,
                            onSaved: (value) {
                              // No need to set the value here
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cfController,
                            decoration: InputDecoration(
                              labelText: 'CodeForces Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            enableSuggestions: false,
                            onSaved: (value) {
                              // No need to set the value here
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                _isUpdating
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.done),
                        label: const Text('Update'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
