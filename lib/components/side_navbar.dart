import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideNavBar extends StatefulWidget {

  VoidCallback addTitleVisibility;
  VoidCallback adminVisibility;
  String addTitleText;
  String adminText;
  String titleNumber;

  SideNavBar({
    super.key, 
    required this.addTitleVisibility,
    required this.adminVisibility,
    required this.addTitleText,
    required this.titleNumber,
    required this.adminText,
  });

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {

  @override
  void initState() {
    super.initState();
  }

  void signout() {
    FirebaseAuth.instance.signOut();        // signs user out
  }

  //Side Bar
  @override
  Widget build(BuildContext context) {
    return Drawer( 
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50), 
              
              //Settings Icon
              const Icon(
                Icons.settings,
                size: 100,
              ),
              const SizedBox(height: 25),
              
              //add title button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  icon: const IconTheme(
                    data: IconThemeData(
                      color: Colors.black,
                    ),
                    child: Icon(Icons.add),
                  ),
                  label: Text(
                    widget.addTitleText, 
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 18.0, 
                      fontWeight: FontWeight.bold,
                    )),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                      widget.addTitleVisibility();
                    });
                  },
                ),
              ),
                  
              //Admin Button
              const Divider(color: Colors.black),
              const SizedBox(height: 25),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  icon: const Icon(Icons.security, color: Colors.black),
                  label: Text(
                    widget.adminText, 
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 18.0, 
                      fontWeight: FontWeight.bold,
                    )),
                  onPressed: () {
                   widget.adminVisibility();
                   Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 25),
                  
              // logout button
              const Divider(color: Colors.black),
              const SizedBox(height: 25),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  label: const Text(
                    'Logout', 
                    style: TextStyle(
                      color: Colors.black, 
                      fontSize: 18.0, 
                      fontWeight: FontWeight.bold
                    )),
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure you want to Logout?'),
                        actions: [
                          //cancel button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Cancel'),
                              ), 

                              const SizedBox(width: 5),
                              //confirm logout
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  signout();
                                },
                                child: Text('Logout'),
                              ), 
              
                              
                            ],
                          ),
                        ],
                      );
                    });
                  },
                ),
              ),
            ],
            
          ),
        ),
      ),
    );
  }
}