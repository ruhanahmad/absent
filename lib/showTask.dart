import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowTask extends StatefulWidget {
  @override
  _ShowTaskState createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
  String selectedUser = "";
  String idUser = "";
  TextEditingController taskController = TextEditingController();
  String username = PreferencesManager.instance.getUserName();


Future<void> _updateTask(String id,DateTime deadlines) async {
 

    final currentTime = DateTime.now();
    final deadline = deadlines;
 final Duration difference = currentTime.difference(deadline);

    if (difference.isNegative) {
      // Time exceeds the deadline
      final exceededTime = -difference;
      final formattedExceededTime =
          DateFormat.Hms().format(DateTime(0, 1, 1, exceededTime.inHours, exceededTime.inMinutes % 60));
      print('Time Exceeded by $formattedExceededTime');
         await FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .update({
      'status': true,
      'completeTime': currentTime,
      "onTime":"Completed on Time",
    });
      // return formattedExceededTime.toString();
    } else {
          await FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .update({
      'status': true,
      'completeTime': currentTime,
      "onTime":"Completed on Time",
    });
    }
    // Update task status and complete time
 

    // Reload tasks
    // _loadTasks();

    // Calculate and show the time difference
   
  }

    Future<String?> _calculateTimeDifference(DateTime currentTime, DateTime deadline)async {
   
    
  }

  @override
  Widget build(BuildContext context) {
    print(username);
    return Scaffold(
      
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Task Assignment App'),
          actions: [  ElevatedButton(
                  onPressed: ()async{
                      await FirebaseAuth.instance.signOut();
                      Get.to(()=>LoginScreen());
                    PreferencesManager.instance.removeUserName();
                  },
                  child: Text('Sign out'),
                ),],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where("idUser", isEqualTo: username).where("status",isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              // List<String> tasks = snapshot.data!.docs
              //     .map((doc) => doc["task"] as String)
              //     .toList();
              // List<Timestamp> timeS = snapshot.data!.docs
              //     .map((doc) => doc["timestamp"] as Timestamp)
              //     .toList();

              //      List<String> docus = snapshot.data!.docs
              //     .map((doc) => doc.id)
              //     .toList();
final documents = snapshot.data!.docs;
              return Container(
                height: MediaQuery.of(context).size.height -40,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                         var ids = documents[index].id;
                       var cusName = documents[index]['startTime'];
                var task = documents[index]['task'];
                var diets = documents[index]['deadLine']; 
                 var onTime = documents[index]['onTime']; 
                 var totalTime = documents[index]['totalTime']; 
                 var runn = documents[index]['isRunning']; 
                 

                    return 
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text("Task:  " + task,style: TextStyle(fontSize: 25),),
                          Text("Deadline  " + diets + " hour"),
                          SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               ElevatedButton(
                                    onPressed: () => runn == true ? pauseTimer(ids,cusName,totalTime) : startTimer(ids),
                                    child: Text( runn == true ? 'Pause' : 'Start'),
                                  ),
                      
                                  ElevatedButton(
                                    onPressed: () =>
                      completeTask(ids,cusName,totalTime,diets)
                                    ,
                                    child: Text('Complete'),
                                  ),
                              // Container(
                              //   height: 50,
                              //   width: 80,
                              //   color: Colors.amber,
                                
                              //                     child: Center(child: Text("Complete")),
                              // ),
                            ],
                          ),
                        ],),
                      ),
                    );
                    
                    
                    
//                     ListTile(
//                       title: Text(task),
//                       subtitle: Text(diets),
//                       // subtitle: onTime =="onTime"? Text("Done on Time"):Text("Not in Time $cusName"),
//                       trailing: 
//                       GestureDetector(
//                         onTap: () async{
// //  setState(() {

//               //                 FirebaseFirestore.instance
//               // .collection('tasks').doc(ids).update({"status":true,"timestamp":DateTime.now()});
//               // _updateTask(ids,diets);


//  final currentTime = DateTime.now();
//     final deadline = diets.toDate();
    
//  final Duration difference = currentTime.difference(deadline);

//     if (difference.isNegative) {
//       // Time exceeds the deadline
//       final exceededTime = -difference;
//       final formattedExceededTime =
//           DateFormat.Hms().format(DateTime(0, 1, 1, exceededTime.inHours, exceededTime.inMinutes % 60));
//       print('Time Exceeded by $formattedExceededTime');
//          await FirebaseFirestore.instance
//         .collection('tasks')
//         .doc(ids)
//         .update({
//       'status': true,
//       'completeTime': DateTime.now(),
//       "onTime":"noTime",
//       "timestamp":formattedExceededTime.toString()
//     });
//       // return formattedExceededTime.toString();
//     } else {
//           await FirebaseFirestore.instance
//         .collection('tasks')
//         .doc(ids)
//         .update({
//       'status': true,
//       'completeTime': DateTime.now(),
//       "onTime":"onTime",
//       "timestamp":"ASD"
//     });
//     }
//                             // });
//                         },
//                         child: 
//                         Row(
//                           children: [
//                              ElevatedButton(
//               onPressed: () => isRunning ? pauseTimer(ids,cusName,totalTime) : startTimer(ids),
//               child: Text(isRunning ? 'Pause' : 'Start'),
//             ),
//             ElevatedButton(
//               onPressed: (){
// completeTask(ids,cusName,totalTime,diets);
//               },
//               child: Text('Complete'),
//             ),
//                             Container(
//                               height: 50,
//                               width: 80,
//                               color: Colors.amber,
                              
//                                                 child: Center(child: Text("Complete")),
//                             ),
//                           ],
//                         ),
//                       ),
                    
//                       // onTap: () {},
//                     );
                  },
                ),
              );
            }
          },
        ));
  
  }


  bool isRunning = false;


 void startTimer(String ids)async {
  // setState(() {
  //    isRunning = true; 
  // });
   
       await FirebaseFirestore.instance
        .collection('tasks')
        .doc(ids)
        .update({
      'startTime': DateTime.now(),
      "isRunning":true
      
    });
     
    //  currentTask.startTime = DateTime.now();
    
  }

  void pauseTimer(String ids,var ss,int totalTime)async {
    // setState(() {
    //   isRunning = false; 
    // });
     
       await FirebaseFirestore.instance
        .collection('tasks')
        .doc(ids)
        .update({
      'totalTime': totalTime + DateTime.now().difference(ss.toDate()).inMilliseconds,
      "isRunning":false,
      
    });
    //  currentTask.totalTime += DateTime.now().difference(currentTask.startTime).inMilliseconds;
   
  }

  void completeTask(String ids,var ss,int totalTime,String deadlinez) async {
    // setState(() {
    // isRunning = false;     
    // });
 
       await FirebaseFirestore.instance
        .collection('tasks')
        .doc(ids)
        .update({
      'totalTime': totalTime + DateTime.now().difference(ss.toDate()).inMilliseconds,
      "isRunning":false,
      
    });
    int remainingTime = int.parse(deadlinez) - (totalTime / (1000 * 60 * 60)).round();
    print(remainingTime >= 0 ? 'Task completed on time!' : 'Task exceeded the deadline!');

    // Update Firebase with task completion details
    // await _firestore.collection('tasks').add({
    //   'taskName': currentTask.taskName,
    //   'deadlineHours': currentTask.deadlineHours,
    //   'totalTime': currentTask.totalTime,
    //   'completedOnTime': remainingTime >= 0,
    //   'timestamp': FieldValue.serverTimestamp(),
    // });
      await FirebaseFirestore.instance
        .collection('tasks')
        .doc(ids)
        .update({
      "totalTime":totalTime,
      "completeTime": remainingTime >= 0 ? "OnTime":"noTime",
      "status":true,
  
    });

    // Reset the current task for the next one
    // setState(() {
    //   currentTask = Task(taskName: 'Example Task', deadlineHours: 8, startTime: DateTime.now());
    // });
  }
  

}
