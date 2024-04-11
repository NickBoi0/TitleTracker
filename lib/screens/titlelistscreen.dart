import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/editAllPage.dart';
import 'package:flutterapp/data/adminData.dart';
import 'package:flutterapp/main.dart';
import 'package:hive/hive.dart';
import '../components/editPage.dart'; 
import 'package:intl/intl.dart';

class titleListScreen extends StatefulWidget {

  String searching = '';

  final List<String> list1;
  final List<String> list2;
  final bool finishedTitles;

  titleListScreen({
    super.key,
    required this.list1,
    required this.list2,
    required this.finishedTitles,
    });

  @override
  State<titleListScreen> createState() => _titleListScreenState();
}

class _titleListScreenState extends State<titleListScreen> {
  
  late Stream<QuerySnapshot> _titleStream;
  final searchTitle = TextEditingController();
  String? ExaminerSearchVal;
  String searchByText = 'Title Number';
  bool isSwitched = false;
  String searchByVar = 'TitleNum';
  bool searchTitleVis = true;
  bool searchExaminerVis = false;
  bool editAllVis = false;
  var formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List _isDeletingList = [];

  final _myBox = Hive.box('box');
  adminDataBase db = adminDataBase();

@override
void initState() {
  //Keeps you admin upon opening app
  if (_myBox.get('ADMIN') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  super.initState();
  //Loads the titles
  setupTitleStream(widget.searching, '', false, false);
}

//Titles with a due date of today's date will have "Due" on their tile
_setupDuedTitles() {
  //Formats today's date to be compared to due date
  formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //Titles with a due date =< today's date will have their 'DuedToday' data changed
  FirebaseFirestore.instance
    .collection('InsertedTitles')
    .where('DueDate', isLessThanOrEqualTo: formattedDate)
    .where('DateIn', isEqualTo: 'TBD')
    .get()
    .then((QuerySnapshot querySnapshot) {
      final batch = FirebaseFirestore.instance.batch();
      querySnapshot.docs.forEach((doc) {
        final docRef = FirebaseFirestore.instance
            .collection('InsertedTitles')
            .doc(doc.id);
        batch.update(docRef, {'DuedToday': 'Due'});
      });

      return batch.commit();
    });
}

//Edits the title info that was inputted when creating the title
void showEditAllPage(var docs, var index) {
  
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
              ),
            ),
            child: editAllPage(
              docs: docs,
              index: index,
              list1: widget.list1,
              list2: widget.list2,
    
            ),
          );
        }
      );
    }
  );
}

//Edits the title info needed to finish it
void showEditPage(var docs, var index) {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
              ),
            ),
            child: editPage(
              docs: docs,
              index: index,
              finishedTitleList: () {
                _finishedTitleList(widget.finishedTitles);
              },
            ),
          );
        },
      );
    },
  );
}


//For loading title list and for searching a title 
setupTitleStream(String searchingTitle, String searchingExaminer, bool search, bool finishedTitles) {

  _selectedIndices.clear();
  _setupDuedTitles();
  _isDeletingList.clear();

  setState(() {

    if (search == true) {

      if (finishedTitles == false) {

      if (searchByVar == 'TitleNum') {

        //For a search, unfinished titles, search by title number
        searchingTitle = searchingTitle.toUpperCase();
        _titleStream = FirebaseFirestore.instance
        .collection('InsertedTitles')
        .where(searchByVar, isEqualTo: searchingTitle)
        .where('DateIn', isEqualTo: 'TBD')
        .snapshots();

      } else if (searchByVar == 'ExaminedBy') {

        //Search by examiner
        _titleStream = FirebaseFirestore.instance
        .collection('InsertedTitles')
        .where(searchByVar, isEqualTo: searchingExaminer)
        .where('DateIn', isEqualTo: 'TBD')
        .snapshots();
      }

    } else {

      if (searchByVar == 'TitleNum') {

        //Search by title number for finished titles
        searchingTitle = searchingTitle.toUpperCase();
        _titleStream = FirebaseFirestore.instance
        .collection('InsertedTitles')
        .where(searchByVar, isEqualTo: searchingTitle)
        .where('DuedToday', isEqualTo: 'Completed')
        .snapshots();

      } else if (searchByVar == 'ExaminedBy') {

        //Search by Examiner
        _titleStream = FirebaseFirestore.instance
        .collection('InsertedTitles')
        .where(searchByVar, isEqualTo: searchingExaminer)
        .where('DuedToday', isEqualTo: 'Completed')
        .snapshots();
      } 
    }

    }  else {
      
      //Loads regular title list if not for a search
      _finishedTitleList(widget.finishedTitles);
    
  }

  });
}

//Loads title list
_finishedTitleList(bool finishedTitleList) {

  _selectedIndices.clear();
  searchTitle.text = '';
  ExaminerSearchVal = widget.list2[0];

  //Unfinished titles
  if (finishedTitleList == true) {
      _titleStream = FirebaseFirestore.instance
          .collection('InsertedTitles')
          .where('DateIn', isNotEqualTo: 'TBD')
          .orderBy('DateIn', descending: true)
          .snapshots();
  } else {
      //Finished titles
      _titleStream = FirebaseFirestore.instance
          .collection('InsertedTitles')
          .where('DateIn', isEqualTo: 'TBD')
          .orderBy('DueDate')
          .snapshots();
  }
}

updateScreen() {
  setState(() {
    
  });
}

  //What title tiles are opened
  Set<int> _selectedIndices = Set<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      floatingActionButton: Visibility(
        visible: _isDeletingList.isNotEmpty,
        child: FloatingActionButton(
          backgroundColor: Colors.red.shade900,
          onPressed: () {
            showDialog(
              context: context, 
              builder: (context) {
              return AlertDialog(
                title: Text('Are you sure you want to delete these titles?'),
                actions: [

                  //cancel delete button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ), 

                  //delete confirm button
                  ElevatedButton(
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () async {

                      _finishedTitleList(widget.finishedTitles);

                      // Delete Firestore data based on _isDeletingList
                      _isDeletingList.forEach((titleNum) {
                        FirebaseFirestore.instance
                            .collection('InsertedTitles')
                            .where('TitleNum', isEqualTo: titleNum)
                            .get()
                            .then((querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.delete();
                          });
                        });
                      });

                      // Clear _isDeletingList after deleting data
                      _isDeletingList.clear();
                      updateScreen();
                      
                      //close the dialog
                      Navigator.of(context).pop();
                    }, 
                  ),
                ],
              );
            });
          },
          child: Icon(Icons.delete),
        ),
      ),
      body: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Visibility(
                    visible: searchTitleVis,

                    //Searcing by title number
                    child: TextField(
                      controller: searchTitle,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        labelText: 'Search Title Number',
                      ),
                    ),
                  ),
                  Visibility(
                    visible: searchExaminerVis,
                    child: Row(
                      children: const [ 

                        //Searching by Examiner
                        Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                        Text(
                        style: TextStyle(
                          color: Color.fromARGB(255, 105, 99, 99),
                          fontSize: 16,
                          ),
                        '    Search Examiner'
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: searchExaminerVis,
                    child: Container(
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
                          value: ExaminerSearchVal,
                          isExpanded: true,
                          iconSize: 36,
                          icon: const Icon(
                            Icons.arrow_drop_down, 
                            color: Colors.black
                            ),
                          items: widget.list2.map(buildExaminers).toList(),
                          onChanged: (value) => setState(() => ExaminerSearchVal = value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  //Switch search result
                  Text(
                    'Search\nResult:',
                  ),
                  Switch(
                    value: isSwitched,
                    activeColor: Colors.blue.shade500,
                    inactiveThumbColor: Colors.blue.shade500,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        searchExaminerVis = !searchExaminerVis;
                        searchTitleVis = !searchTitleVis;
                        searchByVar = value ? 'ExaminedBy': 'TitleNum';
                      });
                    },
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        //Cancel search button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () => setupTitleStream(searchTitle.text, ExaminerSearchVal.toString(), false, false),
                          child: Text('Cancel'),
                        ), 
                        const SizedBox(width: 10),

                        //Search Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () => setupTitleStream(searchTitle.text, ExaminerSearchVal.toString(), true, widget.finishedTitles),
                          child: Text('Search'),
                        ),
                      
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

      const SizedBox(height: 10),

      Container(
        child: Expanded(

          //Lists all titles
          child: StreamBuilder(
            stream: _titleStream,
            builder: (context, snapshot) {
            
              //Checks for errors
              if (snapshot.hasError) {
                return CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
            
              //grabs cloud firestore data
              var docs = snapshot.data!.docs;
            
              //makes list
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndices.contains(index);

                  
                  //on click title expands
                  return ExpansionTile(
                    leading: _isDeletingList.contains(docs[index]['TitleNum']) ? Icon(Icons.delete, color: Colors.red.shade900) : Icon(Icons.insert_drive_file, color: Colors.black),
                    title: SelectableText(
                          
                      //Title Number
                      docs[index]['TitleNum'],
                      showCursor: true,
                      style: TextStyle(
                          
                        //If opened title num will bold
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: _isDeletingList.contains(docs[index]['TitleNum'])? Colors.red.shade900 : Colors.black,
                        fontSize: 23,
                      ),
                    ),
            
                    //examiner
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Examiner: ${docs[index]['ExaminedBy']}',
                          style: TextStyle(
                            color: _isDeletingList.contains(docs[index]['TitleNum']) ? Colors.red.shade900 : Colors.black,
                            fontSize: 17,
                          ),
                        ),

                        Visibility(
                          visible: docs[index]['DuedToday'] == 'Due',
                          child: Text(
                            //Appears if title is dued today
                            '${docs[index]['DuedToday']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ],
                    ),
            
                    //Icons
                      trailing: IconTheme(
                        data: IconThemeData(
                          color: _isDeletingList.contains(docs[index]['TitleNum'])? Colors.red.shade900 : Colors.black,
                        ),
                        child: isSelected ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                      ),
            
                    //Holds what is expanded
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded) {
                        setState(() {
                          _selectedIndices.add(index);
                        });
                      } else {
                        setState(() {
                          _selectedIndices.remove(index);
                        });
                      }
                    },
                    // Maintain the expanded state
                    initiallyExpanded: _selectedIndices.contains(index),
                    
                    //text that appears when opened
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),

                          Column(
                            children: [
                              Text('Search Type: ${docs[index]['SearchType']}', style: const TextStyle(fontSize: 17)),
                              Text('Date Out: ${docs[index]['DateOut']}', style: const TextStyle(fontSize: 17)),
                              Text('Due Date: ${docs[index]['DueDate']}', style: TextStyle(fontSize: 17,)),
                            ],
                          ),
                          //Edit already inputed title info
                          Visibility( 
                            visible: db.adminSignedIn ? true : false,
                            child: IconButton(
                              icon: Icon(
                                Icons.mode,
                                color: Colors.green.shade900,
                              ),
                              onPressed: () {
                                setState(() {
                                  showEditAllPage(docs, index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                     
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),

                          Column(
                            children: [
                              Text('Date In: ${docs[index]['DateIn']}', style: const TextStyle(fontSize: 17)),
                              Text('Additional Charge: ${docs[index]['ExaminerCharge'] ?? 'N/A'}', style: const TextStyle(fontSize: 17)),
                            ],
                          ),
                          Visibility(
                            visible: db.adminSignedIn ? true : false,
                            child: IconButton(
                              icon: const Icon(Icons.mode),
                              color: Colors.blue.shade900,
                              onPressed: () {
                                setState(() {
                                  showEditPage(docs, index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 25),
              
            
                      //If not admin then delete/edit will hide
                      Visibility(
                        visible: db.adminSignedIn ? true : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            //Delete button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Visibility(
                                  visible: widget.finishedTitles,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios_new),
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                          context: context, 
                                          builder: (context) {
                                          return AlertDialog(
                                            title: Text('Are you sure you want to revert this title?'),
                                            actions: [

                                              //cancel delete button
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  foregroundColor: Colors.white,
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                ),
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: Text('Cancel'),
                                              ), 

                                              //delete confirm button
                                              ElevatedButton(
                                                child: Text('Revert'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  foregroundColor: Colors.white,
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                ),
                                                onPressed: () async {

                                                  //Reverts DateIn and ExaminerCharge
                                                  await FirebaseFirestore.instance
                                                    .collection('InsertedTitles')
                                                    .doc(docs[index].id)
                                                    .update({'DateIn': 'TBD'});
                                                  await FirebaseFirestore.instance
                                                    .collection('InsertedTitles')
                                                    .doc(docs[index].id)
                                                    .update({'ExaminerCharge': 'TBD'});
                                                             
                                                  //close the dialog
                                                  Navigator.of(context).pop();
                                                }, 
                                              ),
                                            ],
                                          );
                                        }
                                        );
                                      });
                                    },
                                  ),
                                ),
                                StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return IconButton(
                                      icon: _isDeletingList.contains(docs[index]['TitleNum'])
                                          ? Icon(Icons.delete)
                                          : Icon(Icons.delete_outline),
                                      color: Colors.red.shade900,
                                      onPressed: () {
                                        setState(() {
                                          if (_isDeletingList.contains(docs[index]['TitleNum'])) {
                                          _isDeletingList.remove('${docs[index]['TitleNum']}');
                                          } else {
                                            _isDeletingList.add('${docs[index]['TitleNum']}');
                                          }
                                        });
                                        updateScreen();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

//Creates drop down menu
DropdownMenuItem<String> buildExaminers(String item) {
  return DropdownMenuItem<String>(
    value: item,
    child: Text(
      item,
      style: const TextStyle(fontSize: 15), 
    ),
  );
}
}