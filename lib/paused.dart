import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Paused extends StatefulWidget {
  @override
  _PausedState createState() => _PausedState();
}

class _PausedState extends State<Paused> {
  String selectedUser = "";
  String idUser = "";
  TextEditingController taskController = TextEditingController();
  String username = PreferencesManager.instance.getUserName();

  Future<void> _updateTask(String id, DateTime deadlines) async {
    final currentTime = DateTime.now();
    final deadline = deadlines;
    final Duration difference = currentTime.difference(deadline);

    if (difference.isNegative) {
      // Time exceeds the deadline
      final exceededTime = -difference;
      final formattedExceededTime = DateFormat.Hms().format(
          DateTime(0, 1, 1, exceededTime.inHours, exceededTime.inMinutes % 60));
      print('Time Exceeded by $formattedExceededTime');
      await FirebaseFirestore.instance.collection('tasks').doc(id).update({
        'status': true,
        'completeTime': currentTime,
        "onTime": "Completed on Time",
      });
      // return formattedExceededTime.toString();
    } else {
      await FirebaseFirestore.instance.collection('tasks').doc(id).update({
        'status': true,
        'completeTime': currentTime,
        "onTime": "Completed on Time",
      });
    }
    // Update task status and complete time

    // Reload tasks
    // _loadTasks();

    // Calculate and show the time difference
  }

  Future<String?> _calculateTimeDifference(
      DateTime currentTime, DateTime deadline) async {}

  @override
  Widget build(BuildContext context) {
    print(username);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Users'),
          actions: [
            // ElevatedButton(
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //        PreferencesManager.instance.removeUserName();
            //     Get.to(() => LoginScreen());
             
            //   },
            //   child: Text('Sign out'),
            // ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').where("onTime",isEqualTo: "paused") .orderBy("InitialTime", descending: true).snapshots(),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) {
            //   return CircularProgressIndicator();
            // }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final documents = snapshot.data!.docs;
              print(documents.length);
              return Container(
                height: MediaQuery.of(context).size.height - 40,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    var ids = documents[index].id;
                    var cusName = documents[index]['startTime'].toDate();
                    var task = documents[index]['task'];
                    var diets = documents[index]['deadLine'];
                    var onTime = documents[index]['completeTime'];
                    var status = documents[index]['status'];
                    var userName = documents[index]['userName'];
                    var initialTime = documents[index]['InitialTime'];
                   
                      var isRunning = documents[index]['isRunning'];
// Format date to show day (e.g., "Monday")
String formattedDay = DateFormat('EEEE').format(initialTime.toDate());

// Format time to show hours and minutes (e.g., "15:30")
String formattedTime = DateFormat('HH:mm').format(initialTime.toDate());

print('Day: $formattedDay');
print('Time: $formattedTime');
                    return ListTile(
                      
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
                            children: [
                              Text("Task : " ,style: TextStyle(fontWeight: FontWeight.bold), ),
                                Expanded(child: Text( task  )), 
                            ],
                          ),
                       
                           Row(
                             children: [
                               Text( "Assigned to :  ",style: TextStyle(color: Colors.red), ),
                                Text( userName),
                             ],
                           ),
                            
                             Row(
                               children: [
                                 Text( "Date : ",style: TextStyle(fontWeight: FontWeight.bold), ),
                                  Text( formattedDay  + "  "),  
                           Text( formattedTime  + "  "), 
                               ],
                             ),
                            
                        ],
                      ),
                      subtitle: onTime == "OnTime"
                          ? Text(
                              "Done on Time",
                              style: TextStyle(color: Colors.green),
                            )
                          : onTime == "null"
                              ? Text(
                                  "Now in Progress",
                                  style: TextStyle(color: Colors.yellow),
                                )
                              : Text("Not in Time $cusName",
                                  style: TextStyle(
                                    color: Colors.red,
                                  )),
                      trailing: status == true
                          ? Text("Completed")
                          : Text("inProgress"),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
