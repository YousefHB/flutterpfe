import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'FSPDemoUniformPro';

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30, 50, 40, 0),
            child: Image.asset(
              "assets/image/logo.png",
              width: 90,
              height: 70,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/image/medical.png",
                  width: 260,
                  height: 220,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Text(
                      "BEINVENUE A",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        fontFamily: myfont,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      " YC MEDICAL",
                      style: TextStyle(
                        fontSize: 27,
                        color: myCustomColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: myfont,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 210,
                      height: 60,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninScreen()),
                          );
                        },
                        child: Text(
                          "SE CONNECTER",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: myfont,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                          foregroundColor: myCustomColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // Rounded corners
                          ),
                          side: BorderSide(
                            color: myCustomColor, // Border color
                            width: 3.0, // Border width
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 210,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text(
                          "S'INSCRIRE",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: myfont,
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
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
