import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../posts/post.dart';
import 'add_page.dart';
import 'page_detaill.dart'; // Import the Page_detaill widget

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PageState();
}

class _PageState extends State<Pages> {
  List<Map<String, dynamic>> _userPages = [];

  Future<void> _fetchUserPages() async {
    try {
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/page/getUserPages'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          var pages = data['data'];
          setState(() {
            _userPages = List<Map<String, dynamic>>.from(pages);
          });
          print(_userPages);
        } else {
          print('Erreur: ${data['msg']}');
        }
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserPages();
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
                    Text(
                      "Pages",
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 20,
                        color: myCustomColor,
                      ),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 45),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Créer une page",
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 18,
                        color: myCustomColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ajoute_page(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mes pages",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 17,
                        color: myCustomColor,
                      ),
                    ),
                    Divider(
                      color: myCustomColor,
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var page = _userPages[index];
                  return GestureDetector(
                    onTap: () {
                      print(page['_id']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Page_detaill(PageId: page['_id']),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                      elevation: 5,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                page['photoPage']['url']
                                    .replaceAll('localhost', '10.0.2.2'),
                              ),
                              radius: 25,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                page['nom'],
                                style: TextStyle(
                                  fontFamily: myfont,
                                  fontSize: 20,
                                  color: myCustomColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _userPages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
