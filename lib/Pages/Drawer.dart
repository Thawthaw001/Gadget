// ignore_for_file: prefer_const_declarations, use_super_parameters, use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/formfield.dart';

class DrawerFb1 extends StatefulWidget {
  @override
  _DrawerFb1State createState() => _DrawerFb1State();
}

class _DrawerFb1State extends State<DrawerFb1> {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  Map<String, dynamic>? _userData;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = _authService.currentUser;
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
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 20, 247, 247),
        child: ListView(
          children: [
            if (_userData != null)
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 20, 247, 247),
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
              title: const Text(
                'Search',
                style: TextStyle(
                  fontFamily: "English",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontFamily: "English",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: "English",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await _authService.signOut();
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

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = const Color.fromARGB(255, 27, 234, 234);

    return TextField(
      style: TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(
          Icons.search,
          color: color,
          size: 20,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 225, 218, 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}

