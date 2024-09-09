import 'package:flutter/material.dart';
import 'package:thaw/Admin/admin_drawer.dart';
import 'package:thaw/Admin/order_display.dart';
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

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          child: const OrderDisplayScreen(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    home: const AdminPanel(),
  ));
}
