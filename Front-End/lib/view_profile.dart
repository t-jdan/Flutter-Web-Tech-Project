import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  TextEditingController emailController = TextEditingController();

  late Map<String, dynamic> userData = {};

  Future<void> getUserData(String email) async {
    final response = await http.get(
      Uri.parse(
          'https://us-central1-rest-api-lab-5942e.cloudfunctions.net/profile?email=$email'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
      });
    } else {
      setState(() {
        userData;
      });
      throw Exception('Failed to retrieve user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await getUserData(emailController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to retrieve user data'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
            if (userData.isNotEmpty) ...[
              Text("Name: ${userData['name']}"),
              Text("Student ID: ${userData['id']}"),
              Text("Date of Birth: ${userData['dob']}"),
              Text("Year Group: ${userData['yeargroup']}"),
              Text("Major: ${userData['major']}"),
              Text("Campus Residence: ${userData['CampusResidence']}"),
              Text("Favourite Food: ${userData['FavouriteFood']}"),
              Text("Favourite Movie: ${userData['FavouriteMovie']}"),
            ],
          ],
        ),
      ),
    );
  }
}
