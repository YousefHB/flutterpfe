import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/profil/profilpatient.dart';

import 'post.dart';
import 'stories.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, dynamic>> posts = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<String, dynamic> _userInfo; // Déclaration de _userInfo

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _userInfo = {};
    _fetchUserInfo(); // Appelez fetchUserInfo lors de l'initialisation du widget pour récupérer les informations de l'utilisateur
  }

  String userName = '';
  Future<void> _fetchUserInfo() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      // Gérer le cas où aucun jeton d'accès n'est trouvé dans le stockage sécurisé
      return;
    }

    try {
      final Map<String, dynamic> fetchedUserInfo =
          await fetchUserInfo(accessToken);
      setState(() {
        _userInfo =
            fetchedUserInfo; // Mise à jour de _userInfo avec les informations de l'utilisateur
      });
    } catch (error) {
      print(
          'Erreur lors de la récupération des informations de l\'utilisateur: $error');
    }
  }

  /*Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(
            userinfo), // Remplacez 'URL_DE_VOTRE_API/getUserInfo' par votre propre URL
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        // Si la réponse est réussie, convertissez le corps de la réponse en un Map
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user info: $error');
    }
  }*/
  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(
            userinfo), // Replace 'URL_DE_VOTRE_API/getUserInfo' with your own URL
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        // If the response is successful, replace 'localhost' with your local IP address
        final Map<String, dynamic> userInfo = jsonDecode(response.body);
        String photoProfilUrl = userInfo['user']['photoProfil'];
        photoProfilUrl = photoProfilUrl.replaceAll('localhost', '10.0.2.2');
        userInfo['user']['photoProfil'] = photoProfilUrl;
        return userInfo;
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user info: $error');
    }
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
              return image.toString().replaceAll('localhost', '10.0.2.2');
            }).toList();
            item['images'] = images;
            String profilePhotoUrl =
                (item['createdBy']['photoProfil']['url'] as String)
                    .replaceAll('localhost', '10.0.2.2');
            final createdBy = item['createdBy'];
            final firstName = createdBy['firstName'];
            final lastName = createdBy['lastName'];
            final createdAt = item['createdAt'];

            // Updating item with user details
            item['firstName'] = firstName;
            item['lastName'] = lastName;
            item['createdAt'] = createdAt;
            item['profilePhotoUrl'] = profilePhotoUrl;
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
                  final firstName = postData['firstName'];
                  final lastName = postData['lastName'];
                  final createdAt = postData['createdAt'];
                  final photoProfil = postData['profilePhotoUrl'];
                  print('photoProfil: $photoProfil');
                  return Post(
                    content: postContent,
                    images: postImages,
                    firstName: firstName,
                    lastName: lastName,
                    createdAt: createdAt,
                    profilePhotoUrl: photoProfil,
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
                          Image.network(
                            'https://tse4.mm.bing.net/th?id=OIP.ItvA9eX1ZIYT8NHePqeuCgHaHa&pid=Api&P=0&h=180', // Utilisez l'URL de l'image de l'utilisateur si disponible, sinon utilisez une URL par défaut
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            _userInfo.isNotEmpty
                                ? '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}'
                                : 'Chargement...',
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilPatient()),
                                    );
                                  },
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
              Container(
                height: 50, // Augmenter la hauteur du bouton
                width: 50, // Augmenter la largeur du bouton
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                      spreadRadius: 5, // Rayon d'étalement de l'ombre
                      blurRadius: 7, // Flou de l'ombre
                      offset: Offset(0, 3), // Décalage de l'ombre
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Color.fromARGB(255, 56, 184, 196),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  child: Text(
                    "deconnexion",
                    style: TextStyle(
                      color: Color.fromARGB(255, 56, 184, 196),
                    ),
                  ),
                ),
              )

              // Ajouter plus d'éléments au besoin
            ],
          ),
        ),
      ),
    );
  }
}
