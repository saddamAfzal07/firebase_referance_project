import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: "password",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              auth.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
            },
            child: const Text("Signup"),
          ),
        ],
      ),
    );
  }
}
