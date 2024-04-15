import 'package:flutter/material.dart';

class ProfilPatient extends StatefulWidget {
  const ProfilPatient({super.key});

  @override
  State<ProfilPatient> createState() => _ProfilPatientState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

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
                Color.fromRGBO(233, 254, 255, 1),
                Color.fromRGBO(214, 252, 255, 1),
                Color.fromRGBO(212, 250, 255, 1),
                Color.fromRGBO(221, 253, 255, 0.965),
              ],
              stops: [0.0, 0.5, 0.8, 1],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/image/back.png",
                            width: 30,
                            height: 30,
                          )),
                      const Text("Lorem Lopsem", // le nom de patient ici
                          style: TextStyle(
                            fontFamily: myfont,
                            fontSize: 20,
                            color: myCustomColor,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/image/menudot.png",
                            width: 30,
                            height: 30,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [myCustomColor, myCustomColor1],
                      ),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 47,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/image/people.png"),
                    )),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("200 \n Ami(e)s",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: myfont,
                              fontSize: 17,
                              color: myCustomColor,
                            )),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "+ Ajouter à la story",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: myfont,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myCustomColor, // Background color
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Rounded corners
                            ),
                            side: BorderSide(
                              color: myCustomColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/image/pen.png",
                                width: 15,
                                height: 15,
                              ),
                              Text(
                                " Modifier le profil",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: myfont,
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 6),
                            backgroundColor: const Color.fromARGB(
                                0, 255, 255, 255), // Background color
                            foregroundColor: myCustomColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Rounded corners
                            ),
                            side: BorderSide(
                              color: myCustomColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Aligner les enfants au début

                    children: [
                      Text(
                        "Publications",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 17,
                          color: myCustomColor,
                        ),
                      ),
                      Divider(
                        color: myCustomColor, // Couleur du Divider
                        thickness: 1, // Épaisseur du Divider
                        height: 1, // Hauteur du Divider
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
