
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/authscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

const apiKey = 'AIzaSyDuIeQSbOc6Y6QCO2KB0o7JVvClnqqYCho';
const projectId = 'plandcorpapp';

Future<void> main() async {

  await Hive.initFlutter();

  var box = await Hive.openBox('box');
  
  //cloud firestore
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.initialize(projectId);
  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //runs app
  runApp(TitleApp());
}

class TitleApp extends StatelessWidget {
  const TitleApp({super.key});

  @override
  Widget build(BuildContext context) {
    //login screen
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authscreen(),
    );
  }
}

