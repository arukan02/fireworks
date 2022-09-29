// ログイン処理
//await FirebaseAuth.instance.signInWithEmailAndPassword(
//    email: "kobayashi@anan-nct.ac.jp", password: "HanabiBanBan123");


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fireworks/Admin.dart';
import 'hanabi_list.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ログイン'),
        ),
        body: Container(
          child:Padding(
            padding: EdgeInsets.all(0), //(16.0),

            child: Column(
                children:[
                  loginContainer(),

                ]
            ),
          ),
        ))
    ;
  }
}

class loginContainer extends StatefulWidget {
  const loginContainer({Key? key}) : super(key: key);

  @override
  _loginContainerState createState() => _loginContainerState();
}

class _loginContainerState extends State<loginContainer> {
  String _login_Email = "";
  String _login_Password = "";  // 入力されたパスワード
  String _infoText = "ログイン";
  final FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          // メールアドレスの入力フォーム
                  Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                      child:TextFormField(
                          decoration: InputDecoration(
                              labelText: "メールアドレス"
                          ),
                        onChanged: (String value) {
                          setState(() {
                            _login_Email= value;
                          });
                        },
                      )
                  ),

          // パスワードの入力フォーム
                  Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                    child:TextFormField(
                      maxLengthEnforcement: MaxLengthEnforcement.none, decoration: InputDecoration(
                          labelText: "パスワード（8～20文字）"
                      ),
                      obscureText: true,  // パスワードが見えないようにする
                      maxLength: 20,  // 入力可能な文字数の制限を超える場合の挙動の制御
                      onChanged: (String value) {
                        setState(() {
                          _login_Password= value;
                        });
                      },
                    ),
          ),
          // ログイン失敗時のエラーメッセージ
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
            child:Text(_infoText,
              style: TextStyle(color: Colors.red),),
          ),

          ButtonTheme(
            minWidth: 350.0,
            // height: 100.0,
            child: ElevatedButton(
                child:  const Text('ログイン',
                  style:  TextStyle(
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),

                onPressed: () async {
                  try {
                    userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: _login_Email, password: _login_Password);
                       setState((){ _infoText = "OK"; });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Admin() ), // ), //HanabiList()
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      setState((){ _infoText = "ログインできません"; });

                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      setState((){ _infoText = "ログインできません"; });
                    }
                  } catch (e) {
                    print(e);
                    setState((){ _infoText = "ログインできません"; });
                  }


                }
            ),
          ),
        ]
        )
    );
  }
}

class AuthResult {
}
