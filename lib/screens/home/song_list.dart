import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/song.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/screens/home/song_tile.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  @override
  Widget build(BuildContext context) {
    final songs = Provider.of<List<Song>>(context);
    songs.forEach((song) {
      print(song.name);
    });

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return SongTile(song: songs[index]);
      },
    );
  }
}
