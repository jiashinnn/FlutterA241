import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/models/event.dart';
import 'package:my_member_link/myconfig.dart';

class EditEventScreen extends StatefulWidget {
  final Event myevent;
  const EditEventScreen({super.key, required this.myevent}); //34.47

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  String startDateTime = "", endDateTime = "";
  String eventtypetvalue = 'Conference';
  var selectedStartDateTime, selectedEndDateTime;

  var items = ['Conference', 'Exhibition', 'Seminar', 'Hackathon'];
  late double screenWidth, screenHeight;

  File? _image;

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showSelectionDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: _image == null
                                ? const AssetImage("assets/images/gallery.png")
                                : FileImage(_image!) as ImageProvider,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(41, 107, 107, 107),
                          border: Border.all(
                              color: const Color.fromARGB(200, 128, 127, 127))),
                      height: screenHeight * 0.3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? "Enter Title" : null,
                    controller: titleController,
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
                            Text(startDateTime),
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
                                  selectedStartDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectTime.hour,
                                      selectTime.minute);

                                  var formatter =
                                      DateFormat('dd-MM-yyyy hh:mm a');
                                  String formattedDate =
                                      formatter.format(selectedStartDateTime);
                                  startDateTime = formattedDate.toString();
                                  //print(startDateTime);
                                  setState(() {});
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
                            Text(endDateTime),
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
                                  selectedEndDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectTime.hour,
                                      selectTime.minute);
                                  var formatter =
                                      DateFormat('dd-MM-yyyy hh:mm a');
                                  String formattedDate =
                                      formatter.format(selectedEndDateTime);
                                  endDateTime = formattedDate.toString();
                                  //print(endDateTime);
                                  setState(() {});
                                }
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Enter Location" : null,
                    controller: locationController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: "Event Location"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelStyle: TextStyle(),
                    ),
                    value: eventtypetvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        eventtypetvalue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enter Description" : null,
                      controller: descriptionController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: "Event Description")),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    elevation: 10,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        print("STILL HERE");
                        return;
                      }
                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please take a photo"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      double filesize = getFileSize(_image!);
                      print(filesize);

                      if (filesize > 100) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Image size too large"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (startDateTime == "" || endDateTime == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select start/end date"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      insertEventDialog();
                    },
                    minWidth: screenWidth,
                    height: 50,
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      "Insert",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ]),
      ),
    );
  }

  void showSelectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                "Select from",
                style: TextStyle(),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).pop(),
                      _selectfromGallery(),
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                    child: const Text("Gallery"),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: () => {
                            Navigator.of(context).pop(),
                            _selectfromCamera(),
                          },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(screenWidth / 4, screenHeight / 8)),
                      child: const Text("Camera")),
                ],
              ));
        });
  }

  Future<void> _selectfromCamera() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        // Prevent processing if there's already an image
        if (_image == null) {
          _image = File(pickedFile.path);
          await cropImage();
        } else {
          print("Image already selected, ignoring subsequent selection.");
        }
      } else {
        print("No image selected from camera.");
      }
    } catch (e) {
      print("Error selecting image from camera: $e");
    }
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        // Prevent processing if there's already an image
        if (_image == null) {
          _image = File(pickedFile.path);
          await cropImage();
        } else {
          print("Image already selected, ignoring subsequent selection.");
        }
      } else {
        print("No image selected from gallery.");
      }
    } catch (e) {
      print("Error selecting image from gallery: $e");
    }
  }

  Future<void> cropImage() async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Please Crop Your Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Please Crop Your Image',
          ),
        ],
      );

      if (croppedFile != null) {
        _image = File(croppedFile.path);
        setState(() {}); // Trigger UI update after cropping
      } else {
        print("Image cropping canceled.");
      }
    } catch (e) {
      print("Error during image cropping: $e");
    }
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInKB = sizeInBytes / (1024 * 1024) * 1000;
    return sizeInKB;
  }

  void insertEventDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Insert Event",
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
                  insertEvent();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          );
        });
  }

  void insertEvent() {
    String title = titleController.text;
    String location = locationController.text;
    String description = descriptionController.text;
    String start = selectedStartDateTime.toString();
    String end = selectedEndDateTime.toString();
    String image = base64Encode(_image!.readAsBytesSync());
    //log(image);
    http.post(
        Uri.parse("${Myconfig.servername}/memberlink/api/insert_event.php"),
        body: {
          "title": title,
          "location": location,
          "description": description,
          "eventtype": eventtypetvalue,
          "start": start,
          "end": end,
          "image": image
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        //log(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
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
