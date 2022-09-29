

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fireworks/Tools.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class host extends StatelessWidget{

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
        body:  const MyStatefulWidget(),
      /*Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        //margin: EdgeInsets.fromLTRB(50, 30, 20, 20),
          height: 400.0,
          color: Colors.blueAccent,
          ),*/
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var db = FirebaseDatabase.instance.reference().child("Event").orderByChild("time",);

  DatabaseReference _database = FirebaseDatabase.instance.reference().child("Event");

  _ProfileData _data = _ProfileData();
  _HanabiData  _hdata = _HanabiData(StoryURL: '', Place: '', MusicURL: '', Music: '', Date: '',time: '');
  List<_HanabiDataSet> HanabiDataSetList = [];

  var _labelText = 'Select Date';
  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (selected != null) {
      setState(() {
        _labelText = (DateFormat.yMMMd()).format(selected);
        _data.date = _labelText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
        Column(
          children: <Widget>[
          Form(
              key: _formKey,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SpaceBox.height(25),
                    Row(
                      children:[
                        Text(
                          "Date：",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          _labelText,
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () => _selectDate(context),
                        ),]),
                    SpaceBox.height(25),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '場所',
                        hintText: '例) 津乃峰山',

                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;

                      },
                      onSaved: (String? value) {
                        this._data.place = value!;
                      },
                    ),
                    SpaceBox.height(25),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '音楽タイトル',
                        hintText: '例) オリジナル音楽',

                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;

                      },
                      onSaved: (String? value) {
                        this._data.music = value!;
                      },
                    ),
                    SpaceBox.height(25),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '音楽ファイル名',
                        hintText: '音楽ファイル名を入力してください',

                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;

                      },
                      onSaved: (String? value) {
                        this._data.music_url = value!;
                      },
                    ),SpaceBox.height(25),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ストーリーダウンロードURL',
                        hintText: 'ダウンロードURLを入力してください',

                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;

                      },
                      onSaved: (String? value) {
                        this._data.story_url = value!;
                      },
                    ),
                    SpaceBox.height(25),
                    ElevatedButton(
                        onPressed: () {
                          //HanabiDataSetList= []
                          HanabiDataSetList = [];

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              //データ送信
                              _database.push().set(_setDataSet(_data));

                              //データ取得
                              //_getHanabiData();

                            }

                          },
                        child: const Text('Submit'),
                      ),
                     // Column(

                     //     children: HanabiDataSetList.map((item) => new Text(item.fancyDescription())).toList()
                     // )
                  ],
              ),

          )
          ,
          //Column( children:HanabiDataSetList.map((item) => new Text(item.fancyDescription())).toList()),
          /*StreamBuilder(
            stream: _database.onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError ) {

                return Expanded(
                  child: Column(
                      children: [Text("test") ,] //children: HanabiDataSetList.map((item) => new Text(item.fancyDescription())).toList()),
                  )
                );
              } else
                return Center(child: Text("No data"));
            },
          ),*/
      ]));
  }
//;

   _setDataSet(data){
      var dataJson = <String, dynamic>{
        'Date':data.date,
        'Place':data.place,
        'Music':data.music,
        'MusicURL':data.music_url,
        'StoryURL':data.story_url,
        'time': (DateTime.now().millisecondsSinceEpoch).toString(),
      };
      return dataJson;
}
  Future<List<_HanabiDataSet>> _getHanabiData() async {


    _database.once().then((snapshot){
      final map_data = new Map<String,dynamic>.from(snapshot.value);

      map_data.entries.forEach( (item) {
        _hdata = _HanabiData.fromRTDB(item.value);
        _HanabiDataSet _hdset = _HanabiDataSet(key: item.key, hdata:_hdata);
        HanabiDataSetList.add(_hdset);
      });


    }

    );
    print(HanabiDataSetList);
    return HanabiDataSetList;
  }




}

class _HanabiDataSet{
  final String key;
  final _HanabiData hdata;

  _HanabiDataSet({required this.key, required this.hdata });

  String fancyDescription(){
    return '$key:' + hdata.fancyDescription();
  }
}

class _HanabiData{
  final String Date;
  final String Place;
  final String Music;
  final String MusicURL;
  final String StoryURL;
  final String time;

  _HanabiData({ required this.Date, required this.Place, required this.Music, required this.MusicURL, required this.StoryURL, required this.time});

  factory _HanabiData.fromRTDB(data){
    return _HanabiData(
      Date:data['Date'] ?? 'not decided',
      Place:data['Place'] ?? 'not decided',
      Music:data['Music'] ?? 'not decided',
      MusicURL:data['MusicURL'] ?? 'not decided',
      StoryURL:data['StoryURL'] ?? 'not decided',
      time:data['time'] ?? 'not decided',
    );
  }
  String fancyDescription(){
    return '$Date $Place $Music $MusicURL $StoryURL $time';
  }
}
class _ProfileData {
  String date = '';
  String place = '';
  String music = '0';
  String music_url = '0';
  String story_url = '0';
  String time = '0';
}
