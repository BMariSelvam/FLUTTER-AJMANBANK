import 'dart:convert';
import 'package:ajmanbank/Helper/approute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'Helper/colors.dart';
import 'Helper/encryprionChecking.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  // const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> json = {
      "pagingInfo": {
        "fromDate": "2022-07-17",
        "toDate": "2023-07-17",
        "creditDebit": "C",
        "amountFilter": "01",
        "amount": "",
        "pageNo": "1",
        "requestId": "01",
        "rowsPerPage": "20",
        "fromRecord": "1",
        "recordCount": "3000"
      },
      "userInfoVO": {
        "msgSourceChannelID": "120",
        "vSecureToken": "c90360e7-0c5e-4eba-aa78-1e635b231aa7",
        "reqRefNo": "123123123123",
        "vCorporateId": "GCIFDEV11",
        "vLoginId": "devuserr11",
        "fileReferenceNo": null,
        "vDeviceId": "dd3c6e8aad230d98",
        "requestFlag": "N"
      }
    };
    String jsonString = jsonEncode(json);
    String data = "42442879D1EA5D06AA56F8957262C6516F6A31404D51B530355E4C42AF46EE5F0A9433ADF29CB2836B304B58125AE7368FE69FAB13D1129FF1F9E7C9722D01970153AA313584AEC11800B971E38D37F200CBED7C82860777E8F50B947FB819721EE6C94CBB2E136060B96C0F271E65D2E00D1CFE2650700C06F2D4A8203CC774910A55923209B0E57A4E930437F4BA5445A21E6F493FCB08601E78CA4E36E026058313461D9CA4094138D93B055ACDF19864AFAABA02360C092D898C1E7C7A20660EAD6C0E81F8541E1812728D113C4E09E4EAD2F2EE519E0229F2444B57B4ABAB1674FD6D29ACA958FA63852DDABA88E7C3E757B85F9110D5DC38D7ADEA1D38E5D58F535874D220ED1B9B983A149EE47032EA47C069A421548791B172B0E1E2B607F01C470A55D837271BEE8A0F71392B2E862B46496873C36DC3E1C1531CDB753DCA5DA978B0996671DF680AB3F88E604090E75C1CF3F0604BB122DDFD3647B949788C5A499A1A64C1B722E68A75DF";
    String encrpt = EncrptionClass.getEncryptedString(jsonString);
    String decrypted = DecrptionClass.getDecryptedString(data);
    print("santhosh${decrypted}");
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: MyColors.primaryCustom),
      initialRoute: AppRoute.initialPage,
      getPages: pages,
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginScreen(),
//     );
//   }
// }
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final OtpTimer _otpTimer = OtpTimer();
//
//   @override
//   void initState() {
//     super.initState();
//     _otpTimer.initialize();
//   }
//
//   void startOtpTimer() {
//     _otpTimer.startTimer(duration: 60, onTimerEnd: () {
//       // Handle timer end, e.g., show a resend button
//     });
//   }
//
//   void cancelOtpTimer() {
//     _otpTimer.cancelTimer();
//   }
//
//   @override
//   void dispose() {
//     _otpTimer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Timer Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('OTP Timer:'),
//             ElevatedButton(
//               onPressed: startOtpTimer,
//               child: Text('Start Timer'),
//             ),
//             ElevatedButton(
//               onPressed: cancelOtpTimer,
//               child: Text('Cancel Timer'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class OtpTimer {
//   static const platform = MethodChannel('com.example.otptimer');
//
//   void initialize() {
//     platform.setMethodCallHandler((call) {
//       return Future.value(true);
//     });
//   }
//
//   void startTimer({required int duration, required Function() onTimerEnd}) {
//     platform.invokeMethod('startTimer', {'duration': duration});
//     platform.setMethodCallHandler((call) {
//       if (call.method == 'timerEnd') {
//         onTimerEnd();
//       }
//       return Future.value(true);
//     });
//   }
//
//   void cancelTimer() {
//     platform.invokeMethod('cancelTimer');
//   }
//
//   void dispose() {
//     platform.setMethodCallHandler(null);
//   }
// }
