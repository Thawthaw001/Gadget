import 'package:flutter/material.dart';
import 'package:thaw/Pages/accessoriesPage.dart';
import 'package:thaw/Pages/pcPage.dart';
import 'package:thaw/Pages/tabletPage.dart';
import 'package:thaw/Widget/categoryButton.dart';
import 'package:thaw/categories/searchGadget.dart';
 
class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mobile Page',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'English'),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const searchGadget()));
              },
              icon: const Icon(Icons.search))
        ],
      ))),
      body: const Row(
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: [
       CategoryButton(
                label: 'Mobile',
                icon: Icons.phone_android,
                page:MobilePage() , // Replace with actual page
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
      ],),
    );
  }
}
