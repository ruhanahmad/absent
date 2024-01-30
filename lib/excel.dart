import 'dart:typed_data';

import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';


class ExcelSheet extends StatefulWidget {
  @override
  _ExcelSheetState createState() => _ExcelSheetState();
}

class _ExcelSheetState extends State<ExcelSheet> {
  String selectedUser = "";
  String idUser = "";
  TextEditingController taskController = TextEditingController();
  Uint8List? _imageFile;
  String username = PreferencesManager.instance.getUserName();
  ScreenshotController screenshotController = ScreenshotController();
Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }
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
DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    print(username);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Task Assignment App'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.to(() => LoginScreen());
                PreferencesManager.instance.removeUserName();
              },
              child: Text('Sign out'),
            ),
          ],
        ),
        body: Column(
          children: [
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where("idUser", isEqualTo: "QRAE7ukIdpMZGaIHFKd4pTD345k1")
                    .where("status", isEqualTo: true)
                    .orderBy("InitialTime",descending: true)
                   // .where('startTime', isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day - now.weekday + 1))
                    // .where('startTime', isLessThan:DateTime(now.year, now.month, now.day - now.weekday + 8)) 
                    
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
                    return Screenshot(
                      controller: screenshotController,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,mainAxisExtent: 180),
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          var ids = documents[index].id;
                          var cusName = documents[index]['startTime'].toDate();
                          var task = documents[index]['task'];
                          var diets = documents[index]['deadLine'];
                          var onTime = documents[index]['completeTime'];
                          var initialTime = documents[index]['InitialTime'];
                                            
                          DateTime dateTime = initialTime.toDate();
                          String dayOfWeek = DateFormat('EEEE').format(dateTime);
                          String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
                                            
                          print(initialTime);
                                            
                                            
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    task,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: onTime == "OnTime"
                                      ? Text(
                                          "Done on time",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : onTime == "null"
                                          ? Text("InProgress",style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold),)
                                          : Text("Not in Time $cusName",style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),),
                              
                                              trailing:Text("Deadline $diets hours",style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),),
                                              
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
                                ),
                              ),
                                                                      Text("Day of the week: $dayOfWeek"),
                       Text("Formatted date: $formattedDate"),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            

                       GestureDetector(
             
 
                                         onTap: () async{
await screenshotController
                    .capture()
                    .then((capturedImage) async {

                       // ShowCapturedWidget(context,  capturedImage!);
                setState(() {
                   _imageFile = capturedImage; 
                });
                 ShowCapturedWidget(
       context,  capturedImage!);

                }).catchError((onError) {
                  print(onError);
                });
          
                print(_imageFile); 
  // final tempDir = await getTemporaryDirectory();
  // final file = File('${tempDir.path}/temp_image.png');

  // // Write the Uint8List to the temporary file
  // await file.writeAsBytes(_imageFile!);

  // try {
  //   final result = await ImageGallerySaver.saveFile(file.path);
  //   if (result != null && result.isNotEmpty) {
  //     Get.snackbar("Success","Image saved to Gallery");
  //     print('Image saved to gallery: $result');
  //   } else {
  //     print('Failed to save image to gallery.');
  //   }
  // } on PlatformException catch (e) {
  //   print('Error saving image to gallery: $e');
  // }




              
            },
              child: Container(
                width: 281,
                height: 67,
                decoration: BoxDecoration(
                  color: Color(0xFFF0A637),
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Center(
                  child: Text(
                    "Download",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
