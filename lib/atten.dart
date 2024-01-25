import 'dart:convert';

import 'package:atten/datewise.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:wifi_info_flutter/wifi_info_flutter.dart';



// class WiFiCheck extends StatefulWidget {
//   @override
//   _WiFiCheckState createState() => _WiFiCheckState();
// }

// class _WiFiCheckState extends State<WiFiCheck> {
//   String connectedWiFi = 'Unknown';

//   @override
//   void initState() {
//     super.initState();
//     _checkWiFi();
//   }

//   Future<void> _checkWiFi() async {
//     ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

//     if (connectivityResult == ConnectivityResult.wifi) {
//       String wifiName = await WiFiInfo().getWifiName();
//       setState(() {
//         connectedWiFi = wifiName ?? 'Unknown';
//       });
//     } else {
//       setState(() {
//         connectedWiFi = 'Not connected';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Connected Wi-Fi: $connectedWiFi'),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               _checkWiFi();
//             },
//             child: Text('Check Wi-Fi'),
//           ),
//         ],
//       ),
//     );
//   }
// }


class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isIn = true;
  DateTime? checkInTime;
  DateTime? checkOutTime;

  void toggleInOut() async {
    if (isIn) {
      // User is checking in
      setState(() {
        checkInTime = DateTime.now();
        isIn = false;
      });

      
    } else {
      // User is checking out
      setState(() {
        checkOutTime = DateTime.now();
        isIn = true;
      });

      // Calculate working hours
      if (checkInTime != null) {
        Duration workDuration = checkOutTime!.difference(checkInTime!);

        // Check if working hours are less than 9 hours
        if (workDuration.inHours < 9) {
          int remainingTime = (9 * 60) - workDuration.inMinutes;
          // Display a message about leaving early
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Leave Early'),
                content: Text('You left early by ${workDuration.inHours} hours and ${workDuration.inMinutes % 60} minutes. Spend ${remainingTime} minutes in the future.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Display a message about leaving on time
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Leave On Time'),
                content: Text('You left on time. You have ${workDuration.inMinutes} minutes to spend in the future.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }

        // Store the attendance data in Firebase
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String dateString = DateTime.now().toLocal().toIso8601String().split('T')[0];
          FirebaseFirestore.instance.collection('attendance').doc(user.uid).collection('records').doc(dateString).set({
            'checkInTime': checkInTime,
            'checkOutTime': checkOutTime,
          });
        }
      }
    }
  }

  Future<http.Response> sendNotification(
      List<String> tokenIdList,
      
     //  String contents, String heading
       
       ) async {
        print("adaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    return await
    
     http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "f57e65c6-01a7-4fce-bab6-1b5da313fd20",
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":tokenIdList,
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": "heading"},

        "contents": {"en": "contents"},
      }),
    );
  }

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance System'),
        actions: [
//           GestureDetector(
//             onTap: () async{
//           await    sendNotification(
//    ["55cc71bf-6c39-4830-90c6-5b3052962b1c"]
      
//      //  String contents, String heading
       
//        );
//             },
//             child: Container(
//               height: 100,
//               width: 100,
//               color: Colors.black,
// child: Text("data"),
//             ),
//           ),
           GestureDetector(
              onTap: () async{
           Get.to(()=>TaskList());     
  //         await    sendNotification(
  //  ["7c8f98a1-8f0f-4899-98ff-b4eb97e5fd99"]
      
  //    //  String contents, String heading
       
  //      );
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.black,
child: Text("data"),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isIn ? 'Press "In" when you arrive' : 'Press "Out" when you leave',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleInOut,
              child: Text(isIn ? 'In' : 'Out'),
            ),
            SizedBox(height: 20),
            if (checkInTime != null)
              Text('Last Check-In: ${checkInTime.toString()}'),
            if (checkOutTime != null)
              Text('Last Check-Out: ${checkOutTime.toString()}'),
          ],
        ),
      ),
    );
  }
}