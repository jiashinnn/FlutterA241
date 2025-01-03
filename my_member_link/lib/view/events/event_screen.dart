import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/models/event.dart';
import 'package:my_member_link/view/events/edit_event.dart';
import 'package:my_member_link/view/events/new_event.dart';
import 'package:my_member_link/view/shared/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<Event> eventsList = [];
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEventsData();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          IconButton(
              onPressed: () {
                loadEventsData();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: eventsList.isEmpty
          ? Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          : GridView.count(
              childAspectRatio: 0.75,
              crossAxisCount: 2,
              children: List.generate(eventsList.length, (index) {
                return Card(
                  color: Colors.blue[100],
                  child: InkWell(
                    splashColor: Colors.red,
                    onTap: () {
                      showEventDetailsDialog(index);
                    },
                    onLongPress: () {
                      deleteDialog(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                      child: Column(
                        children: [
                          Text(
                            eventsList[index].eventTitle.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            child: Image.network(
                                errorBuilder: (context, error, stackTrace) =>
                                    SizedBox(
                                      width: screenWidth/2,
                                      height: screenHeight/6,
                                      child: Image.asset(
                                          "assets/images/na.png"),
                                    ),
                                width: screenWidth / 2,
                                height: screenHeight / 6,
                                fit: BoxFit.cover,
                                scale: 3.0,
                                "${Myconfig.servername}/memberlink/assets/events/${eventsList[index].eventFilename}"),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              eventsList[index].eventType.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(df.format(DateTime.parse(
                              eventsList[index].eventDate.toString()))),
                          Text(truncateString(
                              eventsList[index].eventDescription.toString(),
                              45)),
                        ],
                      ),
                    ),
                  ),
                );
              })),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => const NewEventScreen()));
          },
          child: const Icon(Icons.add)),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadEventsData() {
    http
        .get(Uri.parse("${Myconfig.servername}/memberlink/api/load_events.php"))
        .then((response) {
      //log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['events'];
          eventsList.clear();
          for (var item in result) {
            Event events = Event.fromJson(item);
            eventsList.add(events);
          }
          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }

  void showEventDetailsDialog(int index) {
    showDialog(
        context: context, // ui current context
        builder: (context) {
          return AlertDialog(
            title: Text(eventsList[index].eventTitle.toString()),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                      errorBuilder: (contect, error, stackTrace) => Image.asset(
                            "assets/images/na.png",
                          ),
                      width: screenWidth / 2,
                      height: screenHeight / 6,
                      fit: BoxFit.cover,
                      scale: 4,
                      "${Myconfig.servername}/memberlink/assets/events/${eventsList[index].eventFilename}"),
                  Text(
                    eventsList[index].eventType.toString(),
                  ),
                  Text(df.format(
                      DateTime.parse(eventsList[index].eventDate.toString()))),
                  Text(
                    eventsList[index].eventLocation.toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    eventsList[index].eventDescription.toString(),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Event event = eventsList[index];
                  // print(event.eventId.toString());
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              EditEventScreen(myevent: event)));
                  loadEventsData();
                },
                child: const Text("Edit Event"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"))
            ],
          );
        });
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                "Delete \"${truncateString(eventsList[index].eventTitle.toString(), 20)}\"",
                style: const TextStyle(fontSize: 18),
              ),
              content:
                  const Text("Are you sure you want to delete this event?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    deleteNews(index);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes"),
                )
              ]);
        });
  }

  void deleteNews(int index) {
    http.post(
        Uri.parse("${Myconfig.servername}/memberlink/api/delete_event.php"),
        body: {
          "eventid": eventsList[index].eventId.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          loadEventsData(); //reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
