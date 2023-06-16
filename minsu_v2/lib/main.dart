import 'package:flutter/material.dart';
import 'package:minsu_v2/sign.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Driver Assistant MINSU',
      theme: ThemeData( primarySwatch: Colors.blue,),
      // theme: ThemeData.light(useMaterial3: true).copyWith(
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Colors.deepPurpleAccent,
      //   ),
      // ),
      home: NameScreen(),
    );
  }
}
