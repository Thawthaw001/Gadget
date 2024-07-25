import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaw/Admin/Brand/brand_panel.dart';
import 'package:thaw/Admin/Category/category_added_screen.dart';
import 'package:thaw/Admin/Widget/menu_item.dart';
import 'package:thaw/Admin/order_display.dart';
import 'package:thaw/Admin/view_categoryscreen.dart';
import 'Brand/Edit & Delete brand , model/edit_delete_brandmodel.dart';

class DrawerFb2 extends StatefulWidget {
  const DrawerFb2({super.key});

  @override
  _DrawerFb2State createState() => _DrawerFb2State();
}

class _DrawerFb2State extends State<DrawerFb2> {
  Map<String, dynamic>? _adminData;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
    _fetchUserRole();
  }

  Future<void> _fetchAdminData() async {
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
            _adminData = documentSnapshot.data();
          });
        } else {
          print('Admin data not found!');
        }
      } else {
        print('No current user');
      }
    } catch (e) {
      print('Error fetching admin data: $e');
    }
  }

  Future<void> _fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole');
    setState(() {
      _userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 152, 205, 205),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  if (_adminData != null) ...[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _adminData!['name'] ?? 'No name',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "English"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _adminData!['email'] ?? 'No email',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: "English"),
                      ),
                    ),
                  ] else ...[
                    const CircularProgressIndicator(),
                  ],
                  const SizedBox(height: 8),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 8),
                  if (_userRole != null && _userRole!.contains('admin'))
                    ...[]
                  else ...[
                    ExpansionTile(
                      title: const Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "English",
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      leading:
                          const Icon(Icons.menu, size: 30, color: Colors.black),
                      children: <Widget>[
                        MenuItem(
                          text: 'Add Category',
                          icon: Icons.category,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddCategoryForm()));
                          },
                        ),
                        MenuItem(
                          text: 'View Category',
                          icon: Icons.view_carousel,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewCategoriesScreen()));
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Brand',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "English",
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.branding_watermark,
                          size: 30, color: Colors.black),
                      children: <Widget>[
                        MenuItem(
                          text: 'Add Brand',
                          icon: Icons.branding_watermark_rounded,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BrandPage()));
                          },
                        ),
                        MenuItem(
                          text: 'View Brand',
                          icon: Icons.view_list,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditDeleteBrandModel()));
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Orders',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "English",
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.receipt,
                          size: 30, color: Colors.black),
                      children: <Widget>[
                        MenuItem(
                          text: 'View Orders',
                          icon: Icons.view_list,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderDisplayScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
