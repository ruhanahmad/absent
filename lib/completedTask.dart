import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompletedTasks extends StatefulWidget {
  @override
  _CompletedTasksState createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
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
              .where("idUser", isEqualTo: username).where("status",isEqualTo: true)
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
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                         var ids = documents[index].id;
                       var cusName = documents[index]['startTime'].toDate();
                var task = documents[index]['task'];
                var diets = documents[index]['deadLine']; 
                 var onTime = documents[index]['completeTime']; 
                   
                    return ListTile(
                      title: Text(task),
                      subtitle: onTime == "OnTime" ? Text("Done on time") :onTime == "null" ? Text("InProgress"):Text("Not in Time $cusName"),
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
//                         child: Container(
//                           height: 50,
//                           width: 80,
//                           color: Colors.amber,
                          
//                                             child: Center(child: Text("Complete")),
//                         ),
//                       ),
                    
                      // onTap: () {},
                    );
                  },
                ),
              );
            }
          },
        ));
  }




}






//////////////////////



// class Task {
//   String taskName;
//   int deadlineHours;
//   DateTime startTime;
//   int totalTime;

//   Task({
//     required this.taskName,
//     required this.deadlineHours,
//     required this.startTime,
//     this.totalTime = 0,
//   });
// }



// class TaskScreen extends StatefulWidget {
//   @override
//   _TaskScreenState createState() => _TaskScreenState();
// }

// class _TaskScreenState extends State<TaskScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   late Task currentTask;
//   bool isRunning = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Timer App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Task Name: ${currentTask.taskName}'),
//             Text('Deadline Hours: ${currentTask.deadlineHours}'),
//             Text('Total Time: ${currentTask.totalTime} ms'),
//             ElevatedButton(
//               onPressed: () => isRunning ? pauseTimer() : startTimer(),
//               child: Text(isRunning ? 'Pause' : 'Start'),
//             ),
//             ElevatedButton(
//               onPressed: completeTask,
//               child: Text('Complete'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void startTimer() {
//     setState(() {
//       isRunning = true;
//       currentTask.startTime = DateTime.now();
//     });
//   }

//   void pauseTimer() {
//     setState(() {
//       isRunning = false;
//       currentTask.totalTime += DateTime.now().difference(currentTask.startTime).inMilliseconds;
//     });
//   }

//   void completeTask() async {
//     pauseTimer();
//     int remainingTime = currentTask.deadlineHours - (currentTask.totalTime / (1000 * 60 * 60)).round();
//     print(remainingTime >= 0 ? 'Task completed on time!' : 'Task exceeded the deadline!');

//     // Update Firebase with task completion details
//     await _firestore.collection('tasks').add({
//       'taskName': currentTask.taskName,
//       'deadlineHours': currentTask.deadlineHours,
//       'totalTime': currentTask.totalTime,
//       'completedOnTime': remainingTime >= 0,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     // Reset the current task for the next one
//     setState(() {
//       currentTask = Task(taskName: 'Example Task', deadlineHours: 8, startTime: DateTime.now());
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the current task when the widget is created
//     currentTask = Task(taskName: 'Example Task', deadlineHours: 8, startTime: DateTime.now());
//   }
// }
