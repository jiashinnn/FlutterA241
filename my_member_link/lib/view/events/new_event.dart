import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventState();
}

class _NewEventState extends State<NewEventScreen> {
  var startDateTime, endDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Form(
              child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Event Title"),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        const Text("Select Start Date"),
                        Text(startDateTime ?? const Text(" No Date Selected")),
                      ],
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectTime) {
                            if (selectTime != null) {
                              DateTime selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectTime.hour,
                                  selectTime.minute);
                              var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                              String formattedDate =
                                  formatter.format(selectedDateTime);
                              startDateTime = formattedDate.toString();
                              print(startDateTime);
                              setState(() {
                                
                              });
                            }
                          });
                        }
                      });
                    },
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        const Text("Select End Date"),
                        Text(endDateTime ?? const Text(" No Date Selected")),
                      ],
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((selectTime) {
                            if (selectTime != null) {
                              DateTime selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectTime.hour,
                                  selectTime.minute);
                              var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                              String formattedDate =
                                  formatter.format(selectedDateTime);
                              endDateTime = formattedDate.toString();
                              print(endDateTime);
                              setState(() {
                                
                              });
                            }
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
