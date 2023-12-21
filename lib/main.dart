import 'package:atten/choice.dart';
import 'package:atten/firebase_options.dart';
import 'package:atten/homeScreen.dart';
import 'package:atten/loginScreen.dart';
import 'package:atten/shared.dart';
import 'package:atten/tabBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
     WidgetsFlutterBinding.ensureInitialized();
      await PreferencesManager.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 
 
  runApp( MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
  }
  String username = PreferencesManager.instance.getUserName();
//    String? action;
//   void imra() async{
//  final SharedPreferences prefs = await SharedPreferences.getInstance();
//  setState(() {
//   action = prefs.getString('action'); 
//  });
//   print(action);
//   }
// User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
  
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
     home: 
     
   // TagSelectionScreen()
     username ==  ""  ? LoginScreen():SiteEngineer(),
    );
  }
}

