//import 'dart:collection';

import 'hanabi_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/Hanabi.dart';
import 'data/hanabi_event.dart';
import 'data/hanabi_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class audience01HanabiListState extends State<audience01> {
  ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Hanabi_event _data = Hanabi_event();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

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

                ]
            ),
          ),
        ))
    ;

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

class audience01 extends StatefulWidget {
  audience01({Key? key}) : super(key: key);

  final hanabiDao = HanabiDao();

  @override
  audience01HanabiListState createState() => audience01HanabiListState();
}

