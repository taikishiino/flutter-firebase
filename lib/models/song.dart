class Song {

  final String uid;
  final String name;
  final String key;

  Song({ this.uid, this.name, this.key });
}

class SongParams {

  final String name;
  final String singer;
  final String key;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;

  SongParams({ this.name, this.singer, this.key, this.createdAt, this.updatedAt, this.deletedAt });
}