import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ycmedical/data/widget.dart/cities.dart';
import 'package:ycmedical/data/widget.dart/pays.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';
import 'package:ycmedical/view/authentification/signin.dart';

class AuthPatient extends StatefulWidget {
  final String tokenCode; // Ajouter un champ pour le token

  AuthPatient(
      {required this.tokenCode}); // Mettre à jour le constructeur pour accepter le token
  @override
  State<AuthPatient> createState() => _AuthPatientState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _AuthPatientState extends State<AuthPatient> {
  var selectedGender;
  final TextEditingController countryController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();

  void registerPatient() async {
    String token = widget.tokenCode;
    print(token);

    var regbody = {
      "genre": selectedGender,
      "country": _paysController.text,
      "city": countryController.text
    };

    try {
      var response = await http.post(
        Uri.parse(url +
            '/api/auth/registerPatient/$token'), // Correction du nom de la variable
        headers: {
          "Content-type": "application/json",
          "Authorization":
              "Bearer $token", // Passer le token dans l'en-tête Authorization
        },
        body: jsonEncode(regbody),
      );

      if (response.statusCode == 200) {
        print('Request accepted.');
        // Ajoutez votre logique supplémentaire ici si nécessaire
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SigninScreen()));
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Message d\'erreur : ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

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
            child: Container(
              margin: EdgeInsetsDirectional.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "créer un compte",
                    style: TextStyle(
                      fontFamily: 'ArialRounded',
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    child: Column(children: [
                      PaysList(paysController: _paysController),
                      SizedBox(
                        height: 20,
                      ),
                      CityList(countryController: countryController),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              215, 255, 255, 255), // Background color
                          borderRadius:
                              BorderRadius.circular(25.0), // Border radius
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 137, 137, 137)
                                  .withOpacity(0.6), // Couleur de l'ombre
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 5), // Déplace l'ombre vers le bas
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text(
                              "Genre",
                            ),
                            style: TextStyle(
                              fontFamily: "ArialRounded",
                              fontSize: 12,
                              color: Color.fromARGB(224, 89, 111, 114),
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: ["Homme", "Femme"]
                                .map((e) => DropdownMenuItem(
                                      child: Text("$e"),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedGender = val!;
                              });
                            },
                            value: selectedGender),
                      ),
                      SizedBox(
                        height: 170,
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Récupérer les valeurs des contrôleurs
                            registerPatient();
                          },
                          child: Text(
                            "Crée",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: myfont,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: myCustomColor, // Background color
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Rounded corners
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
