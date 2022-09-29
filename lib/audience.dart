
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fireworks/Tools.dart';
import 'package:firebase_storage/firebase_storage.dart';

class audience extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
          title: Text("花火シンクロ"),
          backgroundColor: Colors.black,
        ),
        body:  Container(
            //height: 500.0,
            //color: Colors.orange,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                          height: 50.0,
                          color: Colors.orange,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                          Text('本日の花火',
                          style: TextStyle(fontSize: 18)),
                          //Text('主催者として',
                          //    style: TextStyle(fontSize: 18)),
                          ] ,
                        )),

                   Container(
                          height: 200.0,
                          color: Colors.blueAccent,
                          child:Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children:[
                              SpaceBox.width(50),
                              Container(
                                  //width:200.0,
                                  color: Colors.greenAccent,

                                  child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        SpaceBox.height(20),
                                        Text('花火A：',
                                          style: TextStyle(fontSize: 18)),
                                        SpaceBox.height(20),
                                        Text('時間：',
                                        style: TextStyle(fontSize: 18)),
                                        SpaceBox.height(20),
                                        Text('場所：',
                                            style: TextStyle(fontSize: 18)),
                                        SpaceBox.height(20),
                                        Text('使用曲：',
                                            style: TextStyle(fontSize: 18))
                              ]))
                              ,
                              Expanded(
                                  child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        SpaceBox.height(20),
                                        Text('花火タイトル',
                                            style: TextStyle(fontSize: 18)),
                                        SpaceBox.height(25),
                                        Text('19:00-20:00',
                                            style: TextStyle(fontSize: 18)),
                                        SpaceBox.height(20),
                                        Text('津野峰山',
                                            style: TextStyle(fontSize: 18)),
                                        SpaceBox.height(20),
                                        Text('未ダウンロード',
                                            style: TextStyle(fontSize: 18))
                                      ]))
                            ] ,
                          )),
                  Container(
                          height: 50.0,
                          color: Colors.orange,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Text('近日の花火',
                                  style: TextStyle(fontSize: 18)),
                              //Text('3',
                               //   style: TextStyle(fontSize: 18)),
                            ] ,
                          )),
                  Expanded(
                      child:Container(
                          height: 600.0,
                          color: Colors.indigo,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Text('4',
                                  style: TextStyle(fontSize: 18)),
                              Text('5',
                                  style: TextStyle(fontSize: 18))
                            ] ,
                          )))
                ])
        )
    );
  }
}


/* class MediaTemp extends StatefulWidget {
  const MediaTemp({Key? key}) : super(key: key);

  @override
  _MediaTempState createState() => _MediaTempState();
}

class _MediaTempState extends State<MediaTemp> {
  @override
  late Text _text;
  Future<void> _download() async {
    // ログイン処理
   // await FirebaseAuth.instance.signInWithEmailAndPassword(
   //     email: "test@test.com", password: "testtest");

    // ファイルのダウンロード
    // テキスト
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference textRef = storage.ref().child("music").child("test.txt");
    //Reference ref = storage.ref("DL/hello.txt"); // refで一度に書いてもOK

    var data = await textRef.getData();

    // 画像
    //Reference imageRef = storage.ref().child("DL").child("icon.png");
    //String imageUrl = await imageRef.getDownloadURL();

    // 画面に反映
    setState(() {
      //_img = Image.network(imageUrl);
      _text = Text(ascii.decode(data!));
    });

  }

  Widget build(BuildContext context) {
    return Container(
      child:Row(
        children:[ if (_text != null) _text, ]
      )
    );
  }
}*/
