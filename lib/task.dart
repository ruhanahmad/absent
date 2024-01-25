import 'package:atten/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';


class TaskAssignmentScreen extends StatefulWidget {
  @override
  _TaskAssignmentScreenState createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
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
 


 Uint8List? _image;
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
              Text('Assign Task to User:'),
              ElevatedButton(
                onPressed: () {
                  _showUserList();
                },
                child: Text('Select User'),
              ),
              SizedBox(height: 16),
              Text(selectedUser.isNotEmpty
                  ? 'Selected User: $selectedUser'
                  : 'No User Selected'),
              SizedBox(height: 16),
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
  Stack(
                  children: [
                    _image != null
                        ? Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: MemoryImage(_image!))
                          ),
                            // radius: 64,
                            // backgroundColor: Colors.blue.shade900,
                         //   backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.blue.shade900,
                            backgroundImage: NetworkImage(
                                'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                          ),
                    Positioned(
                      right: 0,
                      top: 5,
                      child: IconButton(
                        onPressed: () {
                          selectGalleryImage();
                        },
                        icon: Icon(
                          CupertinoIcons.photo,
                        ),
                      ),
                    ),
                  ],
                ),
               SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
              _image == null ?    assignTask(idUser,selectedUser)
              : assignTaskTwo(idUser, selectedUser, _image)
              ;
                },
                child: Text('Assign Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  selectGalleryImage() async {
    Uint8List im = await pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }
  final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
    _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('profilePics').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
  void _showUserList() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              List<String> users =
                  snapshot.data!.docs.map((doc) => doc["userName"] as String).toList();
                       List<String> idsUser =
                  snapshot.data!.docs.map((doc) => doc.id).toList();
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(users[index]),
                    onTap: () {
                      setState(() {
                        selectedUser = users[index];
                       idUser = idsUser[index]; 
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }
          },
        );
      },
    );
  }
 

  void assignTask(String idUsersid,String selectedUser) async {
  // String profileImageUrl = await _uploadProfileImageToStorage(_image);
    //  await _uploadProfileImageToStorage(_image);
   // String username =  await PreferencesManager.instance.getUserName(); 
    EasyLoading.show();
    if (selectedUser.isNotEmpty && taskController.text.isNotEmpty) {
      // Assign task to the selected user
      await FirebaseFirestore.instance.collection('tasks').add({
        'user': selectedUser,
        'task': taskController.text,
        'status': false,
        'startTime': DateTime.now(),
        "idUser":idUsersid,
        "deadLine":deadLineController.text,
        "completeTime":"null",
        "totalTime":0,
        "onTime":"null",
        "userName":selectedUser,
        "isRunning":false,
        "InitialTime":DateTime.now(),
        "pending":false,
        "image":""

      });

      // Clear the task text field
      taskController.clear();
      EasyLoading.dismiss();
    }
  }


   void assignTaskTwo(String idUsersid,String selectedUser,_image) async {
  String profileImageUrl = await _uploadProfileImageToStorage(_image);
    //  await _uploadProfileImageToStorage(_image);
   // String username =  await PreferencesManager.instance.getUserName(); 
    EasyLoading.show();
    if (selectedUser.isNotEmpty && taskController.text.isNotEmpty) {
      // Assign task to the selected user
      await FirebaseFirestore.instance.collection('tasks').add({
        'user': selectedUser,
        'task': taskController.text,
        'status': false,
        'startTime': DateTime.now(),
        "idUser":idUsersid,
        "deadLine":deadLineController.text,
        "completeTime":"null",
        "totalTime":0,
        "onTime":"null",
        "userName":selectedUser,
        "isRunning":false,
        "InitialTime":DateTime.now(),
        "pending":false,
        "image":profileImageUrl

      });

      // Clear the task text field
      taskController.clear();
      EasyLoading.dismiss();
    }
  }
}
