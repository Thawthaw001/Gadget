// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/formfield.dart';
 
class DrawerFb1 extends StatefulWidget {
  const DrawerFb1({super.key});

  @override
  DrawerFb1State createState() => DrawerFb1State();
}

class DrawerFb1State extends State<DrawerFb1> {
  Map<String, dynamic>? _userData;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();
        if (documentSnapshot.exists) {
          setState(() {
            _userData = documentSnapshot.data();
          });
        } else {
          print('User data not found!');
        }
      } else {
        print('No current user');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            if (_userData != null)
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                accountName: Text(
                  _userData!['name'] ?? 'User Name',
                  style: formfieldStyle,
                ),
                accountEmail: Text(
                  _userData!['email'] ?? 'User.email',
                  style: formfieldStyle,
                ),
              ),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.black),
              title: Text('Search', style: formfieldStyle),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: Text('Settings', style: formfieldStyle),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text('Logout', style: formfieldStyle),
              onTap: () async {
                await Auth().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              const Scaffold(), // Replace with actual settings page
        ));
        break;
    }
  }
}


