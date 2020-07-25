import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/song.dart';

class FirestoreService {
  final String uid;
  FirestoreService({ this.uid });

  // collection
  final CollectionReference songCollection = Firestore.instance.collection('songs');

  CollectionReference _getSongCollection(String uid) {
    print(uid);
    return Firestore.instance.collection('users').document(uid).collection('songs');
    //return Firestore.instance.collection('users/$uid/songs');
  }

  Future updateSong(String name, String key) async {
    return await songCollection.document().setData({
      'uid': uid,
      'name': name,
      'key': key,
    });
  }

  // song list
  List<Song> _songListFromSnapshot(QuerySnapshot snapshot) {
    snapshot.documents.map((doc) {
      return Song(
        uid: doc['uid'] ?? '',
        name: doc['name'] ?? '',
        key: doc['key'] ?? '0',
      );
    }).toList();
  }

//  Song _songFromSnapshot(QuerySnapshot snapshot) {
//    return Song(
//      uid: snapshot.documents[0]['uid'] ?? '',
//      name: document.data['name'] ?? '',
//      key: document.data['key'] ?? '0',
//    );
//  }

  Stream<List<Song>> get songs {
    return songCollection.where("uid", isEqualTo: uid).snapshots().map(_songListFromSnapshot);
//    print(uid);
//    _getSongCollection(uid).getDocuments().then((value) {
//      print("test");
//      print(value.documents);
//      return value.documents.map(_songFromDocuments).toList();
//    });
  }

//  Stream<Song> get song {
//    return songCollection.where("uid", isEqualTo: uid).snapshots()
//      .map(_songFromSnapshot);
//  }
}