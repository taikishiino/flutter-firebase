import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: const Color(0xff9941d8), width: 1.0)
  ),
);