import 'package:flutter/material.dart';
import 'package:ycmedical/authentification/connection.dart';
import 'package:ycmedical/authentification/signup.dart';
import 'package:ycmedical/data/cities.dart';
//import 'authentification/connection.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Connection(),
    ),
  );
}
