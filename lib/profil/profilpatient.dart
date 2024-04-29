import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/config.dart';
import 'package:ycmedical/posts/post.dart';

class ProfilPatient extends StatefulWidget {
  const ProfilPatient({Key? key}) : super(key: key);

  @override
  State<ProfilPatient> createState() => _ProfilPatientState();
}

class _ProfilPatientState extends State<ProfilPatient> {
  List<Map<String, dynamic>> posts = [];
  late Map<String, dynamic> _userInfo;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _userInfo = {};
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      return;
    }

    try {
      final Map<String, dynamic> fetchedUserInfo =
          await fetchUserInfo(accessToken);
      setState(() {
        _userInfo = fetchedUserInfo;
      });
    } catch (error) {
      print('Error fetching user info: $error');
    }
  }

  String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
  }

  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(userinfo),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userInfo = jsonDecode(response.body);

        userInfo['user']['photoProfil'] =
            convertImageUrl(userInfo['user']['photoProfil']);
        userInfo['user']['photoCouverture'] =
            convertImageUrl(userInfo['user']['photoCouverture']);

        return userInfo;
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user info: $error');
    }
  }

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
                        )),
                    Text(
                        _userInfo.isNotEmpty
                            ? '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}'
                            : 'Chargement...', // le nom de patient ici
                        style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 20,
                          color: myCustomColor,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/image/menudot.png",
                          width: 30,
                          height: 30,
                        )),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.5, // épaisseur de la bordure
                          color: Colors
                              .transparent, // couleur de la bordure (transparente pour ne pas interférer avec le dégradé)
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            myCustomColor1,
                            myCustomColor,
                          ], // couleurs du dégradé
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                          _userInfo['user']['photoProfil'] ??
                              'assets/image/people.png',
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    _userInfo.isNotEmpty
                        ? Text(
                            '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}',
                            style: TextStyle(
                              fontSize: 20,
                              color: myCustomColor,
                              fontFamily: myfont,
                            ),
                          )
                        : CircularProgressIndicator(),
                    SizedBox(height: 20),
                    // Affichez d'autres informations sur l'utilisateur ici
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("200 \n Ami(e)s",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: myfont,
                            fontSize: 17,
                            color: myCustomColor,
                          )),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "+ Ajouter à la story",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: myfont,
                          ),
                        ),
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
                      OutlinedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image/pen.png",
                              width: 15,
                              height: 15,
                            ),
                            Text(
                              " Modifier le profil",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: myfont,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                          backgroundColor: const Color.fromARGB(
                              0, 255, 255, 255), // Background color
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
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                  child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Publications",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 17,
                        color: myCustomColor,
                      ),
                    ),
                    Divider(
                      color: myCustomColor, // Couleur du Divider
                      thickness: 1, // Épaisseur du Divider
                      height: 1, // Hauteur du Divider
                    ),
                  ],
                ),
              )),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final postData = posts[index];
                  final postid = postData['_id'];
                  final postContent = postData['content'];
                  final postImages = postData['images'];

                  final firstName = postData['firstName'];
                  final lastName = postData['lastName'];
                  final createdAt = postData['createdAt'];
                  final photoProfil = postData['profilePhotoUrl'];
                  final userId = postData['createdBy']['_id'];
                  // Ajouter l'ID de l'utilisateur

                  return Post(
                    content: postContent,
                    postid: postid,
                    images: postImages,
                    firstName: firstName,
                    lastName: lastName,
                    createdAt: createdAt,
                    profilePhotoUrl: photoProfil,
                    createdByUserId: userId,
                    onTapUserName: (userId) {
                      // Définir le comportement lorsqu'on clique sur le nom de l'utilisateur
                      print(
                          'User ID: $userId'); // Par exemple, imprime l'ID de l'utilisateur dans la console
                    },
                  );
                },
                childCount: posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse(getmypost);
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(data.map((item) {
            List<String> images =
                (item['images'] as List<dynamic>).map((image) {
              return image.toString().replaceAll('localhost', '10.0.2.2');
            }).toList();
            item['images'] = images;
            final createdBy = item['createdBy'];
            final id = item['_id'];
            final firstName = createdBy['firstName'];
            final lastName = createdBy['lastName'];
            final createdAt = item['createdAt'];
            String profilePhotoUrl =
                (item['createdBy']['photoProfil']['url'] as String)
                    .replaceAll('localhost', '10.0.2.2');

            item['firstName'] = firstName;
            item['lastName'] = lastName;
            item['createdAt'] = createdAt;
            item['profilePhotoUrl'] = profilePhotoUrl;
            item['_id'] = id;
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
}
