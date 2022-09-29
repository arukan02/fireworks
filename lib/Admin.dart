// ログイン処理
//await FirebaseAuth.instance.signInWithEmailAndPassword(
//    email: "kobayashi@anan-nct.ac.jp", password: "HanabiBanBan123");


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fireworks/MusicUpload.dart';
import 'hanabi_list.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('管理者画面'),
        ),
        body: Container(

            child: Column(
                children:[
                    SizedBox(
                      width: _size.width,
                      height: 80,
                      child: ElevatedButton(
                        child: const Text('音楽アップロード',
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
                            MaterialPageRoute(builder: (context) => MusicUpload()),
                          );
                        },
                      ),
                  ),
                  SizedBox(
                    width: _size.width,
                    height: 80,
                    child: ElevatedButton(
                      child: const Text('花火情報追加',
                        style:  TextStyle(
                            fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFDBB73),
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HanabiList()),
                        );
                      },
                    ),
                  ),

                ]
            ),
          ),
    );
  }
}




