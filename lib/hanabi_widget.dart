import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'EventItem.dart';

class HanabiWidget extends StatelessWidget {
  final String Date;
  final String Place;
  final String Title;
  final String Music;
  final String MusicURL;
  final String StoryURL;
  final String StartTime;
  final DateTime timestamp;

  HanabiWidget(this.Date, this.Title, this.Place, this.Music, this.MusicURL, this.StoryURL, this.timestamp, this.StartTime );
  //Future<void>? _launched;
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 1, top: 2, right: 1, bottom: 2),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          blurRadius: 2.0,
                          offset: Offset(0, 1.0))
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: MaterialButton(
                    disabledTextColor: Colors.black87,
                    padding: EdgeInsets.only(left: 18, top:10, bottom:10),
                    onPressed:  () {
                    //_testRef.update({'price': 2.99});
                    // _testRef.set({'description': 'Vanilla latte', 'price': 4.99});
                    //_testRef.set({"Helloworld! ${Random().nextInt(100)}");
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventItem(Date:this.Date, Title:this.Title, Place:this.Place, Music:this.Music, MusicURL:this.MusicURL, StoryURL:this.StoryURL, timestamp:this.timestamp, StartTime:this.StartTime )),
                    );},
                    child: Wrap(
                      children: <Widget>[
                        Container(
                          child:
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(" 花火タイトル：" + Title +"\n 日付：" + Date + "\n 時間：" + StartTime + "\n 場所：" + Place + "\n 音楽：" + Music),
                                      Row(
                                        children:[Text(" ファイル名："),
                                          Flexible(
                                              child:
                                                GestureDetector(
                                                  onTap: () => _launchInBrowser(MusicURL), // call the _launchURL here
                                                  child: Text(MusicURL, style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)
                                              ),
                                          )
                                        ]
                                      ),
                                    Row(
                                          children:[Text(" StoryURL："),
                                           // Flexible(child: Text(StoryURL, style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)),
                                            Flexible(
                                              child:
                                            GestureDetector(
                                                onTap: () => _launchInBrowser(StoryURL), // call the _launchURL here
                                                child: Text(StoryURL, overflow: TextOverflow.ellipsis,style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline),)
                                            ),)
                                          ]
                                      )
                                    ]
                                ),

                        )
                      ],
                    )
                ),)
            ]
     ),
    ) ;
  }
}