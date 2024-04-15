import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'Invit.dart';
import 'Message.dart';
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
    var items = <Widget>[
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
      Icon(Icons.add_a_photo, size: 30),
      Icon(Icons.notification_add, size: 30),
      Icon(Icons.home, size: 30),
      Icon(Icons.insert_invitation, size: 30),
      Icon(Icons.message, size: 30),
    ];
    final List<Widget> _screens = [
      Addpost(),
      Notif(),
      Homescreen(),
      Invit(),
      Message(),
    ];
    return Scaffold(
      body: _screens[index],
      // Theme(
      //data: Theme.of(context).copyWith(

      //  ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(207, 182, 234, 238),
        key: navigationKey,
        backgroundColor: Colors.transparent,
        height: 60,
        index: index,
        items: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return GestureDetector(
            onTap: () => setState(() {
              this.index = index;
              items[index] = items[index] == _replacementIcons[index]
                  ? item
                  : _replacementIcons[index];
            }),
            child: item,
          );
        }).toList(),
        onTap: (newIndex) => setState(() => this.index = newIndex),
      ),
    );
  }
}
