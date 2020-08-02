import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/song.dart';
import 'package:flutter_firebase/screens/home/setting_form.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/screens/home/song_list.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingForm(),
        );
      });
    }

    return StreamProvider<List<Song>>.value(
        value: FirestoreService().songs,
        child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Flutter Firebase'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: () => _showSettingPanel(),
            )
            ],
          ),
          body: SongList(),
        )
    );
  }
}