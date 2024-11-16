import 'package:flutter/material.dart';
import 'package:my_member_link/view/events/event_screen.dart';
import 'package:my_member_link/view/newsletter/main_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
            child: const Text(
              "MyMemberLink", //Drawer Header
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            title: const Text("Newsletters"),
            leading: const Icon(Icons.newspaper),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EventScreen()));
            },
            title: const Text("Events"),
            leading: const Icon(Icons.event),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Members"),
            leading: const Icon(Icons.people),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Payment"),
            leading: const Icon(Icons.payment),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Product"),
            leading: const Icon(Icons.store),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Vetting"),
            leading: const Icon(Icons.verified),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Setting"),
            leading: const Icon(Icons.settings),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
