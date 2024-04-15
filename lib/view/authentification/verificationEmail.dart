// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:ycmedical/view/authentification/authpatient.dart';
import 'package:ycmedical/view/authentification/authprofsante.dart';
import 'package:ycmedical/view/authentification/signup.dart';
import 'signin.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class VerificationEmail extends StatefulWidget {
  final bool isPatient;
  VerificationEmail({required this.isPatient});
  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _VerificationEmailState extends State<VerificationEmail> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();
  @override
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  TextEditingController input3 = TextEditingController();
  TextEditingController input4 = TextEditingController();
  TextEditingController input5 = TextEditingController();
  TextEditingController input6 = TextEditingController();
  /*void verifyCode() async {
    String concatenatedCode = input1.text +
        input2.text +
        input3.text +
        input4.text +
        input5.text +
        input6.text;

    var regbody = {
      "cod": concatenatedCode,
    };

    var response = await http.post(
      Uri.parse(
          validateEmail), // Assuming validateEmail contains your backend URL
      headers: {"Content-type": "application/json"},
      body: jsonEncode(regbody),
    );

    print(response.body); // Printing response body for debugging
  }*/
  Future<void> verifyCodeRegister(
      String code, bool isPatient, Function(String tokenCode) onSuccess) async {
    final String apiUrl =
        validateEmail; // Remplacez 'your-backend-url' par l'URL de votre backend

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'cod': code,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var tokenCode = data['tokenCode'];
        var userId = data['userId'];
        print('Token Code: $tokenCode');
        print('User ID: $userId');

        // Appel de la fonction de rappel avec le tokenCode
        onSuccess(tokenCode);
      } else if (response.statusCode == 404) {
        var data = jsonDecode(response.body);
        var errorMessage = data['msg'];
        print('Error: $errorMessage');
      } else {
        print('Error: Failed to verify code.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    super.dispose();
    _timer.cancel();
    super.dispose();
  }

  late Timer _timer;
  int _start = 180; // 3 minutes en secondes

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String minutesStr = '${(_start / 60).floor().toString().padLeft(2, '0')}';
    String secondsStr = '${(_start % 60).toString().padLeft(2, '0')}';

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
                Color.fromRGBO(155, 247, 255, 0.497),
                Color.fromRGBO(212, 252, 255, 0.796),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: myCustomColor, // Set border color here
                        width: 2.0, // Set border width here
                      ),
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius here
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        icon: Image.asset(
                          'assets/image/back.png',
                          width: 25,
                          height: 25,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Vérifier votre email",
                        style: TextStyle(
                            fontFamily: 'ArialRounded',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Entrer le code de\n récupération à 6 chiffres",
                        style: TextStyle(
                            fontFamily: 'ArialRounded',
                            fontSize: 22,
                            color: myCustomColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Le code de récupération a été envoyé à votre\nemail veuillez entrer le code ",
                        style: TextStyle(
                            fontFamily: 'Franklin',
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myCustomColor, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius here
                            ),
                            child: TextField(
                              controller: input1,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              focusNode: _focusNode1,
                              cursorColor: myCustomColor1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode2);
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myCustomColor, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius here
                            ),
                            child: TextField(
                              controller: input2,
                              keyboardType: TextInputType.number,
                              focusNode: _focusNode2,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              cursorColor: myCustomColor1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode3);
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myCustomColor, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius here
                            ),
                            child: TextField(
                              controller: input3,
                              keyboardType: TextInputType.number,
                              focusNode: _focusNode3,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              cursorColor: myCustomColor1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode4);
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myCustomColor, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius here
                            ),
                            child: TextField(
                              controller: input4,
                              keyboardType: TextInputType.number,
                              focusNode: _focusNode4,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              cursorColor: myCustomColor1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode5);
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myCustomColor, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius here
                            ),
                            child: TextField(
                              controller: input5,
                              keyboardType: TextInputType.number,
                              focusNode: _focusNode5,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              cursorColor: myCustomColor1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode6);
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myCustomColor, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius here
                            ),
                            child: TextField(
                              controller: input6,
                              keyboardType: TextInputType.number,
                              focusNode: _focusNode6,
                              cursorColor: myCustomColor1,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Le code expire dans $minutesStr:$secondsStr",
                      style: TextStyle(
                          fontFamily: 'Franklin',
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          String code = input1.text +
                              input2.text +
                              input3.text +
                              input4.text +
                              input5.text +
                              input6.text;
                          ;
                          print(code);
                          verifyCodeRegister(code, widget.isPatient,
                              (String tokenCode) {
                            if (widget.isPatient) {
                              // Navigation vers l'écran du patient avec le tokenCode
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AuthPatient(tokenCode: tokenCode),
                                ),
                              );
                            } else {
                              // Navigation vers l'écran du professionnel de la santé avec le tokenCode
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfSanteSignUp(tokenCode: tokenCode),
                                ),
                              );
                            }
                          });
                        },
                        child: Text(
                          "Vérifier",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: myfont,
                            fontWeight: FontWeight.bold,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Renvoyer le code",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: myfont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Background color
                          foregroundColor: myCustomColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // Rounded corners
                          ),
                          side: BorderSide(
                            color: myCustomColor, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
