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

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'name': data['name'] ?? 'Unnamed Category',
        'imageUrl': data['imageUrl'] ?? ''
      };
    }).toList();
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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found'));
              } else {
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal:12),
                          child: CategoryButton(
                            label: category['name'],
                            imageUrl: category['imageUrl'],
                            onPressed: () => _navigateToCategoryPage(
                              category['name']!,
                              category['name'] == 'Mobile'
                                  ? const MobilePage(category: 'Mobile')
                                  : category['name'] == 'PC'
                                      ? const PcPage(category: 'PC')
                                      : category['name'] == 'Accessories'
                                          ? const AccessoriesPage(
                                              category: 'Accessories')
                                          : const Tablet(category: 'Tablet'),
                            ),
                          ),
                        );
                      }),
                );
              }
            },
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
            flex: 3,
            child: RetrieveBrandProducts(
              categoryId: selectedCategoryId,
              brandId: selectedBrandId,
            ),
          ),
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
