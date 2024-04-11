import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'my_calender.dart';

class editPage extends StatefulWidget {
  var docs;
  var index;
  final VoidCallback? finishedTitleList;

  editPage({
    super.key,
    required this.docs,
    required this.index,
    this.finishedTitleList
    });

  @override
  State<editPage> createState() => _editPageState();
}

class _editPageState extends State<editPage> {

  TextEditingController dateInController = TextEditingController();
  TextEditingController additionalChargeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.docs[widget.index]['DateIn'] != 'TBD') {
      dateInController.text = '${widget.docs[widget.index]['DateIn']}';
      additionalChargeController.text = '${widget.docs[widget.index]['ExaminerCharge']}';
    }
  }

  editFinish(bool saving, var docs, var index) async {

    if (widget.finishedTitleList != null) {
      widget.finishedTitleList!();
    }

  if (saving == true) {

    //update the document in cloud firestore
    Map<String, dynamic> updateData = {};

    if (dateInController.text.isNotEmpty) {
      updateData['DateIn'] = dateInController.text;
    }
    if (additionalChargeController.text.isNotEmpty) {
      updateData['ExaminerCharge'] = '\$' + additionalChargeController.text;
    }
      
    if (updateData.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('InsertedTitles')
          .doc(docs[index].id)
          .update(updateData);
      await FirebaseFirestore.instance
          .collection('InsertedTitles')
          .doc(docs[index].id)
          .update({'DuedToday': 'Completed'});
    }

  }

  Navigator.of(context).pop();
  dateInController.text = '';
  additionalChargeController.text = '';
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
        
              //input field for DateIn
              Calender(controller: dateInController, labelText: 'Date In'),
              
              const SizedBox(height: 10),
               
              //input field for ExaminerCharge
              TextFormField(
                controller: additionalChargeController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.money),
                  labelText: 'Additional Charge',
                  labelStyle: TextStyle(color: Colors.black)
                ),
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