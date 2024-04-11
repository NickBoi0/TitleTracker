import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'my_calender.dart';

class editAllPage extends StatefulWidget {
  final List<String> list1;
  final List<String> list2;
  var docs;
  var index;
  
  editAllPage({
    super.key,
    required this.list1,
    required this.list2,
    required this.docs,
    required this.index,
    });

  @override
  State<editAllPage> createState() => _editAllPageState();
}

class _editAllPageState extends State<editAllPage> {

  TextEditingController titleNumController = TextEditingController();
  TextEditingController dateOutController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  String? SearchTypeVal;
  String? ExaminerVal; 
  var formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());


  @override
  void initState() {
    super.initState();
    titleNumController.text = '${widget.docs[widget.index]['TitleNum']}';
    dateOutController.text = '${widget.docs[widget.index]['DateOut']}';
    dueDateController.text = '${widget.docs[widget.index]['DueDate']}';
    SearchTypeVal = '${widget.docs[widget.index]['SearchType']}';
    ExaminerVal = '${widget.docs[widget.index]['ExaminedBy']}';
  }

  editFinish(bool saving, var docs, var index) async {

    if (saving == true) {
      //update the document in cloud firestore
      Map<String, dynamic> updateData = {};
      
      if (titleNumController.text.isNotEmpty) {
        updateData['TitleNum'] = titleNumController.text;
      }
        
      if (SearchTypeVal != widget.list1[0] && SearchTypeVal != null) {
        updateData['SearchType'] = SearchTypeVal;
      }
        
      if (ExaminerVal != widget.list2[0] && ExaminerVal != null) {
        updateData['ExaminedBy'] = ExaminerVal;
      }
        
      if (dateOutController.text.isNotEmpty) {
        updateData['DateOut'] = dateOutController.text;
      }
      if (dueDateController.text.isNotEmpty) {
        updateData['DueDate'] = dueDateController.text;
      }
        
      if (updateData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('InsertedTitles')
            .doc(docs[index].id)
            .update(updateData);
        
        //If due date is changed, the "due" warning will be adjusted
        var newDueDate = dueDateController.text; 
        DateTime dueDate = DateFormat('yyyy-MM-dd').parse(newDueDate);
        if (docs[index]['DateIn'] == 'TBD') {
          if (DateTime.now().isBefore(dueDate)) {
            await FirebaseFirestore.instance
                .collection('InsertedTitles')
                .doc(docs[index].id)
                .update({'DuedToday': ''});
        } else if (DateTime.now().isAfter(dueDate)) {
            await FirebaseFirestore.instance
                .collection('InsertedTitles')
                .doc(docs[index].id)
                .update({'DuedToday': 'Due'});
        } else {
            await FirebaseFirestore.instance
                .collection('InsertedTitles')
                .doc(docs[index].id)
                .update({'DuedToday': 'Due'});
        }

        }
      }

  }

  ExaminerVal = widget.list2[0];
  SearchTypeVal = widget.list1[0];
  Navigator.of(context).pop();
  titleNumController.text = '';
  dateOutController.text = '';
  dueDateController.text = ''; 
}

@override
Widget build(BuildContext context) {
  return AlertDialog(
    title: Text("Editing Title: ${widget.docs[widget.index]['TitleNum']}"),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                              
              //input field for TitleNum
              Column(
                children: [
                  TextFormField(
                    controller: titleNumController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.label),
                      labelText: 'Title Number',
                      labelStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                
                  //input for Type of search
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
                        items: widget.list1.map(buildExaminers).toList(),
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
                        items: widget.list2.map(buildExaminers).toList(),
                        onChanged: (value) => setState(() => ExaminerVal = value),
                      ),
                    ),
                  ),
                                  
                  //input field for DateOut
                  Calender(controller: dateOutController, labelText: 'Date Out'),
                  
                  const SizedBox(height: 10),
                                  
                  //input field for DateDate
                  Calender(controller: dueDateController, labelText: 'Due Date'),
                  
                ],
              ),
            ],
          ),
        ),
      ),
      
      actions: [
        //cancel button
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              
              //cancel button
              
              ElevatedButton(
                child: Text('Cancel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  
                  editFinish(false, widget.docs, widget.index);
                }
              ),

              //save button
              ElevatedButton(
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () async {
                    
                  editFinish(true, widget.docs, widget.index);
                },
              ),
            ],
          ),
        ),
      ],
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