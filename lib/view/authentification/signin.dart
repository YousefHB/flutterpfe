import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:ycmedical/config.dart';
import '../../posts/MainHomeNavigator.dart';
import 'passwordoublie.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void loginUser() async {
    var regbody = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(login), // Correction du nom de la variable
        headers: {"Content-type": "application/json"},

        body: jsonEncode(regbody),
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var accessToken = responseBody['data']['access_token'];

        // Stockage du token localement

        // Pour Flutter mobile
        final storage = FlutterSecureStorage();
        await storage.write(key: 'accessToken', value: accessToken);

        print('Token JWT récupéré: $accessToken');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainNav()));
      } else {
        // Gérer les erreurs de connexion
        print('Erreur lors de la connexion: ${response.body}');
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Connectez",
                        style: TextStyle(
                          fontFamily: 'ArialRounded',
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "vous à votre compte",
                        style: TextStyle(
                          fontFamily: 'ArialRounded',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
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
                          offset: Offset(0, 5), // Déplace l'ombre vers le bas
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      cursorColor: myCustomColor1,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        //alignLabelWithHint: true, // Center label vertically
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
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
                        child: TextField(
                          controller: passwordController,
                          cursorColor: myCustomColor1,
                          decoration: const InputDecoration(
                            hintText: "Mot de passe",
                            hintStyle: TextStyle(
                              fontFamily: "ArialRounded",
                              fontSize: 12,
                              color: Color.fromARGB(224, 89, 111, 114),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            alignLabelWithHint: true, // Center label vertically
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Passwordoublie()),
                              );
                            },
                            child: const Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Franklin",
                                fontSize: 12,
                              ),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 170,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: myCustomColor, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(28.0), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 65), // Adjust padding as needed
                    ),
                    child: Text(
                      'Connecter',
                      style: TextStyle(
                        fontFamily: 'ArialRounded',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 2,
                        decoration: BoxDecoration(color: Color(0xFF009EE2)),
                      ),
                      Text(
                        ' Connecter avec ',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Franklin',
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Color(0xFF009EE2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image/google.png', // Path to the first image asset
                        width: 30, // Adjust width as needed
                        height: 30, // Adjust height as needed
                      ),
                      const SizedBox(width: 15.0),
                      Image.asset(
                        'assets/image/apple.png', // Path to the first image asset
                        width: 30, // Adjust width as needed
                        height: 30, // Adjust height as needed
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "vous n'avez pas de compte ?",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Franklin',
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text(
                          "s'inscrire",
                          style: TextStyle(
                            color: Color(0xFF009EE2),
                            fontFamily: 'Franklin',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
