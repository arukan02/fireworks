import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fireworks/audience01.dart';
import 'package:fireworks/Login.dart';
import 'package:fireworks/hosttest.dart';
import 'package:fireworks/hanabi_list.dart';
import 'package:fireworks/Tools.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //debugPaintSizeEnabled = true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '花火シンクロ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future:_fbApp,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            print('You have an error! ${snapshot.error.toString()}');
            return Text('Something went wrong!');
          }else if (snapshot.hasData){
            return MyHomePage(title: 'Flutter Demo Home Page');
          }else{
            return Center (
              child: CircularProgressIndicator(),
            );
          }
        },
      )
      //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
/*class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}*/

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    //DatabaseReference _testRef = FirebaseDatabase.instance.reference().child("menu");
    return Scaffold(
      appBar: AppBar(
        title: Text("花火シンクロ"),
        backgroundColor: Colors.black,
      ),
      body:  Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              height: 800.0,
              child:Column(
                  children:[
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: ElevatedButton(
                        child: const Text('観客としてアプリを使用する',
                          style:  TextStyle(
                              fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => audience01()),
                          );
                        },
                      ),
                    ),

                    SpaceBox.height(50),

                    SizedBox(
                      width: 300,
                      height: 80,
                      child: ElevatedButton(
                        child: const Text('主催者としてアプリを使用する',
                          style:  TextStyle(
                              fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          //_testRef.update({'price': 2.99});
                           // _testRef.set({'description': 'Vanilla latte', 'price': 4.99});
                          //_testRef.set({"Helloworld! ${Random().nextInt(100)}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login() ), // HanabiList()),
                          );
                        },
                      ),

                    ),
                    SpaceBox.height(50),
                    Container(

                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('協賛企業',
                              style:  TextStyle(
                                  fontSize: 18),
                            ),
                            SpaceBox.height(10),
                            Row(

                                children: [
                                  const Text('企業A',
                                    style:  TextStyle(
                                        fontSize: 18),
                                  ),
                                  SpaceBox.width(20),
                                  const Text('企業B',
                                    style:  TextStyle(
                                        fontSize: 18),
                                  ),
                                  SpaceBox.width(20),
                                  const Text('企業C',
                                    style:  TextStyle(
                                        fontSize: 18),
                                  )
                                ]
                            ),
                            SpaceBox.height(10),
                            Row(

                                children: [
                                  const Text('企業D',
                                    style:  TextStyle(
                                        fontSize: 18),
                                  ),
                                  SpaceBox.width(20),
                                  const Text('企業E',
                                    style:  TextStyle(
                                        fontSize: 18),
                                  ),
                                  SpaceBox.width(20),
                                  const Text('企業F',
                                    style:  TextStyle(
                                        fontSize: 18),
                                  )
                                ]
                            )
                          ]
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _incrementCounter,
      //  tooltip: 'Increment',
      //  child: Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
