// drawer_fb1.dart

// ignore_for_file: prefer_const_declarations, use_super_parameters, use_build_context_synchronously, use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/formfield.dart';

class DrawerFb1 extends StatelessWidget {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  Future<Map<String, dynamic>?> fetchUserData() async {
    User? currentUser = _authService.currentUser;

    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      } else {
        print('User data not found!');
        return null;
      }
    } else {
      print('No current user');
      return null;
    }
  }

  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: const Color.fromARGB(255, 20, 247, 247),
      child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user data found'));
            } else {
              var userData = snapshot.data!;
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 20, 247, 247)),
                      accountName: Text(userData['name'] ?? 'User Name',
                          style: formfieldStyle),
                      accountEmail: Text(
                        userData['email'] ?? 'User.email',
                        style: formfieldStyle,
                      )),
                  ListTile(
                    leading: const Icon(Icons.search, color: Colors.black),
                    title: const Text(
                      'Search',
                      style: TextStyle(
                          fontFamily: "English",
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      title: const Text('Settings',
                          style: TextStyle(
                              fontFamily: "English",
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      onTap: () {}),
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
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      await _authService.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                  )
                ],
              );
            }
          }),
    ));
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
