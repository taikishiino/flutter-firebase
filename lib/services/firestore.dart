import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/song.dart';

class FirestoreService {
  final String uid;
  FirestoreService({ this.uid });

  // collection
  final CollectionReference songCollection = Firestore.instance.collection('songs');

  CollectionReference _getSongCollection(String uid) {
    return Firestore.instance.collection('users/$uid/songs');
  }

  Future updateSong(Map<String, dynamic> params) async {
    return await _getSongCollection(uid).document().setData(params);
  }

  Future deleteSong(String documentId) async {
    return await _getSongCollection(uid).document(documentId).delete();
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