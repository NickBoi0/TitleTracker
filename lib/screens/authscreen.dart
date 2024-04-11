import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/screens/allscreen.dart';
import 'package:flutterapp/screens/loginscreen.dart';

class authscreen extends StatelessWidget {
  const authscreen({
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            
            return allscreen();
          }
          // user not logged in
          else {
            return loginscreen();
            
          }
        },
      ),
    ); 
  }
}