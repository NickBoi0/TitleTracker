import 'package:flutter/material.dart';
import 'package:flutterapp/components/my_button.dart';
import 'package:flutterapp/screens/addtitlescreen.dart';
import 'package:flutterapp/screens/titlelistscreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/my_textfield.dart';
import '../components/side_navbar.dart';
import 'package:firedart/firedart.dart';

import '../data/adminData.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {

  //set up firestore
  CollectionReference InsertedTitles = Firestore.instance.collection('InsertedTitles');

  //initilize variables
  final adminPass = TextEditingController();
  final Examiners = ['','Adam K.','Artie D.','Bobby A.','Eleni P.', 'Gerard W.', 'Lisa P.', 'Nick F.', 'Rita R.', 'Tania', 'Tommy O.'];
  String? ExaminerVal;
  final SearchType = ['','Full Search', 'FCLSE', 'CO-OP Search', 'Other'];
  bool titleAddedVis = false;
  Color? adminSignColor = Colors.green[700];
  bool adminSignVis = false;
  String AdminSign = '';
  bool titlesVis = true;
  bool addTitleVis = false;
  bool adminVis = false;
  String adminText = 'Admin Login';
  String addTitleText = 'Add Title';
  String selectedTitleNumber = 'Select Title';
  final adminPassword = 'FinBear1754?';

  //reference hive box
  final _myBox = Hive.box('box');
  adminDataBase db = adminDataBase();

  @override
  void initState(){

    //Keeps user admin if signed it
    if (_myBox.get('ADMIN') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    
    super.initState();
  }

  //Makes add title widget and title list visibile/invis
  void addTitleVisibility(){
    setState(() {
      if (addTitleVis == false) {
        if (adminVis == true) {
          adminVis = !adminVis;
        }
        addTitleVis = true;
        titlesVis = false;
        adminVis = false;
      } else {
        addTitleVis = false;
        titlesVis = true;
        adminVis = false;
      }
    });
  }

  //makes admin login visibile
  void adminVisibility(){
    setState(() {
      if (adminVis == false) {
        if (addTitleVis == true) {
          addTitleVis = !addTitleVis;
        }
        addTitleVis = false;
        titlesVis = false;
        adminVis = true;
      } else {
        addTitleVis = false;
        titlesVis = true;
        adminVis = false;
      }
    });
  }

  //home button
  void changeScreen(){
    setState(() {
      titleAddedVis = false;
      if (addTitleVis == true) {
        addTitleVisibility();
      } else if (adminVis == true) {
        adminVisibility();
      }
    });
  }

  //signs admin in
  void signInAdmin(){
    setState(() {
      if (db.adminSignedIn = false){
        adminSignVis = true;
        AdminSign = 'You Are Already Admin';
        adminSignColor = Colors.green[700];
      } else if (adminPass.text == adminPassword) {
        adminPass.text = '';
        db.adminSignedIn = true;
        adminSignVis = true;
        AdminSign = 'Signed in as Admin';
        adminSignColor = Colors.green[700];
        db.updateDataBase();
      } else {
        adminSignVis = true;
        AdminSign = 'Wrong Admin Password';
        adminSignColor = Colors.red[700];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //create page
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      //creates app bar
      appBar: AppBar(
        title: const Text("Title Config."),
        backgroundColor: Colors.grey.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: changeScreen,
          ),
        ],
      ),

      //side navigation bar
      drawer: SideNavBar(
        addTitleVisibility: addTitleVisibility,
        adminText: adminText,
        addTitleText: addTitleText,
        titleNumber: selectedTitleNumber,
        adminVisibility: adminVisibility,
      ),

        //All Screens
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column( 
              children: [
            
                //add title screen
                Visibility( 
                  visible: addTitleVis,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.black,
                      ), 
                    ),
                    child: Flexible(
                      flex: 1,
                      child: addTitleScreen()
                    ),
                  ),
                ),
            
                //Title List Screen
                Visibility(
                  visible: titlesVis,
                  child: Flexible(
                    flex: 1,
                    child: titleListScreen(list1: SearchType, list2: Examiners, finishedTitles: false)),
                ),
            
                //Admin Login
                Visibility(
                  visible: adminVis,
                  child: Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                                          
                              //title number
                              const SizedBox(height: 25),
                              LSTextField(
                                controller: adminPass,
                                hintText: 'Admin Password',
                                obscureText: true,
                                noButton: false,
                              ),
                              const SizedBox(height: 25),
                              //button
                              LongButton(
                                onTap: signInAdmin, 
                                text: 'Sign in', 
                                height: 25, 
                                length: 25,
                              ),
                                            
                              //Text
                              const SizedBox(height: 25),
                              Visibility(
                                visible: adminSignVis,
                                child: Text(
                                  AdminSign,
                                  style: TextStyle(
                                    color: adminSignColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  //Creates drop down menu
  DropdownMenuItem<String> buildExaminers(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: const TextStyle(fontSize: 15), 
    ),
  );
  
}