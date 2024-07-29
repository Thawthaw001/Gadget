// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/AccessoriesPage/accessories_page.dart';
import 'package:thaw/Pages/PcPage/pc_page.dart';
import 'package:thaw/Pages/TabletPage/tablet_page.dart';
import 'package:thaw/Pages/basket.dart';
import 'package:thaw/Pages/drawer.dart';
import 'package:thaw/Pages/MobilePage/mobilepage.dart';
import 'package:thaw/Pages/order_historyscreen.dart';
import 'package:thaw/Widget/bottom_navbar.dart';
import 'package:thaw/Widget/brand_data_grid.dart';
import 'package:thaw/Widget/carousel_slider.dart';
import 'package:thaw/Widget/categoryButton.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/formfield.dart';

import '../Widget/ brand_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategoryId = '6ZmnlH6NuZuUktDewEsO';
  String selectedBrandId = 'BenmKTYANhM7fR66rkNj';
  final auth = Auth();
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;

  Future<void> _navigateToCategoryPage(String category, Widget page) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchCarouselDocs() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('carouselcategories').get();
    return snapshot.docs;
  }

  Future<void> _navigateToMobilePage() async {
    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    if (categorySnapshot.docs.isNotEmpty) {
      DocumentSnapshot categoryDoc = categorySnapshot.docs.first;
      String categoryId = categoryDoc.id;

      QuerySnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection('categories/$categoryId/brands')
          .get();
      if (brandSnapshot.docs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobilePage(
              category: 'Mobile',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No brands found for selected category.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No categories found.')),
      );
    }
  }

  Future<void> _navigateToPcPage() async {
    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    if (categorySnapshot.docs.isNotEmpty) {
      DocumentSnapshot categoryDoc = categorySnapshot.docs.first;
      String categoryId = categoryDoc.id;

      QuerySnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection('categories/$categoryId/brands')
          .get();
      if (brandSnapshot.docs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PcPage(
              category: 'PC',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No brands found for selected category.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No categories found.')),
      );
    }
  }

  Future<void> _navigateToTabletPage() async {
    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    if (categorySnapshot.docs.isNotEmpty) {
      DocumentSnapshot categoryDoc = categorySnapshot.docs.first;
      String categoryId = categoryDoc.id;

      QuerySnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection('categories/$categoryId/brands')
          .get();
      if (brandSnapshot.docs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Tablet(
              category: 'Tablet',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No brands found for selected category.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No categories found.')),
      );
    }
  }

  Future<void> _navigateToAccessoriesPage() async {
    QuerySnapshot categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    if (categorySnapshot.docs.isNotEmpty) {
      DocumentSnapshot categoryDoc = categorySnapshot.docs.first;
      String categoryId = categoryDoc.id;

      QuerySnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection('categories/$categoryId/brands')
          .get();
      if (brandSnapshot.docs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccessoriesPage(
              category: 'Accessories',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No brands found for selected category.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No categories found.')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index != 0) {
      switch (index) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BasketPage()),
          ).then((_) {
            setState(() {
              _selectedIndex = 0; // Reset to home screen index
            });
          });
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
          ).then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
         
      }
    }
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: getDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryButton(
                label: 'Mobile',
                icon: Icons.phone_android,
                onPressed: () => _navigateToCategoryPage(
                    'Mobile', const MobilePage(category: 'Mobile')),
              ),
              const SizedBox(width: 5),
              CategoryButton(
                label: 'PC',
                icon: Icons.computer,
                onPressed: () =>
                    _navigateToCategoryPage('PC', const PcPage(category: 'PC')),
              ),
              const SizedBox(width: 5),
              CategoryButton(
                label: 'Accessories',
                icon: Icons.headset,
                onPressed: () => _navigateToCategoryPage('Accessories',
                    const AccessoriesPage(category: 'Accessories')),
              ),
              const SizedBox(width: 5),
              CategoryButton(
                label: 'Tablet',
                icon: Icons.tablet,
                onPressed: () => _navigateToCategoryPage(
                    'Tablet', const Tablet(category: 'Tablet')),
              ),
            ],
          ),
          const SizedBox(height: 5),
          FutureBuilder<List<DocumentSnapshot>>(
            future: _fetchCarouselDocs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No carousel items found'));
              } else {
                return Flexible(
                  flex: 2,
                  child: Carousel(docs: snapshot.data!),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Products', style: formfieldStyle),
            ],
          ),
          const SizedBox(height: 10),
          Flexible(
              flex:3,
              child: RetrieveBrandProducts(
                categoryId: selectedCategoryId,
                brandId: selectedBrandId,
              )),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Brands', style: formfieldStyle),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: BrandDataGridView(categoryId: selectedCategoryId),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: formfieldStyle),
      ),
      drawer: const DrawerFb1(),
      body: _selectedIndex == 0 ? _buildHomeContent() : Container(),
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

gotoLogin(BuildContext context) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => const Login()));
