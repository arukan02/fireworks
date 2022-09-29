//import 'dart:collection';

import 'hanabi_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/Hanabi.dart';
import 'data/hanabi_event.dart';
import 'data/hanabi_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fireworks/Tools.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HanabiListState extends State<HanabiList> {
  ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Hanabi_event _data = Hanabi_event();

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
        _labelText = (DateFormat.yMMMd('ja')).format(selected).toString();
        //_labelText = (DateFormat.yMMMd()).format(selected).toString();
        _data.Date = _labelText ;
      });
    }
  }
 /* void _sendMessage() {
    if (_canSendMessage()) {
      final message = Hanabi(_messageController.text, DateTime.now());
      widget.hanabiDao.saveMessage(message);
      _messageController.clear();
      setState(() {});
    }
  }*/
  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    initializeDateFormatting('ja');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      body: Container(

       child:Padding(
        padding: EdgeInsets.all(0), //(16.0),

        child: Column(

          children:[
          _getHanabiList(),
            Form(
              key: _formKey,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                              SpaceBox.height(5),
                              Row(
                                  children:[
                                    Text(
                                      "Date：",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      _labelText,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.date_range),
                                      onPressed: () => _selectDate(context),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: '開始時刻',
                                        hintText: '例) 21:00',
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        this._data.StartTime = value!;
                                      },
                                    ),]),
                              Column(
                                children:[
                                          TextFormField(
                                                decoration: const InputDecoration(
                                                  labelText: '開始時刻',
                                                  hintText: '例) 21:00',
                                                ),
                                                validator: (String? value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String? value) {
                                                  this._data.StartTime = value!;
                                                },
                                          ),
                                          SpaceBox.height(5),
                                          TextFormField(
                                decoration: const InputDecoration(
                                  labelText: '花火タイトル',
                                  hintText: '例) 花火タイトル',

                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;

                                },
                                onSaved: (String? value) {
                                  this._data.Title = value!;
                                },
                              ),
                                          SpaceBox.height(5),
                              ]),
                              /*SpaceBox.height(5),
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
                                  this._data.Place = value!;
                                },
                              ),
                              SpaceBox.height(5),
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
                                  this._data.Music = value!;
                                },
                              ),
                              SpaceBox.height(5),
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
                                  this._data.MusicURL = value!;
                                },
                              ),
                              SpaceBox.height(5),
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
                                  this._data.StoryURL = value!;
                                },
                              ),
                              SpaceBox.height(5),*/
                              ElevatedButton(
                                onPressed: () {
                                  //HanabiDataSetList= []

                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    //データ送信
                                    print("send");
                                    _sendMessage();


                                    //データ取得
                                    //_getHanabiData();
                                  }
                                },
                                child: const Text('Submit'),
                              ),
              ],
          ),
        )
            ]
        ),
      ),
    ))
    ;

  }

 // bool _canSendMessage() => _messageController.text.length > 0;
  void _sendMessage() {
    print("in the sendMessage");
    if (_formKey.currentState!.validate()) {
      print("in the if");
      _formKey.currentState!.save();
      print("Saved");
      print(_data.Date);
      print(_data.Place);
      print(_data.Title);
      print(_data.Music);
      print(_data.MusicURL);
      print(_data.StoryURL);
      print(_data.timestamp);
      print(_data.StartTime);

      final Hanabi hbi = Hanabi(_data.Date,  _data.Title, _data.Place, _data.Music, _data.MusicURL, _data.StoryURL, _data.timestamp, _data.StartTime,);
     // final message = Message(_messageController.text, DateTime.now())
      print(hbi.StartTime);
      widget.hanabiDao.saveMessage(hbi);
      setState(() {});
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Widget _getHanabiList() {
    return Expanded(

      child: Container(
        color:Colors.black12,
        child: FirebaseAnimatedList(

          controller: _scrollController,
          query: widget.hanabiDao.getMessageQuery(),
          itemBuilder: (context, snapshot, animation, index) {
            final json = snapshot.value as Map<dynamic, dynamic>;
            print(json);
            //var list = json.values.toList();


            final hanabi = Hanabi.fromJson(json);
            return HanabiWidget(hanabi.Date, hanabi.Title, hanabi.Place, hanabi.Music, hanabi.MusicURL, hanabi.StoryURL, hanabi.timestamp, hanabi.StartTime );
          },
        ),
    ));
  }

}

class HanabiList extends StatefulWidget {
  HanabiList({Key? key}) : super(key: key);

  final hanabiDao = HanabiDao();

  @override
  HanabiListState createState() => HanabiListState();
}
