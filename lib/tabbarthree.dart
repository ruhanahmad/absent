import 'dart:async';

import 'package:atten/completed.dart';
import 'package:atten/inProgress.dart';
import 'package:atten/paused.dart';
import 'package:atten/showAllUser.dart';
import 'package:atten/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class Filis extends StatefulWidget {
  @override
  State<Filis> createState() => _FilisState();
}

class _FilisState extends State<Filis> {


  
   









List<String>? documents;
  Future<void> fetchData() async {

  //   try {
      
  //     QuerySnapshot querySnapshot =
  //         await FirebaseFirestore.instance.collection('users')
  //       .where('netMetering', isEqualTo: true)
  //       .get();

      
  //     documents = [];
  //     querySnapshot.docs.forEach((doc)async {

  //       final userId = doc.id;
  //      QuerySnapshot querySnapshots =
  // await FirebaseFirestore.instance.collection('users').doc(userId).collection('netMeteringProcedure').get() ;
  //       // final QuerySnapshot result = await FirebaseFirestore.instance
  //       // .collection('users')
  //       // .where('email', isEqualTo:email )
  //       // .get();
  //       querySnapshots.docs.forEach((docs) {

  //    documents!.add(docs.id);
  //  print("asdasd ${documents!.length}");
  //       });
       
  //       // Assuming each document has a field named "title"
   
  //     });

  //     // _documentsStreamController.add(documents!);
  //   } catch (e) {
  //     // Handle any errors that might occur during the fetch process
  //     print("Error fetching data: $e");
  //   }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        
        appBar: AppBar(
        automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
             Tab(text: 'All'),
          //  Tab(text:  'Payments'),
             Tab(text: 'InProgress'),
                Tab(text: 'Completed')   ,
                Tab(text: 'Paused')           
           
              
             
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contents of Tab 1
            // TaskAssignmentScreen(),
            // Contents of Tab 2
          UserTasks(),
            InProgress(),
             Completed(),
             Paused()
            // FilesPFinished(),
            
          ],
        ),
      ),
    );
  }
}
