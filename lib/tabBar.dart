
import 'package:atten/completedTask.dart';
import 'package:atten/homeScreen.dart';
import 'package:atten/loginScreen.dart';
import 'package:atten/pioneer.dart';
import 'package:atten/shared.dart';
import 'package:atten/showTask.dart';
import 'package:atten/tabbarsss.dart';
import 'package:atten/task.dart';
import 'package:atten/times.dart';
import 'package:flutter/material.dart';



  
  
class SiteEngineer extends StatefulWidget {  
  SiteEngineer ({Key? key}) : super(key: key);  
  
  @override  
  _SiteEngineerState createState() => _SiteEngineerState();  
}  
  
class _SiteEngineerState extends State<SiteEngineer > {  
String username = PreferencesManager.instance.getUserName();

  int _selectedIndex = 0;  
  List<Widget> _widgetOptionss = <Widget>[  

   ShowTask(),
  //  Timess(),
   CompletedTasks(),
  //  TaskScreen(),
  VideoEditingScreen(),
  //  Timess(),
   // TaskAssignmentScreen(), 

  ];  
   List<Widget> _widgetOptions = <Widget>[  

   ShowTask(),
  //  Timess(),
   CompletedTasks(),
  //  TaskScreen(),
  // VideoEditingScreen(),
  //  Timess(),
   FilesPending(), 

  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      // appBar: AppBar(  
      //   title: const Text('Flutter BottomNavigationBar Example'),  
      //     backgroundColor: Colors.green  
      // ),  
      body: Center(  
        child: username == "yoA9BSG4jtRIH6A6GAgEYoqSvrA3" ? _widgetOptions.elementAt(_selectedIndex)  :  _widgetOptionss.elementAt(_selectedIndex) ,  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.link),  
            label: "Tasks",  
            backgroundColor: Colors.white  ,
           
           

          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.comment),  
         label: "Completed",  
            backgroundColor: Colors.white, 
          ),  

          BottomNavigationBarItem(  
            icon: Icon(Icons.comment),  
         label: "Task",  
            backgroundColor: Colors.white, 
          ),   
         
        ],  
        // type: BottomNavigationBarType.shifting,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.black,  
        unselectedItemColor: Colors.grey,
        
        iconSize: 40,  
        onTap: _onItemTapped,  
        elevation: 5  
      ),  
    );  
  }  
}  



class Task {
  String description;
  DateTime time;

  Task({required this.description, required this.time});
}
