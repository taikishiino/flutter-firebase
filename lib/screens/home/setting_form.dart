import 'package:flutter/material.dart';
import 'package:flutter_firebase/shared/constants.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> keys = ['-4', '-3', '-2', '-1', '0', '+1', '+2', '+3', '+4'];

  // form value
  String _currentName;
  String _currentKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'My Songを登録',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val.isEmpty ? '曲名を入力してください' : null,
            onChanged: (val) => setState(() => _currentName = val),
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
          RaisedButton(
            color: Colors.pink[400],
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print(_currentName);
              print(_currentKey);
            },
          )
        ],
      ),
    );
  }
}
