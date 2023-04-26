import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}

class EditPage extends StatelessWidget {
  final String apiUrl =
      "https://us-central1-rest-api-lab-5942e.cloudfunctions.net/profile";

  final String emailFieldName = "email";
  final String dobFieldName = "dob";
  final String yearFieldName = "yeargroup";
  final String majorFieldName = "major";
  final String residenceFieldName = "CampusResidence";
  final String foodFieldName = "FavouriteFood";
  final String movieFieldName = "FavouriteMovie";

  final _formKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController foodController = TextEditingController();
  TextEditingController movieController = TextEditingController();

  Future<void> submitForm(BuildContext context) async {
    print("First Step");
    if (_formKey.currentState!.validate()) {
      // Encode the input as JSON
      Map data = {
        emailFieldName: emailController.text,
        dobFieldName: dobController.text,
        yearFieldName: yearController.text,
        majorFieldName: majorController.text,
        residenceFieldName: residenceController.text,
        foodFieldName: foodController.text,
        movieFieldName: movieController.text,
      };
      String encodedData = json.encode(data);

      try {
        var response = await http.put(Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'}, body: encodedData);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile Updated!')),
          );
          _formKey.currentState!.reset();
        } else if (response.statusCode == 404) {
          throw HttpException(response.body);
        }
      } catch (e) {
        if (e is HttpException) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Conflict Error'),
              content: Text(e.message),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your email";
                }
                return null;
              },
            ),
            TextFormField(
              controller: dobController,
              decoration: InputDecoration(labelText: "Date of Birth"),
            ),
            TextFormField(
              controller: yearController,
              decoration: InputDecoration(labelText: "Year Group"),
            ),
            TextFormField(
              controller: majorController,
              decoration: InputDecoration(labelText: "Major"),
            ),
            TextFormField(
              controller: residenceController,
              decoration:
                  InputDecoration(labelText: "Do you have Campus Residence?"),
            ),
            TextFormField(
              controller: foodController,
              decoration: InputDecoration(labelText: "Best Food"),
            ),
            TextFormField(
              controller: movieController,
              decoration: InputDecoration(labelText: "Best Movie"),
            ),
            ElevatedButton(
              onPressed: () {
                submitForm(context);
              },
              style: ButtonStyle(),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
