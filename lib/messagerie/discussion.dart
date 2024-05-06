import 'package:flutter/material.dart';
import 'package:ycmedical/messagerie/Message.dart';

class Messagea extends StatefulWidget {
  @override
  State<Messagea> createState() => _MessageaState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _MessageaState extends State<Messagea> {
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
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            // Boutons pour basculer entre Discussions et Amies
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _onItemTapped(0),
                      child: Text(
                        'Discussion',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: myfont,
                          letterSpacing: 1.5,
                          color: _selectedIndex == 0
                              ? Colors.white
                              : myCustomColor, // Utiliser la couleur blanche si sélectionné
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                        backgroundColor: _selectedIndex == 0
                            ? myCustomColor
                            : Colors
                                .transparent, // Utiliser la couleur de fond bleue si sélectionné
                      ),
                    ),
                    TextButton(
                      onPressed: () => _onItemTapped(1),
                      child: Text(
                        'Ami(e)s',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: myfont,
                          letterSpacing: 1.5,
                          color: _selectedIndex == 1
                              ? Colors.white
                              : myCustomColor, // Utiliser la couleur blanche si sélectionné
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                        backgroundColor: _selectedIndex == 1
                            ? myCustomColor
                            : Colors
                                .transparent, // Utiliser la couleur de fond bleue si sélectionné
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Partie qui change en fonction du bouton sélectionné
            _selectedIndex == 0
                ? SliverToBoxAdapter(
                    child: Container(child: DiscussionWidget()),
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
