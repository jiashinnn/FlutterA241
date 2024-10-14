import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
  
//   @override
  // State<StatefulWidget> createState() => _SplashScreenState();
//   }


// class _SplashScreenState extends  State<SplashScreen> {
//   Widget Build (BuildContext context) {
//     return 
 // }
//}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController num1EditingController =
      TextEditingController(); //name can change
  TextEditingController num2EditingController = TextEditingController();

  int result = 0;
  //String name = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Basic IO",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Basic IO"),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              shadowColor: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                        controller: num1EditingController, //can change
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Enter First Number"),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        )),
                    const SizedBox(
                      height: 16,
                    ),

                    TextField(
                        controller: num2EditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Enter Second Number"),
                          border: OutlineInputBorder(),
                        )),
                    const SizedBox(height: 10),
                    const Divider(height: 4, color: Colors.red, thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: calculateMe,
                            child: const Text('Calculate')),
                        ElevatedButton(
                            onPressed: clearScreen, child: const Text('Clear')),
                      ],
                    ),
                    Text(
                      "OUTPUT: $result",
                      style: const TextStyle(fontSize: 20),
                    ), //show output, call variable use $
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  calculateMe() {
    int num1 = int.parse(num1EditingController.text);
    int num2 = int.parse(num2EditingController.text);
    result = num1 + num2;
    //print(result);
    setState(() {});
  }

  void clearScreen() {
    num1EditingController.text = "";
    num2EditingController.text = "";
    result = 0;
    setState(() {});
  }
}
