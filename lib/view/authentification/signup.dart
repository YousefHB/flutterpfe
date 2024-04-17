import 'dart:convert';
import 'package:ycmedical/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/view/authentification/authpatient.dart';
import 'package:ycmedical/view/authentification/authprofsante.dart';
import 'package:ycmedical/view/authentification/passwordoublie.dart';
import 'package:ycmedical/view/authentification/verificationEmail.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

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
  /*********************************** */
  void registerUser() async {
    // Convertir la chaîne de date en objet DateTime
    DateTime dateOfBirth = parseDate(dateOfBirthController.text);

    // Formatage de la date pour MongoDB (format ISO 8601)
    String formattedDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateOfBirth);
    print(formattedDate);

    var regbody = {
      "firstName": firstnameController.text,
      "lastName": lastnameController.text,
      "dateOfBirth": formattedDate,
      "email": emailController.text,
      "password": passwordController.text
    };
    // Afficher le contenu de regbody
    print('Contenu de regbody:');
    regbody.forEach((key, value) {
      print('$key: $value');
    });
    var response = await http.post(
      Uri.parse(registraion),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(regbody),
    );
    if (response.statusCode == 200) {
      print('Les données ont été envoyées avec succès !');
      print('Réponse du serveur : ${response.body}');
    } else {
      print(
          'Erreur lors de l\'envoi des données. Code d\'erreur : ${response.statusCode}');
      print('Message d\'erreur : ${response.body}');
    }
  }

  DateTime parseDate(String dateString) {
    // Diviser la chaîne de date en parties séparées par '/'
    List<String> parts = dateString.split('/');

    // Extraire l'année, le mois et le jour
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    // Créer un objet DateTime
    return DateTime(year, month, day);
  }

  /*********************************** */
  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validateDateOfBirth(String? value) {
    // Regular expression for date validation in the format "dd/mm/yyyy"
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (value == null || value.isEmpty) {
      return 'Please enter a date of birth';
    } else if (!dateRegex.hasMatch(value)) {
      return 'Please enter a valid date in the format dd/mm/yyyy';
    }

    // You can add further validation logic here if needed
    // For example, checking if the day, month, and year are within valid ranges

    return null;
  }

  validationform(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isBlurred = !isBlurred;
        isWidgetVisible = !isWidgetVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool _obscureText = true;
    bool isPatient = true;

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
                AnimatedOpacity(
                  duration: Duration(milliseconds: 1000),
                  opacity: isBlurred ? 0.5 : 1.0,
                  child: Column(
                    children: [
                      Text(
                        "créer un compte",
                        style: TextStyle(
                          fontFamily: 'ArialRounded',
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
                                constraints: BoxConstraints(
                                  maxHeight:
                                      60, // Définir une largeur maximale pour le champ de texte
                                ),
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
                                      offset: Offset(
                                          0, 5), // Déplace l'ombre vers le bas
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontFamily: "ArialRounded",
                                    fontSize: 15,
                                    color: Color.fromARGB(239, 89, 111, 114),
                                  ),
                                  controller: firstnameController,
                                  cursorColor: myCustomColor1,
                                  decoration: const InputDecoration(
                                    hintText: "Prénom",
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
                                    //alignLabelWithHint: true, // Center label vertically
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '*champ obligatoire';
                                    }
                                  },
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
                                      offset: Offset(
                                          0, 5), // Déplace l'ombre vers le bas
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontFamily: "ArialRounded",
                                    fontSize: 15,
                                    color: Color.fromARGB(239, 89, 111, 114),
                                  ),
                                  onTap: () {
                                    print(
                                        "nom est " + firstnameController.text);
                                  },
                                  controller: lastnameController,
                                  cursorColor: myCustomColor1,
                                  decoration: const InputDecoration(
                                    hintText: "Nom",
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
                                    //alignLabelWithHint: true, // Center label vertically
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '*champ obligatoire';
                                    }
                                  },
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
                                      offset: const Offset(
                                          0, 5), // Déplace l'ombre vers le bas
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  onTap: () {
                                    print("prénom est " +
                                        lastnameController.text);
                                  },
                                  controller: dateOfBirthController,
                                  cursorColor: myCustomColor1,
                                  keyboardType: TextInputType.datetime,
                                  style: TextStyle(
                                    fontFamily: "ArialRounded",
                                    fontSize: 15,
                                    color: Color.fromARGB(239, 89, 111, 114),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Date de naissance",
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

                                    //alignLabelWithHint: true, // Center label vertically
                                  ),
                                  validator: _validateDateOfBirth,
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
                                      offset: Offset(
                                          0, 5), // Déplace l'ombre vers le bas
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  onTap: () {
                                    print("naissance est " +
                                        dateOfBirthController.text);
                                  },
                                  style: TextStyle(
                                    fontFamily: "ArialRounded",
                                    fontSize: 15,
                                    color: Color.fromARGB(232, 89, 111, 114),
                                  ),
                                  controller: emailController,
                                  cursorColor: myCustomColor1,
                                  keyboardType: TextInputType.emailAddress,
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
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),

                                    //alignLabelWithHint: true, // Center label vertically
                                  ),
                                  validator: _validateEmail,
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
                                      offset: const Offset(
                                          0, 5), // Déplace l'ombre vers le bas
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  onTap: () {
                                    print("email est " + emailController.text);
                                  },
                                  style: TextStyle(
                                    fontFamily: "ArialRounded",
                                    fontSize: 15,
                                    color: Color.fromARGB(239, 89, 111, 114),
                                  ),
                                  controller: passwordController,
                                  cursorColor: myCustomColor1,
                                  obscureText: _obscureText,
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

                                    //alignLabelWithHint: true, // Center label vertically
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '*champ obligatoire';
                                    }
                                  },
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
                                      offset: const Offset(
                                          0, 5), // Déplace l'ombre vers le bas
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  onTap: () {
                                    print("password est " +
                                        passwordController.text);
                                  },
                                  style: TextStyle(
                                    fontFamily: "ArialRounded",
                                    fontSize: 15,
                                    color: Color.fromARGB(239, 89, 111, 114),
                                  ),
                                  controller: confirmpasswordController,
                                  cursorColor: myCustomColor1,
                                  obscureText: _obscureText,
                                  decoration: const InputDecoration(
                                    hintText: "Confirmer le mot de passe",
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

                                    //alignLabelWithHint: true, // Center label vertically
                                  ),
                                  validator: (value) {
                                    if (value != passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
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
                        registerUser();
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
                                setState(() {
                                  isPatient = true;
                                });
                                true;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VerificationEmail(
                                          isPatient: isPatient)),
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
                                setState(() {
                                  isPatient = false;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VerificationEmail(
                                          isPatient: isPatient)),
                                );
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
    );
  }
}
