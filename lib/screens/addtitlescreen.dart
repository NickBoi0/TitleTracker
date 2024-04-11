import 'package:firedart/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/my_calender.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/adminData.dart';


class addTitleScreen extends StatefulWidget {
  const addTitleScreen({super.key});

  @override
  State<addTitleScreen> createState() => _addTitleScreenState();
}

class _addTitleScreenState extends State<addTitleScreen> {

  //set up firestore
  CollectionReference InsertedTitles = Firestore.instance.collection('InsertedTitles');

  //initilize variables
  final TitleNumber = TextEditingController();
  final AdditionalCharge = TextEditingController();
  final DateOut = TextEditingController();
  final DueDate = TextEditingController();
  final adminPass = TextEditingController();
  final DateIn = TextEditingController();
  final Examiners = ['','Adam K.','Artie D.','Bobby A.','Eleni P.', 'Gerard W.', 'Lisa P.', 'Nick F.', 'Rita R.', 'Tania', 'Tommy O.'];
  String? ExaminerVal;
  final SearchType = ['','Full Search', 'FCLSE', 'CO-OP Search', 'Other'];
  String? SearchTypeVal;
  Color? titleAddedColor = Colors.green[700];
  bool titleAddedVis = false;
  String titleAdded = '';
  bool buttonVis = false;

  //reference hive box
  final _myBox = Hive.box('box');
  adminDataBase db = adminDataBase();

  @override
  void initState(){

    //Keeps user admin if signed in
    if (_myBox.get('ADMIN') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    
    super.initState();
  }

  //adds the title to list
  submitTitle(){
    if (TitleNumber.text != '' && SearchTypeVal != SearchType[0] && ExaminerVal != Examiners[0] && DateOut.text != '' && DueDate.text != '' && ExaminerVal != null && SearchTypeVal != null) {
      checkTitleExists();
    } else {
      setState(() {
        titleAddedColor = Colors.red[700];
        titleAdded = 'Missing Title Information';
        titleAddedVis = true;
      });
    }
  }

// Check if the title already exists
void checkTitleExists() async {
  final titleNum = TitleNumber.text;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('InsertedTitles')
      .where('TitleNum', isEqualTo: titleNum)
      .get();

  if (querySnapshot.docs.isNotEmpty) {

    //Title already exists
    setState(() {
      titleAddedColor = Colors.blue[700];
      titleAdded = 'Title Number is a Duplicate';
      titleAddedVis = true;
      buttonVis = true;
    });
  } else {
    createNewTitle();
    setState(() {

      //Title added text
      titleAddedColor = Colors.green[700];
      titleAdded = 'Title Successfully Added';
      titleAddedVis = true;
    });
    addTitleClear();
  }
}

  //puts title in cloud
  void createNewTitle(){
    InsertedTitles.add({
      'DateIn': 'TBD',
      'DateOut': DateOut.text, 
      'DueDate': DueDate.text,
      'ExaminedBy': ExaminerVal.toString(),
      'ExaminerCharge': 'TBD',
      'SearchType': SearchTypeVal.toString(),
      'TitleNum': TitleNumber.text,
      'DuedToday': '',
    });
  }

  //clears all the info in add title sections
  addTitleClear(){
    setState(() {
      TitleNumber.text = '';
      AdditionalCharge.text = '';
      DateOut.text = '';
      DueDate.text = '';
      ExaminerVal = Examiners[0];
      SearchTypeVal = SearchType[0];
    });
  }

@override
Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              
              //Button click response
              Visibility(
                visible: titleAddedVis,
                child: Text(
                  titleAdded,
                  style: TextStyle(color: titleAddedColor, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 20)
                  ),
                ),
              
              //title number
              TextFormField( 
                controller: TitleNumber,
                decoration: const InputDecoration(
                  icon: Icon(Icons.label),
                  labelText: 'Title Number',
                  ),
              ),
              
              //Type of search
              const SizedBox(height: 25),
              
              Row(
                children: const [ 
                  Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  Text(
                  style: TextStyle(
                    color: Color.fromARGB(255, 105, 99, 99),
                    fontSize: 16,
                    ),
                  '    Type of Search'
                  ),
                ],
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(112, 153, 144, 144),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 4,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: SearchTypeVal,
                    isExpanded: true,
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down, 
                      color: Colors.black
                      ),
                    items: SearchType.map(buildExaminers).toList(),
                    onChanged: (value) => setState(() => SearchTypeVal = value),
                  ),
                ),
              ),
              
              //Examined By Title
              const SizedBox(height: 25),
              
              Row(
                children: const [ 
                  Icon(
                    Icons.perm_identity,
                    color: Colors.black54,
                  ),
                  Text(
                  style: TextStyle(
                    color: Color.fromARGB(255, 105, 99, 99),
                    fontSize: 16,
                    ),
                  '    Examined By'
                  ),
                ],
              ),
              
              //DropDown 
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(112, 153, 144, 144),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 4,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ExaminerVal,
                    isExpanded: true,
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down, 
                      color: Colors.black
                      ),
                    items: Examiners.map(buildExaminers).toList(),
                    onChanged: (value) => setState(() => ExaminerVal = value),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              const Divider(color: Colors.black, thickness: 1.5, indent: 5, endIndent: 5),
              const SizedBox(height: 10),

              //Date Out
              Calender(controller: DateOut, labelText: 'Date Out'),
              
              //Due Date
              const SizedBox(height: 25),
              Calender(controller: DueDate, labelText: 'Due Date'),
              
              //Submit Button
              const SizedBox(height: 30),

              FractionallySizedBox(
                widthFactor: 0.9, 
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  onPressed: () => submitTitle(),
                  child: SizedBox(
                    width: double.infinity, 
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ],
            ),
        )
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