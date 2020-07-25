import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/song.dart';
import 'package:provider/provider.dart';

class SongTile extends StatelessWidget {

  final Song song;
  SongTile({ this.song });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[0],
          ),
          title: Text(song.name),
          subtitle: Text('適性キー: ${song.key}'),
        ),
      ),
    );
  }
}
