import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';

import 'post.dart';
import 'stories.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, dynamic>> posts = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse(getpost);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(data.map((item) {
            List<String> images =
                (item['images'] as List<dynamic>).map((image) {
              return image.toString().replaceAll('localhost', '192.168.56.1');
            }).toList();
            item['images'] = images;
            return item;
          }));
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(127, 219, 252, 255),
              Color.fromARGB(207, 182, 234, 238),
              Color.fromARGB(172, 187, 253, 248),
              Color.fromARGB(171, 219, 252, 255),
            ],
            stops: [0.0, 0.4, 0.6, 1],
          ),
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'assets/image/logo.png',
                        width: 70,
                        height: 100,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("loupe pressed");
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            'assets/image/loupe.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/image/param.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(child: storie()),
            SizedBox(
              height: 20,
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length >= 5 ? 5 : posts.length,
                itemBuilder: (context, index) {
                  final postData = posts[index];
                  final postContent = postData['content'];
                  final postImages = postData['images'];

                  return Post(
                    content: postContent,
                    images: postImages,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 56, 184, 196),
                Color.fromARGB(255, 56, 184, 196),
                Color.fromARGB(255, 214, 244, 247),
              ],
              stops: [0.6, 0.5, 0.9],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: DrawerHeader(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/back.png',
                            width: 30,
                            height: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/image/profile.png',
                            width: 60,
                            height: 60,
                          ),
                          Text(
                            "Lorem ipsum",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                          ),
                          Container(
                            color: Colors.transparent,
                            child: SizedBox(
                                width: 100,
                                height: 28,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.white, width: 1.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Voir profile',
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.white),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/image/groupes.png',
                      width: 100,
                      height: 60,
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Image.asset(
                      'assets/image/page.png',
                      width: 90,
                      height: 40,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 13),
                    Image.asset(
                      'assets/image/evenements.png',
                      width: 145,
                      height: 75,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 7),
                    Image.asset(
                      'assets/image/suivies.png',
                      width: 135,
                      height: 25,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 17),
                    Image.asset(
                      'assets/image/enregistrements1.png',
                      width: 155,
                      height: 60,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 2),
                    Image.asset(
                      'assets/image/marketplace.png',
                      width: 155,
                      height: 34,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 25),
                    Image.asset(
                      'assets/image/carte.png',
                      width: 255,
                      height: 90,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 3),
                    Image.asset(
                      'assets/image/parameters.png',
                      width: 155,
                      height: 30,
                    ),
                  ],
                ),
              ),
              // Ajouter plus d'éléments au besoin
            ],
          ),
        ),
      ),
    );
  }
}
