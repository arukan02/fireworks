

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fireworks/Tools.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class hosttest extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("花火シンクロ"),
          backgroundColor: Colors.black,
        ),
        body:  const MyStatefulWidget(),

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
  var db = FirebaseDatabase.instance.reference().child("test").orderByChild(
    "value",);

  DatabaseReference _database = FirebaseDatabase.instance.reference().child(
      "test");
  List<_DataSet> HanabiDataList = [];

  _Data _data = _Data(value: '', time: '' );
  _DataSet _dset = _DataSet( key: '', hdata: _Data(value: '', time: '' ),  );
  @override
  initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    setState(() {
      _dbAccess();
    });

  }
  _dbAccess(){
    _database.once().then ((snapshot){
      final map_data = new Map<String,dynamic>.from(snapshot.value);
      //print(map_data);
      HanabiDataList = [];
      map_data.entries.forEach( (item) {
        _data = _Data.fromRTDB(item.value);
        _dset = _DataSet(key: item.key, hdata:_data);
        HanabiDataList.add(_dset);
      });
    }


    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
    Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SpaceBox.height(25),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'message',
                    hintText: '例) hello',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    this._data.value = value!;
                  },
                ),

                SpaceBox.height(25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      //データ送信
                      _database.push().set(_setData(_data));
                      //データ取得
                      _getData();
                      //_getHanabiData();
                    }
                  },
                  child: const Text('Submit'),
                ),


                /*StreamBuilder(
                  stream:_database.orderByKey().limitToLast(10).onValue,
                  builder: (context,snapshot){
                        final titlesList = <ListTile>[];
                                      if(snapshot.hasData){
                                          final myOrders = Map<String, dynamic>.from((snapshot.data! as Event).snapshot.value);

                                          myOrders.forEach( (key, value){
                                              final nextOrder = Map<String, dynamic>.from(value);
                                              final orderTile = ListTile(
                                                leading: Icon(Icons.local_cafe),
                                                title: Text (nextOrder['value'])
                                              );

                                              titlesList.add(orderTile);

                                          });
                                    }
                 }

                ),*/
            Column(

                   children: HanabiDataList.map((item) => new Text(item.fancyDescription())).toList()
               )
              ],
            ),

          )
          ,

        ]));
  }

//;
  _setData(data) {
    var dataJson = <String, dynamic>{
      'value': data.value,
      'time': (DateTime
          .now()
          .millisecondsSinceEpoch).toString(),
    };
    return dataJson;
  }
}

/*class _getDataSet(){

}*/
class _DataSet{
  String key;
  _Data hdata;

  _DataSet({required this.key, required this.hdata });

  String fancyDescription(){
    return '$key:' + hdata.fancyDescription();
  }



}

class _Data {
    String value;
    String time;

    _Data({ required this.value, required this.time});

    factory _Data.fromRTDB(data){
      return _Data(
        value:data['value'] ?? 'not decided',
        time:data['time'].toString() ,
      );
    }

    String fancyDescription(){
    return '$value $time';
    }
}