import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter_firebase/shared/constants.dart';

void main() {
  // 最初に表示するWidget
  runApp(ChatApp());
}

// 更新可能なデータ
class UserState extends ChangeNotifier {
  FirebaseUser user;

  void setUser(FirebaseUser newUser) {
    user = newUser;
    notifyListeners();
  }
}

class ChatApp extends StatelessWidget {
  // ユーザーの情報を管理するデータ
  final UserState userState = UserState();

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を渡す
    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp(
        // 右上に表示される"debug"ラベルを消す
        debugShowCheckedModeBanner: false,
        // アプリ名
        title: 'うたメモ',
        theme: ThemeData(
          // テーマカラー
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ログイン画面を表示
        home: LoginPage(),
      )
    );
  }
}

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // メッセージ表示用
  String infoText = '';

  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final AuthResult result =
                          await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final FirebaseUser user = result.user;
                      // ユーザー情報を更新
                      userState.setUser(user);
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          // ユーザー情報を渡す
                          return ChatPage(user);
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.message}";
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlineButton(
                  textColor: Colors.blue,
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final AuthResult result =
                          await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final FirebaseUser user = result.user;
                      // ユーザー情報を更新
                      userState.setUser(user);
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          // ユーザー情報を渡す
                          return ChatPage(user);
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.message}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// チャット画面用Widget
class ChatPage extends StatelessWidget {
  // 引数からユーザー情報を受け取れるようにする
  ChatPage(this.user);

  // ユーザー情報
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {

    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final FirebaseUser user = userState.user;

    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: const Color(0xffe4a973),
        backgroundColorEnd: const Color(0xff9941d8),
        title: Text('うたメモ'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('ログアウト'),
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("ログアウト"),
                    content: Text('ログアウトして本当によろしいですか？'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () async {
                          try {
                            // ログアウト処理
                            // 内部で保持しているセッション情報が初期化される
                            await FirebaseAuth.instance.signOut();
                            // ログイン画面に遷移＋チャット画面を破棄
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }),
                            );
                          } catch(e) {
                            print(e);
                          }
                          Navigator.pop(context);
                        }
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報：${user.email}'),
          ),
          Expanded(
            // 非同期処理の結果を元にWidgetを作れる
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得（非同期処理）
              // 更新日時でソート
              stream: Firestore.instance
                  .collection('users/${user.uid}/songs')
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents =
                      snapshot.data.documents;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      IconButton deleteIcon;
                      deleteIcon = IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("削除確認"),
                                content: Text('「${document['name']} / ${document['singer']}」を削除して本当によろしいですか？'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () async {
                                      try {
                                        // 投稿メッセージのドキュメントを削除
                                        await FirestoreService(uid: user.uid).deleteSong(document.documentID);
                                      } catch(e) {
                                        print(e);
                                      }
                                      Navigator.pop(context);
                                    }
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      );
                      return Card(
                        child: ListTile(
                          title: Text('${document['name']} / ${document['singer']}'),
                          subtitle: Text('適性キー: ${document['key']}'),
                          trailing: deleteIcon,
                        ),
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 引数からユーザー情報を渡す
              return AddPostPage(user);
            }),
          );
        },
        // グラデーション
        tooltip: 'Increment',
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: const [
                Color(0xffe4a972),
                Color(0xff9941d8),
              ],
            ),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

// 投稿画面用Widget
class AddPostPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  AddPostPage(this.user);
  // ユーザー情報
  final FirebaseUser user;

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {

  final _formKey = GlobalKey<FormState>();
  final List<String> keys = ['-4', '-3', '-2', '-1', '0', '+1', '+2', '+3', '+4'];

  // State
  String _currentSongName;  // 曲名
  String _currentSinger;  // 歌手名
  String _currentKey; // キー

  @override
  Widget build(BuildContext context) {

    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final FirebaseUser user = userState.user;

    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: const Color(0xffe4a973),
        backgroundColorEnd: const Color(0xff9941d8),
        title: Text('うた追加'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 曲名
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: '曲名'),
                    validator: (val) => val.isEmpty ? '曲名を入力してください' : null,
                    onChanged: (String value) {
                      setState(() => _currentSongName = value );
                    },
                  ),
                  SizedBox(height: 20.0),
                  // 歌手名
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: '歌手名'),
                    onChanged: (String value) {
                      setState(() => _currentSinger = value );
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    value: _currentKey ?? '0',
                    items: keys.map((key) {
                      return DropdownMenuItem(
                        value: key,
                        child: Text('# $key'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentKey = val),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: const Color(0xff9941d8),
                      textColor: Colors.white,
                      child: Text('追加'),
                      onPressed: () async {
                        final currentDate =
                            DateTime.now().toLocal().toIso8601String(); // 現在の日時
                        final Map<String, dynamic> postParams = {
                          'name': _currentSongName,
                          'singer': _currentSinger,
                          'key': _currentKey,
                          'createdAt': currentDate,
                          'updatedAt': currentDate,
                          'deletedAt': null
                        };
                        try {
                          await FirestoreService(uid: user.uid).updateSong(postParams);
                        } catch(e) {
                          print(e);
                        }
                        // 1つ前の画面に戻る
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}