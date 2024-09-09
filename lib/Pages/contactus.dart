import 'package:flutter/material.dart';
import 'package:thaw/utils/formfield.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ContactUS extends StatefulWidget {
  const ContactUS({super.key});

  @override
  State<ContactUS> createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  // List of images for the slideshow
  final List<String> _imagePaths = [
    'assets/images/GadgetMax.png',
    'assets/images/GadgetMax2.png',
    'assets/images/GadgetMax1.png',
  ];

  // Function to launch phone dialer
  void _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Function to launch email
  void _launchEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $email';
    }
  }

  // Function to launch map
  void _launchMap(String address) async {
    final Uri launchUri = Uri(
      scheme: 'geo',
      query: 'q=$address',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch map for $address';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: formfieldStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: _imagePaths.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.purple : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode ? Colors.pinkAccent : Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ဆက်သွယ်ရန် Hotline',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.black : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _launchPhoneDialer('+959 989662010'),
                    child: Row(
                      children: [
                        Icon(Icons.phone,
                            color: isDarkMode ? Colors.black : Colors.black),
                        const SizedBox(width: 10),
                        Text(
                          '+959 989662010',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _launchEmail('thawzin.2tz3@gmail.com'),
                    child: Row(
                      children: [
                        Icon(Icons.email,
                            color: isDarkMode ? Colors.black : Colors.black),
                        const SizedBox(width: 10),
                        Text(
                          'thawzin.2tz3@gmail.com',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () =>
                        _launchMap('https://maps.app.goo.gl/ZiHb4T38sb4nNKZSA'),
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: isDarkMode ? Colors.black : Colors.purple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'https://maps.app.goo.gl/ZiHb4T38sb4nNKZSA',
                            style: TextStyle(
                              height: 1.5,
                              color: isDarkMode ? Colors.black : Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.yellow,
    );
  }
}
