import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePost extends StatelessWidget {
  final String apiUrl =
      "https://us-central1-rest-api-lab-5942e.cloudfunctions.net/post";

  final String emailFieldName = "email";
  final String postFieldName = "post";

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController postController = TextEditingController();

  Future<void> submitForm(BuildContext context) async {
    print("First Step");
    if (_formKey.currentState!.validate()) {
      // Encode the input as JSON
      Map data = {
        emailFieldName: emailController.text,
        postFieldName: postController.text,
      };
      String encodedData = json.encode(data);

      try {
        var response = await http.post(Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'}, body: encodedData);
        print("After response");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post Added')),
          );
          _formKey.currentState!.reset();
          print(response.body);
        } else {
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
                      height: 150,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please input your email";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      width: 250,
                      child: TextFormField(
                        minLines: 3,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: postController,
                        decoration: InputDecoration(
                            labelText: "Type your post here...",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can't be empty";
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
                            'Post',
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
