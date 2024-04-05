import 'package:flutter/material.dart';

class ProfilPatient extends StatefulWidget {
  const ProfilPatient({super.key});

  @override
  State<ProfilPatient> createState() => _ProfilPatientState();
}

class _ProfilPatientState extends State<ProfilPatient> {
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
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset("assets/image/back.png")),
                    Text("Lorem Lopsem"),
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset("assets/image/list.png")),
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
