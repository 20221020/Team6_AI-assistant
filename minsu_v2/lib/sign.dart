import 'package:flutter/material.dart';
import 'package:minsu_v2/home_page.dart';
import 'package:minsu_v2/main.dart';
import 'package:minsu_v2/camera.dart';

class NameScreen extends StatefulWidget {
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController nameController = TextEditingController();

  void navigateToHomeScreen() {
    final String name = nameController.text;
    if (name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(name: name),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('AI Driving Assistant MINSU'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: navigateToHomeScreen,
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}