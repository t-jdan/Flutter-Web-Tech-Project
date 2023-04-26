// ignore_for_file: must_be_immutable

// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConflictException implements Exception {
  final String message;
  ConflictException(this.message);
}

class RegisterPage extends StatelessWidget {
  final String apiUrl =
      "https://us-central1-rest-api-lab-5942e.cloudfunctions.net/profile";

  final String idFieldName = "id";
  final String nameFieldName = "name";
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
        idFieldName: idController.text,
        nameFieldName: nameController.text,
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
        var response = await http.post(Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'}, body: encodedData);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successful!')),
          );
          _formKey.currentState!.reset();
        } else if (response.statusCode == 409) {
          throw ConflictException(response.body);
        } else {
          Text(response.body);
        }

        // Exception Caught
      } catch (e) {
        if (e is ConflictException) {
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
    String emptyField = "";
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  // gradient: LinearGradient(begin: FractionalOffset.bottomLeft)
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: "ID Number",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      // TODO Add stuff to make all the data
                      // be entered the same way
                      width: 250,
                      child: TextFormField(
                        controller: dobController,
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: yearController,
                        decoration: InputDecoration(
                          labelText: "Year Group",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: majorController,
                        decoration: InputDecoration(
                          labelText: "Major",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: residenceController,
                        decoration: InputDecoration(
                          labelText: "Campus Residence?",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: foodController,
                        decoration: InputDecoration(
                          labelText: "Favourite Food",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 250,
                      child: TextFormField(
                        controller: movieController,
                        decoration: InputDecoration(
                          labelText: "Favourite Movie",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            emptyField = "Please fill in all fields";
                            return emptyField;
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        submitForm(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            )));
  }
}
