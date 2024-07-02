// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String profileImageUrl;

  // ignore: use_super_parameters
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(left:5,top:10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 20,
            ),
            const SizedBox(width: 35),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 20, fontFamily: 'English', color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(229, 218, 168, 5), Colors.blueGrey],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
