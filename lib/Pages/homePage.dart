// ignore: unused_import
import 'package:carousel_slider/carousel_slider.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/Drawer.dart';
// ignore: depend_on_referenced_packages
// Import carousel_slider package
import 'package:thaw/Pages/accessoriesPage.dart';
import 'package:thaw/Pages/mobilePage.dart';
import 'package:thaw/Pages/pcPage.dart';
import 'package:thaw/Pages/tabletPage.dart';
import 'package:thaw/Widget/categoryButton.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/decoration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = Auth();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
          title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Categories',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'English'),
          ),
        ],
      ))),
      drawer: DrawerFb1(),
      body: Container(
        decoration: getDecoration(),
        child: const Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryButton(
                  label: 'Mobile',
                  icon: Icons.phone_android,
                  page: MobilePage(), // Replace with actual page
                ),
                CategoryButton(
                  label: 'PC',
                  icon: Icons.computer,
                  page: pcPage(), // Replace with actual page
                ),
                CategoryButton(
                  label: 'Accessories',
                  icon: Icons.headset,
                  page: accessoreisPage(), // Replace with actual page
                ),
                CategoryButton(
                  label: 'Tablet',
                  icon: Icons.tablet,
                  page: tabletPage(), // Replace with actual page
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

gotoLogin(BuildContext context) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => const Login()));
