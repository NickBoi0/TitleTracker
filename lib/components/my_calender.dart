import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calender extends StatefulWidget {
  
  final controller;
  final String labelText;

  const Calender({
    super.key,
    required this.controller,
    required this.labelText,
    });

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {

    //Textfield where date selected is shown
    return TextField(
      showCursor: true,
      readOnly: true,
      controller: widget.controller,
      decoration: InputDecoration(
        icon: const Icon(Icons.calendar_month_outlined),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.black)
      ),

      //Opens calender for date selection
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime(2000), 
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color.fromARGB(255, 0, 40, 73), 
                  onPrimary: Colors.cyanAccent, 
                  onSurface: Color.fromARGB(255, 105, 136, 189), 
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, 
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        //Formats date selected
        if (pickedDate != null) {
          setState(() {
            widget.controller.text = DateFormat('yyy-MM-dd').format(pickedDate);
          });
        }
      }
    );
  }
}