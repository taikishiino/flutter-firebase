import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/users.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text('うたメモβ'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            //child: Text('ログイン情報：${user.email}'),
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
              return AddPostPage();
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
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final List<num> keys = [-4, -3, -2, -1, 0, 1, 2, 3, 4];

  // State
  String _currentSongName;  // 曲名
  String _currentSinger;  // 歌手名
  num _currentKey; // キー

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text('うたメモβ'),
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
                    decoration: const InputDecoration(
                      icon: Icon(Icons.audiotrack),
                      labelText: '曲名'
                    ),
                    validator: (val) => val.isEmpty ? '曲名を入力してください' : null,
                    onChanged: (String value) {
                      setState(() => _currentSongName = value );
                    },
                  ),
                  SizedBox(height: 20.0),
                  // 歌手名
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '歌手名',
                    ),
                    onChanged: (String value) {
                      setState(() => _currentSinger = value );
                    },
                  ),
                  SizedBox(height: 20.0),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 10,
                      thumbColor: Colors.purple[300],
                      valueIndicatorColor: Colors.purple[300],
                      activeTrackColor: Colors.purple[300],
                      inactiveTrackColor: Colors.purple[300],
                      inactiveTickMarkColor: Colors.purple[300],
                      activeTickMarkColor: Colors.purple[300],
                    ),
                    child: Slider(
                      min: -4,
                      max: 4,
                      divisions: 8,
                      value: (_currentKey ?? 0),
                      label: '${(_currentKey ?? 0).toString()}',
                      onChanged: (val) => setState(() => _currentKey = val),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.purple[300],
                      textColor: Colors.white,
                      child: Text('追加'),
                      onPressed: () async {
                        final currentDate =
                            DateTime.now().toLocal().toIso8601String(); // 現在の日時
                        final Map<String, dynamic> postParams = {
                          'name': _currentSongName,
                          'singer': _currentSinger,
                          'key': _currentKey ?? 0,
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