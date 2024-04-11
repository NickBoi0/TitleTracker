
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';


class adminDataBase {

  bool adminSignedIn = false;
  
  //reference hive box
  final _myBox = Hive.box('box');
  
  void createInitialData(){
    adminSignedIn = false;
  }

  //load data from database
  void loadData(){
    //adminBox.clear();
    adminSignedIn  = _myBox.get('ADMIN');
  }

  //update database
  void updateDataBase(){
    _myBox.put('ADMIN', adminSignedIn);
  }
}