import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:atten/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';



class RecordList extends StatelessWidget {
  String wait;
RecordList({required this.wait});
  @override
  Widget build(BuildContext context) {
    return
     StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('idUser', isEqualTo: wait)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
         print(wait);
        final records = snapshot.data?.docs ?? [];
        bool isWorking = records.any((record) => record['isRunning'] == true);

        return ListTile(
          title: Text('Your Work Status'),
          subtitle: _buildStatusMessage(isWorking),
        );
      },
    );
  }

  Widget _buildStatusMessage(bool isWorking) {
    print(isWorking);
    if (isWorking) {

      return Text('We love you becuase You are working. Keep it up!');
    } else {
      return Text('You are not working. Please start a task and save the world');
    }
  }
}

class ShowTask extends StatefulWidget {
  @override
  _ShowTaskState createState() => _ShowTaskState();
}

class _ShowTaskState extends State<ShowTask> {
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

  // Future<String?> _calculateTimeDifference(
  //     DateTime currentTime, DateTime deadline) async {}
  String calculateRemainingTime(DateTime initals, int taskTimeInMillis) {
    // Convert milliseconds to DateTime
    // DateTime taskTime = DateTime.fromMillisecondsSinceEpoch(taskTimeInMillis);

    // // Calculate remaining time
    // DateTime now = DateTime.now();
    // DateTime taskDateTime = now.add(Duration(hours: hours));
    // Duration remainingDuration = taskDateTime.difference(now);

    // // Extract the remaining time portion
   



        // var initals = documents[index]['InitialTime'].toDate();
   DateTime futureDateTime = DateTime.fromMillisecondsSinceEpoch(taskTimeInMillis);
    // DateTime currentprinDateTime = DateTime.now();
print(futureDateTime);
    Duration remainingTime = initals.difference(futureDateTime);
 print(remainingTime.inHours);

    int remainingHours = remainingTime.inHours;
    int remainingMinutes = (remainingTime.inMinutes % 60);
     int remainingSeconds = (remainingTime.inSeconds % 60 );


 String remainingTimeShow =
        '${remainingHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}';



    return remainingTimeShow;
  }

  Future<void> addNewFieldToTasks() async {
  // Reference to the "tasks" collection
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  // Get all documents in the collection
  QuerySnapshot querySnapshot = await tasks.get();

  // Iterate through each document and update it with the new field
  for (QueryDocumentSnapshot document in querySnapshot.docs) {
    await tasks.doc(document.id).update({'pending': false});
  }
}
String playerId ="";
  Future getPlayerId() async {
    try {

 var deviceState = await OneSignal.User;

    if (deviceState == null || deviceState.pushSubscription.id == null)
        return;


        setState(() {
           playerId = deviceState.pushSubscription.id!;
     
        });

 
     print("playeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeer" + playerId);
   //await  updateToken();
    }
    catch(e){
     Get.snackbar("title", "not getting PlayerID  ${e}");
    }

  }
  void _showImageDialog(BuildContext context,String image){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 1400,
            height: 1400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

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
             //  await getPlayerId();
                await FirebaseAuth.instance.signOut();
                PreferencesManager.instance.removeUserName();
                Get.to(() => LoginScreen());

  // final CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');

  // // Get all documents in the collection
  // QuerySnapshot querySnapshot = await tasksCollection.get();

  // // Update each document with the new field
  // for (QueryDocumentSnapshot document in querySnapshot.docs) {
  //   // Update the document with the new field
  //   await tasksCollection.doc(document.id).update({
  //     'image': '', // You can set any default value for the "image" field here
  //   });
  // }

                // StorageServices.to.remove("userId");
              },
              child: Text('Sign out'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // await FirebaseAuth.instance.signOut();
            //     // PreferencesManager.instance.removeUserName();
            //     // Get.to(() => LoginScreen());

            //     // StorageServices.to.remove("userId");
            //  await   addNewFieldToTasks();
            //   },
            //   child: Text('Sign '),
            // ),
          ],
        ),
        body: Column(
          children: [
            RecordList(wait:username),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where("idUser", isEqualTo: username)
                  .where("status", isEqualTo: false)
                  .where("pending", isEqualTo: false)
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
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 250,
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
                          var image = documents[index]['image'];
                                
                                  var initals = documents[index]['InitialTime'].toDate();
                                   DateTime futureDateTime = DateTime.fromMillisecondsSinceEpoch(totalTime);
                                    // DateTime currentprinDateTime = DateTime.now();
                                print(futureDateTime);
                                    Duration remainingTime = initals.difference(futureDateTime);
                                 print(remainingTime.inHours);
                                
                                    int remainingHours = remainingTime.inHours;
                                    int remainingMinutes = (remainingTime.inMinutes % 60);
                                     int remainingSeconds = (remainingTime.inSeconds % 60 );
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                         image == ""? 
                      Container()                
                     :
                    
                       GestureDetector(
                        onTap: ()async {
                          _showImageDialog(context,image);
                        },
                         child: CircleAvatar(
                                              radius: 20,
                                               backgroundImage: NetworkImage(image),
                                             ),
                       )
                    ,
                                        Text(
                                          "Task:  " + task,
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        // Text(
                                        //     "Remaining Time: ${calculateRemainingTime(initals, totalTime)}")
                                      ],
                                    ),
                                    Text(
                                      "Deadline:  " + diets + " hour",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => runn == true
                                              ? pauseTimer(ids, cusName, totalTime)
                                              : startTimer(ids),
                                          child:
                                              Text(runn == true ? 'Pause' : 'Start'),
                                        ),
                                  //  ElevatedButton(
                                  //                                   onPressed: () {
                                
                                  //                                   },
                                         
                                         
                                  //                                   child:
                                  //                                       Text(
                                  //                                          'Remaining Time' ),
                                  //                                 ),
                                        runn == true
                                            ? ElevatedButton(
                                                onPressed: () => completeTask(
                                                    ids, cusName, totalTime, diets),
                                                child: Text('Complete'),
                                              )
                                            : Container()
                                        //             ElevatedButton(
                                        //               onPressed: () =>
                                        // completeTask(ids,cusName,totalTime,diets)
                                        //               ,
                                        //               child: Text("  "),
                                        //             )
                                        ,
                                        // Container(
                                        //   height: 50,
                                        //   width: 80,
                                        //   color: Colors.amber,
                                
                                        //                     child: Center(child: Text("Complete")),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }

  bool isRunning = false;

  void startTimer(String ids) async {
    // setState(() {
    //    isRunning = true;
    // });

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(ids)
        .update({'startTime': DateTime.now(), "isRunning": true,"onTime":"started"});

    //  currentTask.startTime = DateTime.now();
  }

  void pauseTimer(String ids, var ss, int totalTime) async {
    // setState(() {
    //   isRunning = false;
    // });

    await FirebaseFirestore.instance.collection('tasks').doc(ids).update({
      'totalTime':
          totalTime + DateTime.now().difference(ss.toDate()).inMilliseconds,
      "isRunning": false,
      "onTime":"paused"
    });
    //  currentTask.totalTime += DateTime.now().difference(currentTask.startTime).inMilliseconds;
  }

  void completeTask(String ids, var ss, int totalTime, String deadlinez) async {
    // setState(() {
    // isRunning = false;
    // });

    await FirebaseFirestore.instance.collection('tasks').doc(ids).update({
      'totalTime':
          totalTime + DateTime.now().difference(ss.toDate()).inMilliseconds,
      "isRunning": false,
    });
    int jij;

// setState(() async{
    jij = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(ids)
        .get()
        .then((value) => value["totalTime"]);

    print(jij);
// });
    //  var jij =    await FirebaseFirestore.instance
    //       .collection('tasks')
    //       .doc(ids)
    //       .get().then((value) => value["totalTime"]);

    //       print(jij);
    //    var jij;
    //   setState(() {
    // jij = totalTime + DateTime.now().difference(ss.toDate()).inMilliseconds;
    //   });
    int remainingTime = int.parse(deadlinez) - (jij / (1000 * 60 * 60)).round();
    print(remainingTime >= 0
        ? 'Task completed on time!'
        : 'Task exceeded the deadline!');

    // Update Firebase with task completion details
    // await _firestore.collection('tasks').add({
    //   'taskName': currentTask.taskName,
    //   'deadlineHours': currentTask.deadlineHours,
    //   'totalTime': currentTask.totalTime,
    //   'completedOnTime': remainingTime >= 0,
    //   'timestamp': FieldValue.serverTimestamp(),
    // });
    await FirebaseFirestore.instance.collection('tasks').doc(ids).update({
      // "totalTime":totalTime,
      "completeTime": remainingTime >= 0 ? "OnTime" : "noTime",
      "status": true,
    });

    // Reset the current task for the next one
    // setState(() {
    //   currentTask = Task(taskName: 'Example Task', deadlineHours: 8, startTime: DateTime.now());
    // });
  }
}
