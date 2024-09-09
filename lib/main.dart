import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thaw/Admin/Brand/brand_panel.dart';
import 'package:thaw/Pages/basket.dart';
import 'package:thaw/Pages/forgetpassword.dart';
import 'package:thaw/Pages/home_page.dart';
import 'package:thaw/Pages/order_historyscreen.dart';
import 'package:thaw/Widget/model_provider.dart';
import 'package:thaw/auth/auth_Splashscreen.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModelProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blueGrey, brightness: Brightness.light),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600, // Adjust weight for thicker text
            ),
            bodyMedium: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600, // Adjust weight for thicker text
            ),
            // You can adjust other text styles similarly
          ),
        ),
        home: SplashScreen(),
        supportedLocales: const [
          Locale('en', 'US'), // Add other supported locales here
        ],
        routes: {
          "/login": (context) => const Login(),
          "/register": (context) => const Register(),
          "/home": (context) => const HomeScreen(),
          "/brand": (context) => const BrandPage(),
          "/basket": (context) => const BasketPage(),
          "/orderhistory": (context) => const OrderHistoryPage(),
          "/forgotpassword": (context) => ForgotPassword(),
        },
      ),
    );
  }
}
