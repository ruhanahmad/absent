// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class Task {
//   final String id;
//   final String userId;
//   final String task;
//   final DateTime deadline;
//   final bool status;
//   final DateTime completeTime;

//   Task({
//     required this.id,
//     required this.userId,
//     required this.task,
//     required this.deadline,
//     required this.status,
//     required this.completeTime,
//   });

//   factory Task.fromMap(String id, Map<String, dynamic> data) {
//     return Task(
//       id: id,
//       userId: data['userId'],
//       task: data['task'],
//       deadline: (data['deadline'] as Timestamp).toDate(),
//       status: data['status'],
//       completeTime: (data['completeTime'] as Timestamp?)?.toDate(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'task': task,
//       'deadline': deadline,
//       'status': status,
//       'completeTime': completeTime,
//     };
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _taskController = TextEditingController();
//   DateTime _selectedDeadline = DateTime.now();
//   List<Task> _tasks = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadTasks();
//   }

//   Future<void> _loadTasks() async {
//     final user = 'user123'; // Replace with actual user ID
//     final tasksSnapshot = await FirebaseFirestore.instance
//         .collection('tasks')
//         .where('userId', isEqualTo: user)
//         .get();

//     setState(() {
//       _tasks = tasksSnapshot.docs
//           .map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//           .toList();
//     });
//   }

//   Future<void> _assignTask() async {
//     final user = 'user123'; // Replace with actual user ID
//     final task = _taskController.text;
//     final deadline = _selectedDeadline;

//     if (task.isNotEmpty) {
//       await FirebaseFirestore.instance.collection('tasks').add({
//         'userId': user,
//         'task': task,
//         'deadline': deadline,
//         'status': false,
//         'completeTime': null,
//       });

//       _taskController.clear();
//       _loadTasks();
//     }
//   }

//   Future<void> _updateTask(Task selectedTask) async {
//     final currentTime = DateTime.now();
//     final deadline = selectedTask.deadline;

//     // Update task status and complete time
//     await FirebaseFirestore.instance
//         .collection('tasks')
//         .doc(selectedTask.id)
//         .update({
//       'status': true,
//       'completeTime': currentTime,
//     });

//     // Reload tasks
//     _loadTasks();

//     // Calculate and show the time difference
//     _calculateTimeDifference(currentTime, deadline);
//   }

//   void _calculateTimeDifference(DateTime currentTime, DateTime deadline) {
//     final Duration difference = currentTime.difference(deadline);

//     if (difference.isNegative) {
//       // Time exceeds the deadline
//       final exceededTime = -difference;
//       final formattedExceededTime =
//           DateFormat.Hms().format(DateTime(0, 1, 1, exceededTime.inHours, exceededTime.inMinutes % 60));
//       print('Time Exceeded by $formattedExceededTime');
//     } else {
//       print('Task Completed on Time');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task Manager'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Assign Task',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: _taskController,
//               decoration: InputDecoration(labelText: 'Task'),
//             ),
//             SizedBox(height: 10),
//             Text('Deadline: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDeadline)}'),
//             ElevatedButton(
//               onPressed: () async {
//                 final pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: _selectedDeadline,
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(2101),
//                 );

//                 if (pickedDate != null) {
//                   final pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
//                   );

//                   if (pickedTime != null) {
//                     setState(() {
//                       _selectedDeadline = DateTime(
//                         pickedDate.year,
//                         pickedDate.month,
//                         pickedDate.day,
//                         pickedTime.hour,
//                         pickedTime.minute,
//                       );
//                     });
//                   }
//                 }
//               },
//               child: Text('Pick Deadline'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _assignTask,
//               child: Text('Assign Task'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Your Tasks',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = _tasks[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 5),
//                     child: ListTile(
//                       title: Text(task.task),
//                       subtitle: Text('Deadline: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}'),
//                       trailing: ElevatedButton(
//                         onPressed: () => _updateTask(task),
//                         child: Text('Update'),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
