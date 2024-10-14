import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //not state at all = not changed , stateless is lightweight widget, no need update
  const MyApp({super.key}); //constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // first we draw the ui
    return MaterialApp(
      //a widget
      title: 'My APP',
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My APP'),
          backgroundColor: Colors.yellow,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: <Widget>[
              const Text("Hello World"),
              const Text("Hello Flutter"),
              const Text("I love Flutter!"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Text("Row 1"),
                  //Text("Row 2"),
                  //Text("Row 3"),
                  //Text("Row 4"),
                  IconButton(onPressed: () {}, icon:const Icon(Icons.home)),
                ],
              )
            ],
          )
        ), 
      ),  
    );
  }
}

class MyHomePage extends StatefulWidget {
  //state, need update ui
  const MyHomePage({super.key, required this.title}); //required title

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//private class
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HELLO APP"),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Text("Welcome to Flutter"),
              const Text("Flutter is easy"),
              const Text("Flutter is fun"),
              MaterialButton(onPressed: () {}, child: const Text("Click Me"))
            ],
          ),
        ));
  }
}
