import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ycmedical/messagerie/discussion.dart';

import 'Invit.dart';
import '../messagerie/Message.dart';
import 'Notif.dart';
import 'addpost.dart';
import 'homescreen.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => MainNavState();
}

class MainNavState extends State<MainNav> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;
  @override
  Widget build(BuildContext context) {
    List<Widget> _iconpardefaut = <Widget>[
      Image.asset(
        'assets/image/addpost.png',
        width: 45,
        height: 45,
      ),
      Image.asset(
        'assets/image/notif.png',
        width: 45,
        height: 45,
      ),
      Image.asset(
        'assets/image/home.png',
        width: 45,
        height: 45,
      ),
      Image.asset(
        'assets/image/invitation.png',
        width: 45,
        height: 45,
      ),
      Image.asset(
        'assets/image/message.png',
        width: 45,
        height: 45,
      ),
    ];
    List<Widget> _replacementIcons = [
      Image.asset(
        'assets/image/add-post-icon.png',
        width: 50,
        height: 50,
      ),
      Image.asset(
        'assets/image/notification-icon.png',
        width: 50,
        height: 50,
      ),
      Image.asset(
        'assets/image/home-icon.png',
        width: 50,
        height: 50,
      ),
      Image.asset(
        'assets/image/inv-icone.png',
        width: 50,
        height: 50,
      ),
      Image.asset(
        'assets/image/message-icon.png',
        width: 50,
        height: 50,
      ),
    ];
    final List<Widget> _screens = [
      Addpost(),
      Notif(),
      Homescreen(),
      Invit(),
      Messagea(),
    ];
    return Scaffold(
      body: _screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(207, 210, 252, 255),
        key: navigationKey,
        backgroundColor: Colors.transparent,
        height: 60,
        index: index,
        items: _iconpardefaut.asMap().entries.map((entry) {
          final int currentIndex = entry.key;
          final Widget currentWidget = entry.value;

          return GestureDetector(
            onTap: () => setState(() {
              index = currentIndex;
            }),
            child: currentIndex == index
                ? _replacementIcons[currentIndex]
                : currentWidget,
          );
        }).toList(),
        onTap: (newIndex) => setState(() {
          index = newIndex;
        }),
      ),
    );
  }
}
