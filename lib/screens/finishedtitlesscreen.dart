import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterapp/screens/titlelistscreen.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class finishedTitlesScreen extends StatefulWidget {
  const finishedTitlesScreen({super.key});

  @override
  State<finishedTitlesScreen> createState() => _finishedTitlesScreenState();
}

class _finishedTitlesScreenState extends State<finishedTitlesScreen> {

  final Examiners = ['','Adam K.','Artie D.','Bobby A.','Eleni P.', 'Gerard W.', 'Lisa P.', 'Nick F.', 'Rita R.', 'Tania', 'Tommy O.'];
  final SearchType = ['','Full Search', 'FCLSE', 'CO-OP Search', 'Other'];

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Finished Titles"),
        backgroundColor: Colors.grey.shade800,
      ),

      body: Center( 
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: titleListScreen(
                list1: SearchType, 
                list2: Examiners,
                finishedTitles: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
