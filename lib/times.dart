 import 'package:atten/authController.dart';
import 'package:atten/main.dart';
import 'package:atten/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';




 class Timess extends StatefulWidget {
  const Timess({super.key});

  @override
  State<Timess> createState() => _TimessState();
}

class _TimessState extends State<Timess> {
 
    String username = PreferencesManager.instance.getUserName();
  
  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    userController.tt = 0;
    return Scaffold(
      body: 
      Container(child: 
      
       Column(
         children: [
           StreamBuilder(stream: 
                FirebaseFirestore.instance.collection("users").doc(username).collection("attendance").snapshots(),
                 builder: (context,snapshot){
                 if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
              final records =    snapshot.data!.docs;
//  int totalSum = 0;
  
           userController.totalSum = 0;
           userController.totalMin = 0;
                  return Column(
                    children: [
                      Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          
                          itemCount: records.length,
                          itemBuilder: (context,i){
                         print(records[i]["total"]);
                              userController.totalSum += records[i]["total"] as int;
                              userController.totalMin += records[i]["minutes"] as int;
                                    //  userController.totalSum;
                                    //  userController.totalMin;
                              userController.update();


// Accumulate the hours difference
      

                           return  
                           Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.symmetric(vertical:20.0),
                                 child: Text("You  have to complete atleast  ${userController.totalSum } hours  ${userController.totalMin } Min ",style: TextStyle(fontSize: 24)),
                               ),


                             ],
                           );
                        
                          
                        }),
                      ),
                      //Text("You  have to complete atleast  ${userController.totalSum } hours ",style: TextStyle(fontSize: 24)),
                    ],
                  );
                 }),


            //       Container(
            //         height: 300,
            //         width: 300,
            //         child: StreamBuilder(stream: 
            //                       FirebaseFirestore.instance.collection("users").doc(username).collection("attendance").snapshots(),
            //                        builder: (context,snapshot){
            //                        if (!snapshot.hasData) {
            //         return CircularProgressIndicator();
            //                       }
            //                     final records =    snapshot.data!.docs;
            //       //  int totalSum = 0;
                    
            //         final projects = snapshot.data.data()!['projects'] as List<dynamic> ?? [];
            // final projectNames = projects.cast<String>().toList();

            //         return
                  
            //          ListView.builder(
            //                     itemCount: attendanceList.length,
            //                     itemBuilder: (context, index) {
            //                       return ListTile(
            //         title: Text(attendanceList[index]),
            //                       );
            //                     },
            //                   ); 
            //         // Column(
            //         //   children: [
                        
            //       //                       Container(
            //       //                         height: 400,
            //       //                         width: MediaQuery.of(context).size.width,
            //       //                         child: 
            //       //                         ListView.builder(
                            
            //       //                           itemCount: records.length,
            //       //                           itemBuilder: (context,i){
            //       //                          print(records[i]["total"]);
                              
                            
                  
                  
            //       // // Accumulate the hours difference
                        
                  
            //       //                            return  
            //       //                            Column(
            //       //                              children: [
            //       //                                Padding(
            //       //                                  padding: const EdgeInsets.symmetric(vertical:20.0),
            //       //                                  child: Text("You  have to complete atleast  ${userController.totalSum } hours  ${userController.totalMin } Min ",style: TextStyle(fontSize: 24)),
            //       //                                ),
                  
                  
            //       //                              ],
            //       //                            );
                          
                            
            //       //                         }),
            //       //                       ),
            //             //Text("You  have to complete atleast  ${userController.totalSum } hours ",style: TextStyle(fontSize: 24)),
            //         //   ],
            //         // );
            //                        }),
            //       ),
         ],
       ),),
    );
  }
}
 
 
 
 
 