import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/authenticate/authenticate.dart';
import 'package:flutter_firebase/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/models/users.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    // return
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}