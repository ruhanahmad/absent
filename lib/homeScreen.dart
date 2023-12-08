import 'package:atten/authController.dart';
import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    String username = PreferencesManager.instance.getUserName();
   UserController userController = Get.put(UserController());
  TextEditingController taskController = TextEditingController();
  DocumentReference? ref;

  int tag = 3;

  // multiple choice value
  List<String> tags = ['Projects:'];

  // list of string options
  List<String> options = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> chipsList = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  void _fetchAttendance() {
    _firestore.collection('chips').get().then((querySnapshot) {
      setState(() {
        chipsList = querySnapshot.docs
            .map((doc) => doc.data()['name'].toString())
            .toList();
      });
    }).catchError((error) {
      print("Error fetching attendance: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: [
           Row(
             children: [
              ElevatedButton(
                  onPressed: ()async{
                     
                      setState(() {
                     _fetchAttendance() ;

  
                      });
                 
                  },
                  child: Text('Refresh'),
                ), 
               ElevatedButton(
                  onPressed: ()async{
                      await FirebaseAuth.instance.signOut();
                      Get.to(()=>LoginScreen());
                    PreferencesManager.instance.removeUserName();
                  },
                  child: Text('Sign out'),
                ),
             ],
           ),
         
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
       userController.inOut == "" || userController.inOut == "out" ?   
        Column(
          children: [
            CircleButton(
                  text: 'In',
                  color: Colors.red,
                  onPressed: () {
                    // Save the "In" record to Firestore when the button is pressed.
                    saveRecord('In');
                  },
                ),
               
          ],
        ):
       
            Column(
              children: [
                CircleButton(
                  text: 'Out',
                  color: Colors.red,
                  onPressed: ()async {
                 String username = PreferencesManager.instance.getUserName();
                    userController.update();
                    // Save the "Out" record to Firestore when the button is pressed.
                    await FirebaseFirestore.instance.collection('users').doc(username).collection("attendance").doc(ref!.id).update({
    
        "outTime":DateTime.now(),
        "status":"out",
        "projects":tags
    
      });
      // userController.total =0;
      // userController.update();

 
       await FirebaseFirestore.instance.collection('users').doc(username).update({
    
        "inOut":"out",
        "outTime":DateTime.now(),
   //     "totalHours":userController.totalHours
        
    
 
      });

       



// userController.totalHours = 0;
// userController.update();

      
    List<DocumentSnapshot> documents = [];
  List cardEx = [];

  String? exCardB;


    documents.clear();
   
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: username)
     
        .get();
    documents = result.docs;
  
    print(documents.length);
    if (documents.length > 0) {
      cardEx.add(result.docs);
    
      print(documents.first["inOut"]);
       
     userController.inOut  = documents.first["inOut"];
   userController.total = documents.first["totalHours"];
     userController.update();

    setState(() {
      
    });
    

      
    } else {
      Get.snackbar("Information Missing Or invalid",
          "Please write correct information ");

    }





   List<DocumentSnapshot> documentss = [];
  List cardExs = [];

  String? exCardBs;


    documents.clear();
   
    final DocumentSnapshot results = await FirebaseFirestore.instance
        .collection('users').doc(username).collection("attendance").doc(ref!.id)
      
     
        .get();
    documentss.add(results);

    print(documentss.length);
    if (documentss.length > 0) {
    //  cardExs.add(results.docs);

 
 var ids = documentss.first.id;
        
                          var totalHourss = documentss.first["total"];
                          var min = documentss.first["minutes"];
                            var leaveTime = documentss.first["leaveTime"];
                         DateTime dateTimes = leaveTime.toDate();
                            var outTime = documentss.first["outTime"];
                         DateTime dateTimess = outTime.toDate();
                          var ff =dateTimes.difference(dateTimess);
                         int hours = ff.inHours;
                  int minutes = ff.inMinutes.remainder(60);
                          
         await FirebaseFirestore.instance.collection('users').doc(username).collection("attendance").doc(ref!.id).update({
    
        "total":totalHourss +hours,
        "minutes":min +minutes
     

    
      });
                      
  //    userController.inOut  = documents.first["inOut"];
  //  userController.total = documents.first["totalHours"];
  //    userController.update();

    setState(() {
      
    });
    

      
    } else {
      Get.snackbar("Information Missing Or invalid",
          "Please write correct information ");

    }
  
  
  // userController.totalHours  += userController.total;
  //        await FirebaseFirestore.instance.collection('users').doc(username).update({
    
       
  //       "totalHours":userController.totalHours
        
    
  //     });
                    // saveRecord('Out');
                  },
                ),
                
 Container(
          height: 200,
width: 500,                   
                    child: ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: chipsList,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      choiceCheckmark: true,
                      choiceStyle: C2ChipStyle.outlined(),
                    ),
                  ),

                   TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 20),

              ],
            ),



          //   StreamBuilder(stream: 
          //   FirebaseFirestore.instance.collection("users").doc(username).collection("attendance").snapshots(),
          //    builder: (context,snapshot){
          //    if (!snapshot.hasData) {
          //     return CircularProgressIndicator();
          //   }
          // final records =    snapshot.data!.docs;
          //     return Container(
          //       height: 400,
          //       width: MediaQuery.of(context).size.width,
          //       child: ListView.builder(
                  
          //         itemCount: records.length,
          //         itemBuilder: (context,i){
          //            var id = records[i].id;
              
          //       }),
          //     );
          //    })
          

          StreamBuilder(stream: 
            FirebaseFirestore.instance.collection("users").where("user_id",isEqualTo: username).snapshots(),
             builder: (context,snapshot){
             if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
          final records =    snapshot.data!.docs;

       
              return Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  
                  itemCount: records.length,
                  itemBuilder: (context,i){
                     var id = records[i].id;
                     userController.inOut= records[i]["inOut"];
                    var timeTake = records[i]["timeText"];
                    DateTime dateTime = timeTake.toDate();
                    var leaveTime = records[i]["leaveTime"];
                     DateTime dateTimes = leaveTime.toDate();
                        var outTime = records[i]["outTime"];
                     DateTime dateTimess = outTime.toDate();
                      var totalHours = records[i]["totalHours"];
                     var ff =dateTimes.difference(dateTimess);
                     int hours = ff.inHours;
int minutes = ff.inMinutes.remainder(60);

print('Time Difference: $hours hours and $minutes minutes');

// Accumulate the hours difference
            //  userController.totalHours = hours;
            //  userController.update();
             print("asdasd" + "${userController.totalHours}");
    

              String formatDateTimeIn12HourFormat(DateTime dateTime) {
  final DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm a');
  return formatter.format(dateTime);
}

// Format the date and time in 12-hour format.
String formattedDateAndTimeTake = formatDateTimeIn12HourFormat(dateTime);
String formattedDateAndTimeLeave = formatDateTimeIn12HourFormat(dateTimes);
String formattedDateAndTimeOut = formatDateTimeIn12HourFormat(dateTimess);

                   return  userController.inOut == "in" ? Column(
                     children: [
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical:20.0),
                         child: Text("Your leave time should be ${formattedDateAndTimeLeave} ",style: TextStyle(fontSize: 24)),
                       ),


                     ],
                   ): 
                    Column(
                      children: [
                        Text("Click to Start Your Time",style: TextStyle(fontSize: 24),),

                     dateTimess.isBefore(dateTimes) ? Text("Your leave before Time"):Text("You leave on Time")

                      ],
                    );
                  
                }),
              );
             })
          ],
        ),
      ),
    );
  }

  // Function to save a record to Firestore.
  void saveRecord(String status) async {
    try {
      // Get a reference to the Firestore collection where you want to store the records.
      CollectionReference records =
          FirebaseFirestore.instance.collection('users');

      // Create a new record document with the current user's ID and the status ("In" or "Out").
     

       
  
       ref=  await records.doc(username).collection("attendance").add({
        'user_id': username,
        'status': status,
        'timestamp': DateTime.now(), 
        "outTime":"",
        "leaveTime":DateTime.now().add(Duration(hours: 9)),
        "total":0,
        "minutes":0,
        "projects":[]
      });

       await records.doc(username).update({
        'user_id': username,
        "inOut":"in",
        "leaveTime":DateTime.now().add(Duration(hours: 9)),

      });
      setState(() {
        
      });

      // Calculate the leave time as the current time + 9 hours.
     

      // Display a message to the user.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('You can leave at $leaveTime'),
      //   ),
      // );


  //       List<DocumentSnapshot> documents = [];
  // List cardEx = [];

  // String? exCardB;


  //   documents.clear();
   
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('user_id', isEqualTo: username)
     
  //       .get();
  //   documents = result.docs;
  
  //   print(documents.length);
  //   if (documents.length > 0) {
  //     cardEx.add(result.docs);
    
  //     print(documents.first["inOut"]);
       
  //    userController.inOut  = documents.first["inOut"];
  //    userController.timeText = documents.first["timeText"];
  //    userController.update();

  //   setState(() {
      
  //   });

      
      
  //   } else {
  //     Get.snackbar("Information Missing Or invalid",
  //         "Please write correct information ");

  //   }
  

    } catch (e) {
      print('Error saving record: $e');
      // Handle error, show an error message to the user, etc.
    }
  }
}

class CircleButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  CircleButton({required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        primary: color,
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
