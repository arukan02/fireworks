import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fireworks/Tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/meta_data_section.dart';
import 'widgets/play_pause_button_bar.dart';
import 'widgets/volume_slider.dart';
import 'package:ntp/ntp.dart';

typedef OnError = void Function(Exception exception);

class EventItem extends StatelessWidget{
  // 以下を実装、受け渡し用のプロパティを定義

  final String Date;
  final String Place;
  final String Title;
  final String Music;
  final String MusicURL;
  final String StoryURL;
  final String StartTime;
  final DateTime timestamp;
  // 以下を実装、コンストラクタで値を受領
  EventItem({required this.Date, required this.Title, required this.Place, required this.Music, required this.MusicURL, required this.StoryURL, required this.timestamp, required this.StartTime});


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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
          title: Text("花火情報"),
          backgroundColor: Colors.black,
        ),
        body:  Container(
            //height: 500.0,
            //color: Colors.orange,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Container(
                          height: 30.0,
                          color: Colors.black,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                          Text('花火情報',
                          style: TextStyle(fontSize: 16,color:Colors.white)),
                          //Text('主催者として',
                          //    style: TextStyle(fontSize: 18)),
                          ] ,
                        )),
                  */
                   Container(
                          height: 150.0,
                          color: Colors.black,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children:[
                              SpaceBox.width(50),
                              Container(
                                  //width:200.0,
                                  color: Colors.black,

                                  child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        SpaceBox.height(10),
                                        Text('タイトル：',
                                          style: TextStyle(fontSize: 16,color:Colors.white)),
                                        SpaceBox.height(5),
                                        Text('開始日時：',
                                        style: TextStyle(fontSize: 16,color:Colors.white)),
                                        SpaceBox.height(5),
                                        Text('場所：',
                                            style: TextStyle(fontSize: 16,color:Colors.white)),
                                        SpaceBox.height(5),
                                        Text('使用曲：',
                                            style: TextStyle(fontSize: 16,color:Colors.white)),

                              ]))
                              ,

                              Expanded(

                                  child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children:[
                                        SpaceBox.height(10),
                                        Text( this.Title,
                                            style: TextStyle(fontSize: 16 ,color:Colors.white)),
                                        SpaceBox.height(5),
                                        Text(this.Date + ' ' + this.StartTime,
                                            style: TextStyle(fontSize: 16 ,color:Colors.white)),
                                        SpaceBox.height(5),
                                        Text(this.Place,
                                            style: TextStyle(fontSize: 16 ,color:Colors.white)),
                                        SpaceBox.height(6),
                                        Text(this.Music,
                                            style: TextStyle(fontSize: 16 ,color:Colors.white)),
                                       // SpaceBox.height(16),
                                       // Flexible(
                                       //   child:
                                       //   GestureDetector(
                                       //       onTap: () => _launchInBrowser(this.MusicURL), // call the _launchURL here
                                       //       child: Text(this.MusicURL, overflow: TextOverflow.ellipsis,style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 18),)
                                       //   ),),
                                       // SpaceBox.height(16),
                                       // Flexible(
                                       //   child:
                                        //  GestureDetector(
                                       //       onTap: () => _launchInBrowser(this.StoryURL), // call the _launchURL here
                                       //       child: Text(this.StoryURL, overflow: TextOverflow.ellipsis,style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 18),)
                                       //   ),)
                                      ]))
                            ] ,
                          )),
                  /*Container(
                          height: 30.0,
                          color: Colors.black,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Text('Music',
                                  style: TextStyle(fontSize: 16,color:Colors.white)),
                              //Text('3',
                               //   style: TextStyle(fontSize: 18)),
                            ] ,
                          )),*/
                  Container(

                       child: MusicPlayer(mvId: this.StoryURL, musicId: this.MusicURL, date: this.Date, startTime:this.StartTime)
                  ),

                  Container(
                      height: 40.0,
                      color: Colors.black,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[

                          Text('ストーリー',
                              style: TextStyle(fontSize: 16,color:Colors.white70)),
                          //Text('3',
                          //   style: TextStyle(fontSize: 18)),
                        ] ,
                      )),
                Expanded(

                          child: MediaTemp(mvId: this.StoryURL)
                      )

                ]

        )
    )
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({ Key? key, required this.mvId,  required this.musicId,  required this.date, required this.startTime}) : super(key: key);
  final String mvId;
  final String musicId;
  final String date;
  final String startTime;
  @override
  _MusicPlayer createState() => _MusicPlayer();
}

class _MusicPlayer extends State<MusicPlayer> {

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;
  String? localAudioCacheURI;
  AudioPlayer audioPlayer = AudioPlayer();
  Text _text = Text("");
  bool _isEnabled = true;
  int _btnStatus = 0;

  double _progress  = 0;
  Timer _timer10s = new Timer.periodic(const Duration(seconds: 1), (Timer timer) {});
  int _start10s = 10;
  late int _countdown = -10;
  late Timer _countdownTimer;

  void initState() {
    super.initState();
    _checkDownloadStatus();
    print("initial State:" +_btnStatus.toString());


    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }
  }
  @override
  void dispose() {
    stopLocal();
    //_timer10s.cancel();
    _countdownTimer.cancel();

    super.dispose();
    //print("dispose");
  }
  _timerStart() async { //タイマーの設定
    int target =   (DateFormat('yyyy年M月d日 H:m').parse(widget.date+" "+widget.startTime).millisecondsSinceEpoch ); //タイマーターゲットの日時を取得

    DateTime _myTime;
    DateTime _ntpTime;

    /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
    _myTime = DateTime.now();

    /// Or get NTP offset (in milliseconds) and add it yourself
    final int offset = await NTP.getNtpOffset(localTime: _myTime);
    _ntpTime = _myTime.add(Duration(milliseconds: offset));

    print('My time: $_myTime');
    print('NTP time: $_ntpTime');
    print('Difference: ${_myTime.difference(_ntpTime).inMilliseconds}ms');

    int _waitmillisecond = 1000 - (_ntpTime.millisecond); //00:00になるまで待つための秒数
    print(_ntpTime.second);

    int just_time = _ntpTime.millisecondsSinceEpoch; //+ waitmillisecond + 1000; //00:00　ちょうどになる秒数
    _countdown = ((target - just_time) / 1000).floor() ;
    print("target:"+target.toString());
    print("just_time:"+just_time.toString());
    //print(DateTime.now().toString());


    print(_countdown.toString() );
    Future.delayed(Duration(milliseconds: _waitmillisecond)).then((_) =>
        startCoundownTimer());
  }
  Future<void> _checkDownloadStatus() async{
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/'+widget.mvId+".mp3");

    Text textDisp = Text("download", style: const TextStyle(fontWeight: FontWeight.bold, color:Colors.white));
    bool isen = true;
    int btnSt = 0;
    if(file.existsSync()){
      textDisp = Text("Done");
      isen = false;
      btnSt = 9;
      setState(() => localFilePath = file.path);
    }
    setState(() {
      _text = textDisp;
      _isEnabled = isen;
      _btnStatus = btnSt;
      //print(_btnStatus);

      //print(_isEnabled);
    });

    if(_btnStatus == 9) {
      _timerStart();
      print("timer Start:");
    }

  }

  bool _calculateWhetherDisabledReturnsBool()  {
    print(_isEnabled);
    return _isEnabled;
  }
  Future<void> _download() async {
    setState((){ _progress = 1; _btnStatus = 1; });
    // ログイン処理
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "guest@anan-nct.ac.jp", password: "HanabiBanBan123");

    // ファイルのダウンロード
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseStorage storage = FirebaseStorage.instance;

    // 音楽
    Reference musicRef = storage.ref().child("music").child(widget.musicId);
    String musicUrl = await musicRef.getDownloadURL();
    print(Uri.parse(musicUrl));


    setState((){ _progress = 2; _btnStatus = 1; });

   // final bytes = await readBytes(Uri.parse(musicUrl));
    final dir = await getApplicationDocumentsDirectory();
    //final Directory systemTempDir = Directory.systemTemp;
    //print(systemTempDir.path);

    final file = File('${dir.path}/'+widget.mvId+".mp3"); //YouTube Id をファイル名として保存する
    var downloadTask = await musicRef.writeToFile(file);
    // プログレスを取得する
     print(file);

   // print(downloadTask.totalBytes);


   // await file.writeAsBytes(bytes);
    if (file.existsSync() ) {
      setState(() => localFilePath = file.path);
      print("done01");
    }

    await _checkDownloadStatus();
    //if(_btnStatus == 9) {
    //  _timerStart();
   // }


  }
  Future<void> playLocal() async {
    int result = await audioPlayer.play( localFilePath!, isLocal: true );
  }
  Future<void> pauseLocal() async {
    int result = await audioPlayer.pause();
  }
  Future<void> stopLocal() async {
    int result = await audioPlayer.stop();
  }
  //ダウンロードの進捗によりボタンを変更
  Widget buttonDisplay() {
    if ( _btnStatus == 0 ||_btnStatus ==9  ){ //クリックされていない時
      return Container(
          width:80,
          height:24,
          child:
          FloatingActionButton(
              onPressed: !_calculateWhetherDisabledReturnsBool() ? null : () => _download(),
              heroTag: "hero1",
              child: _text
          )

      );
    }else{
      return Container(
          width:80,
          height:20,
          child:Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: (_progress == 1) ? Colors.blue : Colors.greenAccent,
                value: null,
              ),
            ),
          ),


      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        width: 700,
        color: Colors.indigo,
        child:
          Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                  buttonDisplay(),
                                  Container(
                                      width:40,
                                      height:24,
                                      child:FloatingActionButton(
                                          onPressed: () => playLocal(),//audioCache.play(widget.mvId+".mp3"),
                                          heroTag: "hero2",
                                          child: Icon(Icons.play_arrow)
                                      )),
                                  Container(
                                      width:40,
                                      height:24,
                                      child:FloatingActionButton(
                                          onPressed: () => pauseLocal(),//audioCache.play(widget.mvId+".mp3"),
                                          heroTag: "hero3",
                                          child: Icon(Icons.pause)
                                      )),
                                  Container(
                                      width:40,
                                      height:24,
                                      child:FloatingActionButton(
                                          onPressed: () => stopLocal(),//audioCache.play(widget.mvId+".mp3"),
                                          heroTag: "hero4",
                                          child: Icon(Icons.stop)
                                      )),
                                /*Container(
                                    width:60,
                                    height:24,
                                    child:FloatingActionButton(
                                        onPressed: () => startTimer(),//audioCache.play(widget.mvId+".mp3"),
                                        heroTag: "hero5",
                                        child: Text("$_start10s")
                                    )),
                                */
                                Container(
                                    width:140,
                                    height:40,
                                    child: Padding(
                                      padding: EdgeInsets.only(left:10, top: 10),
                                      child: (_btnStatus == 9)?
                                                (_countdown > 0 )?Text("あと$_countdown秒", style: const TextStyle(fontSize:14, fontWeight: FontWeight.bold, color:Colors.white))
                                                    :
                                                      (_countdown == -10 )? Text("計算中...", style: const TextStyle(fontWeight: FontWeight.bold, color:Colors.yellow),): Text("完了!", style: const TextStyle(fontWeight: FontWeight.bold, color:Colors.red),)
                                              :Text("ダウンロードしてください", style: const TextStyle(fontSize:10,fontWeight: FontWeight.bold, color:Colors.white))

                                    )
                                ),
                               ]
                        ),
            ]
          )
    );

  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer10s = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start10s == 0) {
          playLocal();
          setState(() {
            timer.cancel();
            _start10s = 10;
          });
        } else {
          setState(() {
            _start10s--;
          });
        }
      },
    );
  }
  void startCoundownTimer() {

    const oneSec = const Duration(seconds: 1);
    _countdownTimer = new Timer.periodic(
      oneSec, (Timer timer) {
        if (_countdown == 0) {
          playLocal();
          setState(() {
            timer.cancel();
          });
        } else if(_countdown < 0){
          setState(() {
            timer.cancel();
            //_countdown = 0;
          });
        }else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }
}

class MediaTemp extends StatefulWidget {

  const MediaTemp({ Key? key, required this.mvId}) : super(key: key);
  final String mvId;

  @override
  _MediaTempState createState() => _MediaTempState();
}

class _MediaTempState extends State<MediaTemp> {

  @override
  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {
    //_media();
    return Container(
        height: 600.0,
        width:600,
        color: Colors.black,
        child:
        Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
                height: 360.0,
                width:600,
                color: Colors.black,
              child:YoutubeAppDemo(mvId:widget.mvId)
            )
          ] ,)
        );
  }
}

class YoutubeAppDemo extends StatefulWidget {
  const YoutubeAppDemo({ Key? key, required this.mvId}) : super(key: key);
  final String mvId;
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {

    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.mvId, //'1GS6RG4i8YI', //'1GS6RG4i8YI',//widget.mvId, //'tcodrIK2P_I',
      params: const YoutubePlayerParams(
        startAt: const Duration(minutes: 0, seconds: 0),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      log('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,

      child: Scaffold(

        body: LayoutBuilder(
          builder: (context, constraints) {
            if (kIsWeb && constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: player),
                  const SizedBox(
                    width: 500,
                    child: SingleChildScrollView(
                      child: Controls(),
                    ),
                  ),
                ],
              );
            }
            return ListView(
              children: [
                Stack(
                  children: [
                    player,
                    Positioned.fill(
                      child: YoutubeValueBuilder(
                        controller: _controller,
                        builder: (context, value) {
                          return AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Material(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      YoutubePlayerController.getThumbnail(
                                        videoId:
                                        _controller.initialVideoId, //params.playlist.first,
                                        quality: ThumbnailQuality.medium,
                                      ),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            crossFadeState: value.isReady
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Controls(),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Container(
        color:Colors.black,
            child:Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _space,
                  MetaDataSection(),
                  //_space,
                  //SourceInputSection(),
                  _space,
                  PlayPauseButtonBar(),
                  _space,
                  VolumeSlider(),
              //_space,
              //PlayerStateSection(),
              ],
          ),
        ));
  }

  Widget get _space => const SizedBox(height: 10);
}

