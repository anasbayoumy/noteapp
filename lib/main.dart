import 'package:flutter/material.dart';
import 'package:mynoteapp/app/auth/login.dart';
import 'package:mynoteapp/app/auth/signup.dart';
import 'package:mynoteapp/app/home.dart';
import 'package:mynoteapp/app/notes/add.dart';
import 'package:mynoteapp/app/notes/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          sharedPreferences.getString("id") == null ? "Login" : "Home",
      routes: {
        "Login": (context) => const Login(),
        "Signup": (context) => const Signup(),
        "Home": (context) => const Home(),
        "AddNotes": (context) => const AddNotes(),
        "EditNotes": (context) => const EditNotes(),
      },
    );
  }
}
