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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart';


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
    String _debugLabelString = "";
  String? _emailAddress;
  String? _smsNumber;
  String? _externalUserId;
  String? _language;
  bool _enableConsentButton = false;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
initPlatformState();
// _checkPermissionsAndLocation();
    
  }


// Future<void> _checkPermissionsAndLocation() async {
//   var status = await Permission.location.request();
//     // PermissionStatus permissionStatus = 


//     if (status.isGranted) {
//       bool serviceEnabled = await location.serviceEnabled();

//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) {
//           print('Location services are disabled');
//           // Handle case where location services are not enabled
//         }
//       } else {
//         print('Location services are enabled');
//         // Location services are enabled, continue with your logic
//       }
//     } else {
//       print('Location permission denied');
//       // Handle case where location permission is denied
//     }
//   }
    Future<void> initPlatformState() async {

    if (!mounted) return;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(_requireConsent);
         

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    OneSignal.initialize("f57e65c6-01a7-4fce-bab6-1b5da313fd20");
   _handlePromptForPushPermission();
    // AndroidOnly stat only
    // OneSignal.Notifications.removeNotification(1);
    // OneSignal.Notifications.removeGroupedNotifications("group5");
       
     OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.addClickListener((event) {
      print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
      this.setState(() {
        _debugLabelString =
            "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print(
          'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();

      this.setState(() {
        _debugLabelString =
            "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.InAppMessages.addClickListener((event) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
    });

    this.setState(() {
      _enableConsentButton = _requireConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeExamples();

    OneSignal.InAppMessages.paused(true);
  }



  void _handleSendTags() {
    print("Sending tags");
    OneSignal.User.addTagWithKey("test2", "val2");

    print("Sending tags array");
    var sendTags = {'test': 'value', 'test2': 'value2'};
    OneSignal.User.addTags(sendTags);
  }

  void _handleRemoveTag() {
    print("Deleting tag");
    OneSignal.User.removeTag("test2");

    print("Deleting tags array");
    OneSignal.User.removeTags(['test']);
  }

  void _handlePromptForPushPermission() {
    print("Prompting for Permission");
    OneSignal.Notifications.requestPermission(true);
  }

  void _handleSetLanguage() {
    if (_language == null) return;
    print("Setting language");
    OneSignal.User.setLanguage(_language!);
  }

  void _handleSetEmail() {
    if (_emailAddress == null) return;
    print("Setting email");

    OneSignal.User.addEmail(_emailAddress!);
  }

  void _handleRemoveEmail() {
    if (_emailAddress == null) return;
    print("Remove email");

    OneSignal.User.removeEmail(_emailAddress!);
  }

  void _handleSetSMSNumber() {
    if (_smsNumber == null) return;
    print("Setting SMS Number");

    OneSignal.User.addSms(_smsNumber!);
  }

  void _handleRemoveSMSNumber() {
    if (_smsNumber == null) return;
    print("Remove smsNumber");

    OneSignal.User.removeSms(_smsNumber!);
  }

  void _handleConsent() {
    print("Setting consent to true");
    OneSignal.consentGiven(true);

    print("Setting state");
    this.setState(() {
      _enableConsentButton = false;
    });
  }

  void _handleSetLocationShared() {
    print("Setting location shared to true");
    OneSignal.Location.setShared(true);
  }

  void _handleLogin() {
    print("Setting external user ID");
    if (_externalUserId == null) return;
    OneSignal.login(_externalUserId!);
    OneSignal.User.addAlias("fb_id", "1341524");
  }

  void _handleLogout() {
    OneSignal.logout();
    OneSignal.User.removeAlias("fb_id");
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.InAppMessages.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, String> triggers = new Map<String, String>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.InAppMessages.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.InAppMessages.removeTrigger("trigger_2");

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.InAppMessages.removeTriggers(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.InAppMessages.paused(true);
    var arePaused = await OneSignal.InAppMessages.arePaused();
    print('Notifications paused ${arePaused}');
  }

  oneSignalOutcomeExamples() async {
    OneSignal.Session.addOutcome("normal_1");
    OneSignal.Session.addOutcome("normal_2");

    OneSignal.Session.addUniqueOutcome("unique_1");
    OneSignal.Session.addUniqueOutcome("unique_2");

    OneSignal.Session.addOutcomeWithValue("value_1", 3.2);
    OneSignal.Session.addOutcomeWithValue("value_2", 3.9);
  }

  void _handleOptIn() {
    OneSignal.User.pushSubscription.optIn();
  }

  void _handleOptOut() {
    OneSignal.User.pushSubscription.optOut();
  }
  String username = PreferencesManager.instance.getUserName();



  //  Location location = Location();

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

