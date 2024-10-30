import 'package:flutter/material.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Newsletter"),
        ),
        body: SingleChildScrollView(
            child: Padding(
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
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "News Details"),
              maxLines: 14,
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
        )));
  }

  void onInsertNewsDialog() {}
}
