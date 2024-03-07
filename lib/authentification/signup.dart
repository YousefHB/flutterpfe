import 'dart:convert';
import 'package:ycmedical/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/authentification/authpatient.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'FSPDemoUniformPro';

class _SignupScreenState extends State<SignupScreen> {
  bool isBlurred = false;
  bool isWidgetVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  validationform(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isBlurred = !isBlurred;
        isWidgetVisible = !isWidgetVisible;
      });
    }
  }

  void registerpatient() async {
    var regbody = {
      "firstname": firstnameController,
      "lastname": lastnameController,
      "dateOfBirth": dateOfBirthController,
      "email": emailController,
      "password": passwordController,
      "role": "PATIENT",
    };
    var response = await http.post(Uri.parse(registraion),
        headers: {"content-type": "application/json"},
        body: jsonEncode(regbody));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool _obscureText = true;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1000),
                    opacity: isBlurred ? 0.5 : 1.0,
                    child: Column(
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 137, 137, 137)
                                            .withOpacity(
                                                0.6), // Couleur de l'ombre
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0,
                                            5), // Déplace l'ombre vers le bas
                                      ),
                                    ],
                                  ),
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: firstnameController,
                                      cursorColor: myCustomColor1,
                                      decoration: const InputDecoration(
                                        hintText: "Prénom",
                                        hintStyle: TextStyle(
                                          fontFamily: "FSPDemoUniformPro",
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(224, 89, 111, 114),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        //alignLabelWithHint: true, // Center label vertically
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'champ obligatoire';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 137, 137, 137)
                                            .withOpacity(
                                                0.6), // Couleur de l'ombre
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0,
                                            5), // Déplace l'ombre vers le bas
                                      ),
                                    ],
                                  ),
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: lastnameController,
                                      cursorColor: myCustomColor1,
                                      decoration: const InputDecoration(
                                        hintText: "Nom",
                                        hintStyle: TextStyle(
                                          fontFamily: "FSPDemoUniformPro",
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(224, 89, 111, 114),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        //alignLabelWithHint: true, // Center label vertically
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'champ obligatoire';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 137, 137, 137)
                                            .withOpacity(
                                                0.6), // Couleur de l'ombre
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: const Offset(0,
                                            5), // Déplace l'ombre vers le bas
                                      ),
                                    ],
                                  ),
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: dateOfBirthController,
                                      cursorColor: myCustomColor1,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        hintText: "Date de naissance",
                                        hintStyle: TextStyle(
                                          fontFamily: "FSPDemoUniformPro",
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(224, 89, 111, 114),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        //alignLabelWithHint: true, // Center label vertically
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'champ obligatoire';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 137, 137, 137)
                                            .withOpacity(
                                                0.6), // Couleur de l'ombre
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: Offset(0,
                                            5), // Déplace l'ombre vers le bas
                                      ),
                                    ],
                                  ),
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: emailController,
                                      cursorColor: myCustomColor1,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                          fontFamily: "FSPDemoUniformPro",
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(224, 89, 111, 114),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        //alignLabelWithHint: true, // Center label vertically
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'champ obligatoire';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 137, 137, 137)
                                            .withOpacity(
                                                0.6), // Couleur de l'ombre
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: const Offset(0,
                                            5), // Déplace l'ombre vers le bas
                                      ),
                                    ],
                                  ),
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: passwordController,
                                      cursorColor: myCustomColor1,
                                      obscureText: _obscureText,
                                      decoration: const InputDecoration(
                                        hintText: "Mot de passe",
                                        hintStyle: TextStyle(
                                          fontFamily: "FSPDemoUniformPro",
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(224, 89, 111, 114),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        //alignLabelWithHint: true, // Center label vertically
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'champ obligatoire';
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 137, 137, 137)
                                            .withOpacity(
                                                0.6), // Couleur de l'ombre
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: const Offset(0,
                                            5), // Déplace l'ombre vers le bas
                                      ),
                                    ],
                                  ),
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: confirmpasswordController,
                                      cursorColor: myCustomColor1,
                                      obscureText: _obscureText,
                                      decoration: const InputDecoration(
                                        hintText: "Confirmer le mot de passe",
                                        hintStyle: TextStyle(
                                          fontFamily: "FSPDemoUniformPro",
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(224, 89, 111, 114),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        //alignLabelWithHint: true, // Center label vertically
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a password';
                                        }
                                        if (value != passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isBlurred = !isBlurred;
                              isWidgetVisible = !isWidgetVisible;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 160,
                          height: 50,
                          child: Text(
                            isBlurred ? 'Je suis ' : 'Je suis ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: myfont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myCustomColor, // Background color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // Rounded corners
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: isWidgetVisible ? 1.0 : 0.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AuthPatient()),
                                  );
                                },
                                child: Text(
                                  "Patient",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: myfont,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      myCustomColor, // Background color
                                  foregroundColor: Colors.white, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Rounded corners
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  print("helloooooooooooooooooo");
                                  /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SigninScreen()),
                                          );*/
                                },
                                child: Text(
                                  "Professionnel\nde la santé",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: myfont,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.transparent, // Background color
                                  foregroundColor: myCustomColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // Rounded corners
                                  ),
                                  side: BorderSide(
                                    color: myCustomColor, // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}