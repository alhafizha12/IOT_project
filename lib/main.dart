import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_rs.dart';
import 'pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAZFDMoKPlKqLq1PubiXfH2oDU3_t4JF1g",
      authDomain: "belajar-800f9.firebaseapp.com",
      databaseURL:
          "https://belajar-800f9-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "belajar-800f9",
      storageBucket: "belajar-800f9.firebasestorage.app",
      messagingSenderId: "1042950304627",
      appId: "1:1042950304627:web:34cf4ca7ab6028c5f44b06",
      measurementId: "G-G56HLMQZDP",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getLandingPage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginPage();
    }

    // Ambil role dari database
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('users/${user.uid}/role')
        .get();

    final role = snapshot.value?.toString() ?? '';

    if (role == 'rs') {
      return const DashboardPageRS();
    } else if (role == 'lansia') {
      return const DashboardPage(
        userName: "",
        usergoldar: "",
        userberat: "",
        userId: "",
      );
    } else {
      return const LoginPage(); // default kalau role tidak ditemukan
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getLandingPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Login App',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: snapshot.data,
          );
        }
      },
    );
  }
}
