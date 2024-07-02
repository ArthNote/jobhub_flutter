import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/pages/first.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAjIQsfCChXq_TLkCMmert-_0IksWYf9Z4",
      appId: "1:696408770912:android:64af976bfffb24b5157605",
      messagingSenderId: "696408770912",
      projectId: "jobhubflutter",
    )
  );

  /*if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDdcHxBbBthb05K9OVPGvb5eicV-cYf9JI",
        appId: "1:696408770912:web:22ac33db7811e960157605",
        messagingSenderId: "696408770912",
        projectId: "jobhubflutter",
      )
    );
  }*/

  runApp(MyApp());
}
 Color light_blue = const Color.fromARGB(255, 1, 104, 230);
class MyApp extends StatelessWidget {
  MyApp({super.key});                                                                                                                                            
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JobHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: light_blue),
        useMaterial3: false,
        dividerColor: dark_blue,
        scaffoldBackgroundColor: const Color(0xFFF3F6FD),
      ),
      home: MainPage(),
    );
  }
}
