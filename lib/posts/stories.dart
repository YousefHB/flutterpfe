import 'package:flutter/material.dart';

class storie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/image/storie.png',
                    width: 80,
                    height: 80,
                  ),
                ],
              )))
    ]);
  }
}
