import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text("MAIN SCREEN"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("Drawer Header"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Newsletter"),
                leading: const Icon(Icons.newspaper),
              ),
              ListTile(
                onTap: () {},
                title: Text("Event"),
              ),
              ListTile(
                onTap: () {},
                title: Text("Members"),
              ),
              ListTile(
                onTap: () {},
                title: Text("Vetting"),
              ),
              ListTile(
                onTap: () {},
                title: Text("Payment"),
              ),
              ListTile(
                onTap: () {},
                title: Text("Product"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showNewDialog();
          },
          child: const Icon(Icons.add),
        ));
  }

  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: const Text(
              "New Newsletter",
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titlecontroller,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "News Title"),
                  ),
                  const SizedBox(
                    height: 10,
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
                  
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){ }, child: const Text("Submit")),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Cancel")),
            ],
          );
        });
  }
}
