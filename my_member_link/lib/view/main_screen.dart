import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_member_link/models/news.dart';
import 'package:my_member_link/view/new_news.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: newsList.isEmpty
            ? const Center(
              child: Text("Loading..."),
            ):ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(newsList[index].newsTitle.toString()),
                  subtitle: Text(newsList[index].newsDetails.toString()),
                  
                )
              );
            }),
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
                title: const Text("Event"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Members"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Vetting"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Payment"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Product"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            
            await Navigator.push(context,
            MaterialPageRoute(builder: (content) => const NewNewsScreen()));
            loadNewsData();
          },
          child: const Icon(Icons.add),
        ));
  }

  void loadNewsData() {
    http
        .get(Uri.parse("${Myconfig.servername}/memberlink/api/load_news.php"))
        .then((response) {
      //log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
            print(news.newsTitle);
          }
          setState(() {});
        } else {
          print("Error");
        }
      }
    });
  }
}
