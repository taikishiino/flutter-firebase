import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/users.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:flutter_firebase/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('うためもβ'),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('ログイン'),
              textColor: Colors.white,
              onPressed: () {
                widget.toggleView();
              }
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              const Color(0xffe4a972).withOpacity(0.6),
              const Color(0xff9941d8).withOpacity(0.6),
            ],
            stops: const [
              0.0,
              1.0,
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'メールアドレスを入力してください' : null,
                      onChanged: (val) {
                        print(val);
                        setState(() => email = val);
                      }
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val.length < 6 ? '6文字以上入力してください' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      }
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          '新規登録',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            try {
                              final User user = await _auth.registerWithEmailAndPassword(email, password);
                              if (user != null) {
                                final currentDate =
                                DateTime.now().toLocal().toIso8601String(); // 現在の日時
                                await FirestoreService(uid: user.uid).updateSong({
                                  'name': '例）欲望に満ちた青年団',
                                  'singer': 'ONE OK ROCK',
                                  'key': -2,
                                  'createdAt': currentDate,
                                  'updatedAt': currentDate,
                                  'deletedAt': null
                                });
                              } else {
                                setState(() {
                                  error = 'メールアドレスが使われているか不正です';
                                  loading = false;
                                });
                              }
                            } catch(e) {
                              print(e);
                            }
                          }
                        }
                      )
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}