import 'package:atten/shared.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



class AssignByEmp extends StatefulWidget {
  @override
  _AssignByEmpState createState() => _AssignByEmpState();
}

class _AssignByEmpState extends State<AssignByEmp> {
  String selectedUser = "";
   String idUser = ""; 
  TextEditingController taskController = TextEditingController();
  TextEditingController deadLineController = TextEditingController();
 TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
   DateTime _selectedDeadline = DateTime.now();
   String username = PreferencesManager.instance.getUserName();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Assignment App'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Assign Task to User:'),
              // ElevatedButton(
              //   onPressed: () {
              //     _showUserList();
              //   },
              //   child: Text('Select User'),
              // ),
              SizedBox(height: 16),
              // Text(selectedUser.isNotEmpty
              //     ? 'Selected User: $selectedUser'
              //     : 'No User Selected'),
              // SizedBox(height: 16),
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: 'Enter Task'),
              ),
              SizedBox(height: 16),
               Text('Assign Task to User:'),
                SizedBox(height: 16),
                   TextField(
                controller: deadLineController,
                decoration: InputDecoration(labelText: 'Enter Hours Deadline'),
              ),

               SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  assignTask(username);
                },
                child: Text('Assign Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showUserList() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StreamBuilder<QuerySnapshot>(
  //         stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return CircularProgressIndicator();
  //           } else {
  //             List<String> users =
  //                 snapshot.data!.docs.map((doc) => doc["userName"] as String).toList();
  //                      List<String> idsUser =
  //                 snapshot.data!.docs.map((doc) => doc.id).toList();
  //             return ListView.builder(
  //               itemCount: users.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return ListTile(
  //                   title: Text(users[index]),
  //                   onTap: () {
  //                     setState(() {
  //                       selectedUser = users[index];
  //                      idUser = idsUser[index]; 
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                 );
  //               },
  //             );
  //           }
  //         },
  //       );
  //     },
  //   );
  // }
 

  void assignTask(String idUsersid) async {
     List<DocumentSnapshot> documents = [];
  List cardEx = [];

  String? nameOfUser;


    documents.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: idUsersid)
     
        .get();
    documents = result.docs;
  
    print(documents.length);
    if (documents.length > 0) {
      cardEx.add(result.docs);
    
      // print(documents.first["inOut"]);
     var  nameOfUser = documents.first["userName"];
  //    userController.inOut  = documents.first["inOut"];
  //  userController.total = documents.first["totalHours"];
  //    userController.update();

    setState(() {
      
    });
    

      
    } else {
      Get.snackbar("Information Missing Or invalid",
          "Please write correct information ");

    }
   // String username =  await PreferencesManager.instance.getUserName(); 
    EasyLoading.show();
    if (taskController.text.isNotEmpty) {
      // Assign task to the selected user
      await FirebaseFirestore.instance.collection('tasks').add({
        'user': nameOfUser,
        'task': taskController.text,
        'status': false,
        'startTime': DateTime.now(),
        "idUser":idUsersid,
        "deadLine":deadLineController.text,
        "completeTime":"null",
        "totalTime":0,
        "onTime":"null",
        "userName":nameOfUser,
        "isRunning":false,
        "InitialTime":DateTime.now(),
        "pending":true

      });

      // Clear the task text field
      taskController.clear();
      EasyLoading.dismiss();
    }
  }
}
