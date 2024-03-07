import 'package:flutter/material.dart';
import 'package:ycmedical/data/cities.dart';
import 'package:ycmedical/data/pays.dart';

class AuthPatient extends StatefulWidget {
  const AuthPatient({super.key});

  @override
  State<AuthPatient> createState() => _AuthPatientState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'FSPDemoUniformPro';

class _AuthPatientState extends State<AuthPatient> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
            child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(100, 218, 229, 0.854),
                Color.fromRGBO(146, 226, 232, 0.886),
                Color.fromRGBO(194, 248, 255, 0.922),
                Color.fromRGBO(222, 248, 255, 0.664),
              ],
              stops: [0.0, 0.27, 0.47, 1],
            ),
          ),
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "créer un compte",
                  style: TextStyle(
                    fontFamily: 'FSPDemoUniformPro',
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Column(children: [
                    PaysList(),
                    SizedBox(
                      height: 20,
                    ),
                    CityList(),
                  ]),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
