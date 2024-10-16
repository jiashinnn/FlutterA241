import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  )
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  late PageController _pageController;

  void _onScroll() {
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    )..addListener(_onScroll);

    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          makePage(image: 'assets/images/one.jpg'),
          makePage(image: 'assets/images/two.jpg'),
          makePage(image: 'assets/images/three.jpg'),
          makePage(image: 'assets/images/four.jpg'),
        ],
      )
    );
  }

  Widget makePage({image}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            stops: const [0.3, 0.9],
            colors: [
              Colors.black.withOpacity(.9),
              Colors.black.withOpacity(.2),
            ])
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            //Row(children: [],)
          ),
          )
      )
    );
  }
}





