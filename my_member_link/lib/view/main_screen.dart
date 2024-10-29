import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
            const ListTile(
              title: Text("Event"),
            ),
            const ListTile(
              title: Text("Members"),
            ),
            const ListTile(
              title: Text("Vetting"),
            ),
            const ListTile(
              title: Text("Payment"),
            ),
            const ListTile(
              title: Text("Product"),
            ),
          ],
        ),
      ),
    );
  }
}
