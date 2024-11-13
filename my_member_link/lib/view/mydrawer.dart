import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            title: const Text("Event"),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Members"),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Payment"),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Product"),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Vetting"),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Setting"),
          ),
        ],
      ),
    );
  }
}
