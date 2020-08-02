import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/users.dart';
//import 'package:flutter_firebase/services/firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create obj on Firebase User
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
      //return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      print("signInWithEmailAndPassword ==============>>");
      print(email);
      print(password);
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(result);
      print("result");
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print("ERROR ========>");
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      print("registerWithEmailAndPassword ==============>>");
      print(email);
      print(password);
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //await FirestoreService(uid: user.uid).updateSong('歌の名前', '-2');
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}