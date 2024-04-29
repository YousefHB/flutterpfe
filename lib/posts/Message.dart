import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  @override
  State<Message> createState() => _NotifState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _NotifState extends State<Message> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(233, 254, 255, 1),
              Color.fromRGBO(214, 252, 255, 1),
              Color.fromRGBO(212, 250, 255, 1),
              Color.fromRGBO(221, 253, 255, 0.965),
            ],
            stops: [0.0, 0.5, 0.8, 1],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Partie constante
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/image/back.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Text("Discussions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 17,
                          color: myCustomColor,
                        )),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.menu),
                    ),
                  ],
                ),
              ),
            ),
            // Boutons pour basculer entre Discussions et Amies
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onItemTapped(0),
                      child: Text('Discussions',
                          style: TextStyle(
                            fontFamily: myfont,
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myCustomColor, // Background color
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                        side: BorderSide(
                          color: myCustomColor, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _onItemTapped(1),
                      child: Text(
                        'Amies',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: myfont,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                        backgroundColor: Color.fromARGB(
                            255, 255, 255, 255), // Background color
                        foregroundColor: myCustomColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                        side: BorderSide(
                          color: myCustomColor, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Partie qui change en fonction du bouton sélectionné
            _selectedIndex == 0
                ? SliverToBoxAdapter(
                    child: Container(
                      child: Center(
                        child: Text(
                            "Bienvenue dans la messagerie ! \n N'hésitez pas à commencer une nouvelle \n conversation avec un collègue ou un patient",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: myfont,
                              fontSize: 15,
                              color: myCustomColor,
                            )),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Container(
                      child: Text("helloooooooo"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
