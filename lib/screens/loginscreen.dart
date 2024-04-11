import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/my_button.dart';
import 'package:flutterapp/components/my_textfield.dart';

class loginscreen extends StatefulWidget {
  loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  //textfield controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String error = '';
  bool errorVis = false;

  //Signs user in
  Future<void> signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      //detects if login info matched whats on firebase
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      errorVis = false;
      Navigator.pop(context); 

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); 

      if (e.code == 'user-not-found') {
        // WRONG EMAIL
        setState(() {
          errorVis = true;
          error = 'Wrong email';
        });

      
      } else if (e.code == 'wrong-password') {
        // WRONG PASSWORD
        setState(() {
          errorVis = true;
          error = 'Wrong password';
        });

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                //Lock icon
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 25),

                //Name of app
                const Text(
                  'Title Tracker',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 50),

                //Input username field
                LSTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                  noButton: true,
                ),
                const SizedBox(height: 10),

                //Input password field
                LSTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  noButton: false,
                ),
                const SizedBox(height: 10),

                //Reminder
                const Text(
                  'Forgot info? Contact Nick Falleta',
                ),
                const SizedBox(height: 10),

                //Error text that appears if login info was wrong
                Visibility(
                  visible: errorVis,
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                //Sign in button
                LongButton(
                  onTap: signInUser,
                  text: 'Sign in',
                  height: 25,
                  length: 25,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}