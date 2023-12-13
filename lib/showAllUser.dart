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
          title: Text('Users'),
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
           
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              
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
                  var status = documents[index]['status']; 
                  var userName = documents[index]['userName']; 
                   
                    return ListTile(
                      title: Text(task  + "     Assigned to  " +  userName),

                      subtitle: 
                      
                      onTime == "OnTime" ? Text("Done on Time"): onTime =="null" ? Text("Now in Progress") :Text("Not in Time $cusName"),


                      trailing: status == true ? Text("Completed"):Text("inProgress"),

                    );
                  },
                ),
              );
            }
          },
        ));
  }




}




