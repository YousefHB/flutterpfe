import 'package:flutter/material.dart';
import 'signin.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class Passwordoublie extends StatefulWidget {
  const Passwordoublie({super.key});

  @override
  State<Passwordoublie> createState() => _PasswordoublieState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'FSPDemoUniformPro';

class _PasswordoublieState extends State<Passwordoublie> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();
  @override
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
                                builder: (context) => SigninScreen()),
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
                        "Mot de passe oublié ?",
                        style: TextStyle(
                            fontFamily: 'FSPDemoUniformPro',
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
                            fontFamily: 'FSPDemoUniformPro',
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
                        onPressed: () {},
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
