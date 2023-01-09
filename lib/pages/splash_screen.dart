import 'package:firebase_referance_project/pages/auth/login_page.dart';
import 'package:firebase_referance_project/pages/firestore/firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_referance_project/pages/realtime_data_firebase.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checLogin();
  }

  checLogin() {
    final user = auth.currentUser;
    if (user != null) {
      print(user);
      print("user not null");

      SchedulerBinding.instance.addPostFrameCallback((_) {
        // add your code here.

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FirestoreHomePaage()));
      });
    } else {
      print("user null");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}
