import 'package:flutter/material.dart';
import 'package:ycmedical/profil/profilpatient.dart';
import 'package:ycmedical/view/authentification/connection.dart';
import 'package:ycmedical/view/authentification/signup.dart';
import 'package:ycmedical/data/widget.dart/cities.dart';
//import 'authentification/connection.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilPatient(),
    ),
  );
}
