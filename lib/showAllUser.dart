import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserTasks extends StatefulWidget {
  @override
  _UserTasksState createState() => _UserTasksState();
}

class _UserTasksState extends State<UserTasks> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  // final TextEditingController _searchController = TextEditingController();
  late List<QueryDocumentSnapshot> _initialData;
  List<QueryDocumentSnapshot> _filteredData = [];
  String _searchQuery = '';

  String searchQuerys = '';

  // @override
  // void initState() {
  //   super.initState();

  //   // fetchInitialData();
  // }

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  Future<void> fetchInitialData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .orderBy("InitialTime", descending: true)
        .get();
    setState(() {
      _initialData = snapshot.docs;
      _filteredData = _initialData;
    });
    print(_filteredData.length);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  List<QueryDocumentSnapshot> filterData(String searchQuery) {
    return _initialData
        .where((document) => document['user']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  TextEditingController taskiController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController onTimeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  Future<String?> _calculateTimeDifference(
      DateTime currentTime, DateTime deadline) async {}
  void _showEditDialog(BuildContext context, String id, String task,
      String diets, String onTime, bool status) {

           taskiController.text = task;
      deadlineController.text = diets;
         onTimeController.text = onTime;
     statusController.text = status.toString();
     print(onTimeController.text);
    print(id + "asdasdasdasdasdsd");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskiController,
                decoration:
                    InputDecoration(labelText: 'Task Title', hintText: task),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: deadlineController,
                decoration:
                    InputDecoration(labelText: 'Deadline', hintText: diets),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: onTimeController,
                decoration:
                    InputDecoration(labelText: 'onTime', hintText: onTime),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                    labelText: 'Status', hintText: status.toString()),
              ),
              SizedBox(height: 16.0),
              //   Row(
              //     children: [
              //       Text('Deadline: ${selectedDate.toLocal()}'),
              //       SizedBox(width: 10.0),
              //       ElevatedButton(
              //         onPressed: () => _selectDate(context, selectedDate),
              //         child: Text('Select Date'),
              //       ),
              //     ],
              //   ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateTasksJoin(
                    id,
                    taskiController.text,
                    deadlineController.text,
                    onTimeController.text,
                    statusController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTasksJoin(String id, String task, String diets,
      String onTime, String status) async {
    await FirebaseFirestore.instance.collection('tasks').doc(id).update(
      {
        'status': bool.parse(status),
        'task': task,
        "completeTime": onTime,
        "deadLine": diets,
      },
    );

    // taskController.text == "";
    // deadlineController.text == "";
    // onTimeController.text == "";
    // statusController.text == "";
  }

  @override
  Widget build(BuildContext context) {
    print(username);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Users'),
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
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search users',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
                  ),
                  onChanged: (value) {
                    // Trigger the StreamBuilder to rebuild with the updated search query
                    setState(() {});
                  },
                ),
              ),
              // TextField(
              //   controller: _searchController,
              //   onChanged: (value) {
              //     setState(() {
              //       searchQuerys = value;

              //       //_filteredData = filterData(_searchQuery);
              //     });
              //   },
              //   decoration: const InputDecoration(
              //     hintText: 'Search by name',
              //   ),
              // ),
              const SizedBox(height: 16.0),

              //   Expanded(
              // child: _filteredData.isEmpty
              //     ? Text('No data available.')
              //     :
              //   ListView.builder(
              //       itemCount: _filteredData.length,
              //       itemBuilder: (context, index) {
              //         final documents = _filteredData[index];
              //         print(_filteredData.length);
              //         return
              //               Container(
              //         height: MediaQuery.of(context).size.height - 40,
              //         width: MediaQuery.of(context).size.width,
              //         child: ListView.builder(
              //           itemCount: _filteredData.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             var ids = documents.id;
              //             var cusName = documents['startTime'].toDate();
              //             var task = documents['task'];
              //             var diets = documents['deadLine'];
              //             var onTime = documents['completeTime'];
              //             var status = documents['status'];
              //             var userName = documents['userName'];
              //             var initialTime = documents['InitialTime'];
              // // Format date to show day (e.g., "Monday")
              // String formattedDay = DateFormat('EEEE').format(initialTime.toDate());

              // // Format time to show hours and minutes (e.g., "15:30")
              // String formattedTime = DateFormat('HH:mm').format(initialTime.toDate());

              // print('Day: $formattedDay');
              // print('Time: $formattedTime');
              //             return ListTile(

              //               title: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [

              //                   Row(
              //                     children: [
              //                       Text("Task : " ,style: TextStyle(fontWeight: FontWeight.bold), ),
              //                         Expanded(child: Text( task  )),
              //                     ],
              //                   ),

              //                    Row(
              //                      children: [
              //                        Text( "Assigned to :  ",style: TextStyle(color: Colors.red), ),
              //                         Text( userName),
              //                      ],
              //                    ),

              //                      Row(
              //                        children: [
              //                          Text( "Date : ",style: TextStyle(fontWeight: FontWeight.bold), ),
              //                           Text( formattedDay  + "  "),
              //                    Text( formattedTime  + "  "),
              //                        ],
              //                      ),

              //                 ],
              //               ),
              //               subtitle: onTime == "OnTime"
              //                   ? Text(
              //                       "Done on Time",
              //                       style: TextStyle(color: Colors.green),
              //                     )
              //                   : onTime == "null"
              //                       ? Text(
              //                           "Now in Progress",
              //                           style: TextStyle(color: Colors.yellow),
              //                         )
              //                       : Text("Not in Time $cusName",
              //                           style: TextStyle(
              //                             color: Colors.red,
              //                           )),
              //               trailing: status == true
              //                   ? Text("Completed")
              //                   : Text("inProgress"),
              //             );
              //           },
              //         ),
              //       );
              //         //  ListTile(
              //         //    onTap: () {
              //         //     _selectCustomer(document);
              //         //    },
              //         //   title: Text(document['name']),
              //         //   subtitle: Text(document['email']),
              //         // );
              //       },
              //     ),
              // ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _searchController.text.isEmpty
                      ? FirebaseFirestore.instance
                          .collection('tasks')
                          .orderBy("InitialTime", descending: true)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('tasks')
                          .where('user',
                              isGreaterThanOrEqualTo: _searchController.text)
                          .orderBy("user", descending: false)
                          .orderBy("InitialTime", descending: true)
                          .snapshots(),

                  //  FirebaseFirestore.instance
                  //     .collection('tasks')
                  //     .orderBy("InitialTime", descending: true)
                  //     .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    // if (!snapshot.hasData) {
                    //   return const CircularProgressIndicator();
                    // }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      final documents = snapshot.data!.docs;
                      print(documents.length);

                      // List<DocumentSnapshot<Map<String, dynamic>>> users = snapshot.data!.docs;
                      return Container(
                        height: MediaQuery.of(context).size.height - 40,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              var ids = documents[index].id;
                              var cusName =
                                  documents[index]['startTime'].toDate();
                              var task = documents[index]['task'];
                              var diets = documents[index]['deadLine'];
                              var onTime = documents[index]['completeTime'];
                              var status = documents[index]['status'];
                              var userName = documents[index]['userName'];
                              var initialTime = documents[index]['InitialTime'];
                                var haha = documents[index]['onTime'];
                              // Format date to show day (e.g., "Monday")
                              print(userName);
                              String formattedDay = DateFormat('EEEE')
                                  .format(initialTime.toDate());

                              // Format time to show hours and minutes (e.g., "15:30")
                              String formattedTime = DateFormat('HH:mm')
                                  .format(initialTime.toDate());

                              print('Day: $formattedDay');
                              print('Time: $formattedTime');

                              if (searchQuerys == null) {
                                return ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Task : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: Text(task)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Assigned to :  ",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          Text(userName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Date : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(formattedDay + "  "),
                                          Text(formattedTime + "  "),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Status: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          
                                          haha  == "null" ? Text("NotStarted") : haha  == "started" ?  Text("Now in Progress") :Text("Paused") ,
                                         
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: onTime == "OnTime"
                                      ? const Text(
                                          "Done on Time",
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : onTime == "null"
                                          ? const Text(
                                              "Now in progress",
                                              style: TextStyle(
                                                  color: Colors.yellow),
                                            )
                                          : Text("Not in Time $cusName",
                                              style: const TextStyle(
                                                color: Colors.red,
                                              )),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(context, ids, task,
                                              diets, onTime, status);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("tasks")
                                                .doc(ids)
                                                .delete();
                                          } catch (e) {
                                            print(
                                                'Error deleting document: $e');
                                          }
                                          // Call your Firebase delete function or use a service class
                                          // to handle the deletion of the task
                                          // Example: FirebaseService.deleteTask(task.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  //  status == true
                                  //     ? const Text("Completed")
                                  //     : const Text("inProgress"),
                                );
                              }
                              // print()
                              if (snapshot.data!.docs[index]['user']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(searchQuerys.toLowerCase())) {
                                return ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Task : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: Text(task)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Assigned to :  ",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          Text(userName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Date : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(formattedDay + "  "),
                                          Text(formattedTime + "  "),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Deadline : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(diets + " hours"),
                                          // Text(formattedTime + "  "),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Status: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          
                                          haha  == "null" ? Text("NotStarted") : haha  == "started" ?  Text("Now in Progress") :Text("Paused") ,
                                         
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: onTime == "OnTime"
                                      ? const Text(
                                          "Done on Time",
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : 
                                      onTime == "null"
                                          ? const Text(
                                              "Now in Progress",
                                              style: TextStyle(
                                                  color: Colors.yellow),
                                            )
                                          : Text("Not in Time $cusName",
                                              style: const TextStyle(
                                                color: Colors.red,
                                              )),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(context, ids, task,
                                              diets, onTime, status);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("tasks")
                                                .doc(ids)
                                                .delete();
                                          } catch (e) {
                                            print(
                                                'Error deleting document: $e');
                                          }
                                          // Call your Firebase delete function or use a service class
                                          // to handle the deletion of the task
                                          // Example: FirebaseService.deleteTask(task.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  //  status == true
                                  //     ? const Text("Completed")
                                  //     : const Text("inProgress"),
                                );
                              } else {
                                const Center(
                                  child: const Text("data"),
                                );
                              }
                            }),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
