import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Newsletter"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "News Title"),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: screenHeight * 0.65,
              child: TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "News Details"),
                maxLines: screenHeight ~/ 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              elevation: 10,
              onPressed: onInsertNewsDialog,
              minWidth: 400,
              height: 50,
              color: Colors.purple[800],
              child: const Text(
                "Insert",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
        ));
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register this newsletter?",
              style: TextStyle(),
            ),
            content: const Text(
              "Are you sure?",
              style: TextStyle(),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  insertNews();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text("Registration Canceled"),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                },
              ),
            ],
          );
        });
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(
        Uri.parse("${Myconfig.servername}/memberlink/api/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));

          titleController.text = "";
          detailsController.text = "";
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
