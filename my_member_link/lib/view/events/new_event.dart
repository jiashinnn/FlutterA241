import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  String startDateTime = "", endDateTime = "";
  String dropdowndefaultvalue = 'Conference';
  var items = ['Conference', 'Exhibition', 'Seminar', 'Hackathon'];
  late double screenWidth, screenHeight;
  TextEditingController descriptionController = TextEditingController();
  File? _image;

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
              child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showSelectionDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
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
                ),
                value: dropdowndefaultvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // setState(() {
                  //   dropdowndefaultvalue = newValue!;
                  // });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
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
                onPressed: () {},
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
                    child: const Text("Gallery"),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth / 4, screenHeight / 8)),
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
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    print("BEFORE CROP: ");

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    print("BEFORE CROP: ");

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> cropImage() async {
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
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      setState(() {});
    }
  }
}
