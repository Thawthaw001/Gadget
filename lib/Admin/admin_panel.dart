// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:thaw/Admin/admin_drawer.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/formfield.dart';
import '../auth/auth_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final Auth auth = Auth();

  void _logout() async {
    await auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gadget Max Admin Dashboard', style: formfieldStyle),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(),
            ),
          ],
          backgroundColor: Colors.white,
        ),
        drawer: const DrawerFb2(),
        body: Container(
          decoration: getDecoration(),
        ));
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    home: const AdminPanel(),
  ));
}
