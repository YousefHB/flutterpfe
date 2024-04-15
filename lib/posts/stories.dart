import 'package:flutter/material.dart';

class storie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: () {
          print("add stories");
        },
        child: Image.asset(
          'assets/image/storieadd.png',
          width: 90,
          height: 90,
        ),
      ),
      const SizedBox(width: 10.0),
      Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("storie pressed");
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/image/storie.png',
                            width: 90,
                            height: 90,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Votre Texte ici',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 90,
                    height: 90,
                  ),
                ],
              )))
    ]);
  }
}
