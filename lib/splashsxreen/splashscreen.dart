import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width of the screen
      height: MediaQuery.of(context).size.height, // Full height of the screen
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(56, 184, 196, 0.41),
            Color(
                0xFF38B8c4), // Dégradé de blanc à bleu pour la première moitié
            Color(
                0xFF38B8c4), // Dégradé de bleu à blanc pour la deuxième moitié
            Color.fromRGBO(56, 184, 196, 0.42),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.35, 0.93, 1.0],
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/image/logoblanc.png', // Path to your image asset
          width: 200, // Adjust width as needed    123456
          height: 200, // Adjust height as needed
        ),
      ),
    );
  }
}
