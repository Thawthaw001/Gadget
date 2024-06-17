// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:thaw/Pages/accessoriesPage.dart';
import 'package:thaw/Pages/mobilePage.dart';
import 'package:thaw/Pages/pcPage.dart';
import 'package:thaw/Pages/tabletPage.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/categoryStyle.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage package
import 'package:thaw/utils/gadgetAppbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  double _scrollControllerOffset = 0.0;
  final auth = AuthService();
  final TextEditingController searchController = TextEditingController();
  List<String> imageUrls = []; // List to hold the URLs of images

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _loadImagesFromFirebase(); // Load images from Firebase when the screen initializes
  }

  _scrollListener() {
    setState(() {
      _scrollControllerOffset = _scrollController.offset;
    });
  }

  Future<void> _loadImagesFromFirebase() async {
    final ListResult result =
        await FirebaseStorage.instance.ref('carousel_images').listAll();
    final List<String> urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()).toList());
    setState(() {
      imageUrls = urls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: getDecoration(),
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Categories',
                          style: categoryStyle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategoryButton(context, 'Mobile',
                            Icons.mobile_friendly, const mobilePage()),
                        _buildCategoryButton(
                            context, 'PC', Icons.desktop_mac, const pcPage()),
                        _buildCategoryButton(context, 'Accessories',
                            Icons.garage, const accessoreisPage()),
                        _buildCategoryButton(context, 'Tablet',
                            Icons.tablet_android, const tabletPage()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    imageUrls.isEmpty
                        ? const CircularProgressIndicator() // Show a loading indicator while images are loading
                        : CarouselSlider(
                            items: imageUrls.map((url) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const pcPage()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: const BoxDecoration(
                                          color: Colors.black),
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 500,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8,
                              aspectRatio: 16 / 9,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              pauseAutoPlayOnTouch: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          PreferredSize(
              // ignore: sort_child_properties_last
              child: FadeAppBar(scrollOffset: _scrollControllerOffset),
              preferredSize: Size(MediaQuery.of(context).size.width, 20.0)),
        ],
      ),
    ));
  }
}

Widget _buildCategoryButton(
    BuildContext context, String label, IconData icon, page) {
  return GestureDetector(
    onTap: () =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    child: Container(
        width: 100,
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 135, 156),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'English'),
              )
            ],
          ),
        )),
  );
}

gotoLogin(BuildContext context) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => const Login()));
