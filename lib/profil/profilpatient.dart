import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/config.dart';

class ProfilPatient extends StatefulWidget {
  const ProfilPatient({super.key});

  @override
  State<ProfilPatient> createState() => _ProfilPatientState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _ProfilPatientState extends State<ProfilPatient> {
  List<Map<String, dynamic>> posts = [];

  late Map<String, dynamic> _userInfo;

// Déclaration de _userInfo

  @override
  void initState() {
    super.initState();

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

// Définissez une fonction pour convertir les URLs d'images
  String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
  }

// Dans votre méthode fetchUserInfo
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

        return userInfo;
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user info: $error');
    }
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
            child: Container(
          width: screenSize.width,
          height: screenSize.height,
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
          child: Center(
            child: Column(
              children: [
                Container(
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
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 700,
                  height: 700,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [myCustomColor, myCustomColor1],
                    ),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(2),
                  child: Image.network('${_userInfo['user']['photoProfil']} '),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
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
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Rounded corners
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
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 6),
                            backgroundColor: const Color.fromARGB(
                                0, 255, 255, 255), // Background color
                            foregroundColor: myCustomColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Rounded corners
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
                Container(
                  padding: EdgeInsets.all(20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Aligner les enfants au début

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
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
