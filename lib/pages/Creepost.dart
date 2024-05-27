import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:ycmedical/config.dart';

import '../posts/post.dart';
/*import 'MainHomeNavigator.dart';
import 'homescreen.dart';
import 'post.dart';*/

class AddpostPage extends StatefulWidget {
  final String PageId;
  const AddpostPage({Key? key, required this.PageId}) : super(key: key);


  @override
  State<AddpostPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddpostPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String>? _selectedImagePaths;
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedImagePaths =
        null; // Initialisation de _selectedImagePath à null dans initState
  }

  void _pickImagesFromGallery() async {
  final pickedFiles = await ImagePicker().pickMultiImage();
  if (pickedFiles == null || pickedFiles.isEmpty) {
    print('Aucune image sélectionnée.');
  } else {
    print('Images sélectionnées : $pickedFiles');
    setState(() {
      _selectedImagePaths = pickedFiles.map((file) => file.path).toList();
    });
  }
}


  void _publishPost(String PageId) async {
    // Vérifier si au moins l'un des deux champs est rempli
    if(_textFieldController.text.isEmpty &&
      (_selectedImagePaths == null || _selectedImagePaths!.isEmpty)){
      // Afficher un message à l'utilisateur indiquant qu'il doit entrer du texte ou sélectionner une image
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Veuillez entrer du texte ou sélectionner une image."),
      ));
      return; // Arrêter la fonction si les deux champs sont vides
    }

    // URL de votre API pour publier les posts
    final String apiUrl = 'http://10.0.2.2:3000/api/page/createPostPage/$PageId';

    // Récupération du token JWT de l'utilisateur
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    // Création de la requête HTTP pour envoyer le texte et le token JWT à l'API
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Ajout des images à la requête si elles existent
    // Ajout des images à la requête si elles existent
if (_selectedImagePaths != null && _selectedImagePaths!.isNotEmpty) {
  for (String path in _selectedImagePaths!) {
    request.files.add(await http.MultipartFile.fromPath(
      'images',
      path,
      contentType: MediaType('image', 'png'),
    ));
  }
}


    // Ajout du texte du champ de texte à la requête si le champ de texte n'est pas vide
    if (_textFieldController.text.isNotEmpty) {
      request.fields['content'] = _textFieldController.text;
    }

    // Envoi de la requête à l'API
    var response = await request.send();

    // Vérification du code de réponse de l'API
    if (response.statusCode == 201) {
      print('Publication réussie !');

      // Effacer le contenu du TextField et réinitialiser l'image sélectionnée
      _textFieldController.clear(); // Effacer le contenu du TextField
      setState(() {
        _selectedImagePaths = null; // Réinitialiser l'image sélectionnée
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Publication réussie"),
        action: SnackBarAction(label: "Undo", onPressed: () {}),
      ));
    } else {
      print('Échec de la publication. Code d\'état: ${response.statusCode}');
      // Afficher un message d'erreur en cas d'échec de la publication
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Échec de la publication. Code d'état: ${response.statusCode}"),
      ));
    }
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: [
            Container(
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 110,
                      ),
                      GestureDetector(
                        onTap: () {
                          /*    Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => Homescreen()));

            // Update navigation state in MainNav
            if (context.findAncestorStateOfType<MainNavState>() != null) {
              context.findAncestorStateOfType<MainNavState>()!
                  .setState(() => context
                      .findAncestorStateOfType<MainNavState>()!.index= 2); 
            }*/
                        },
                        child: Image.asset(
                          'assets/image/back.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      Text(
                        "Crée une publication",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 00.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
  radius: 25, // La moitié de la largeur et de la hauteur pour obtenir un diamètre de 50
  backgroundImage: AssetImage('assets/image/1713728551769.jpeg'),
),

                            Text("  melek rekik",
                            style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 18,
                          color: myCustomColor,
                        ),
                            
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => _publishPost(widget.PageId),

                          child: Text(
                            'publier',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Faito",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF009EE2),
                            backgroundColor: Color(0xFF009EE2),
                            fixedSize: Size(double.infinity, 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 00.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Quoi de neuf ?",
                            labelStyle: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    // Affichage des images sélectionnées
                    height:
                        300, // Définir une hauteur fixe pour la liste horizontale
                    child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal, // Faire défiler horizontalement
                      itemCount: (_selectedImagePaths ?? []).length,// Nombre d'images sélectionnées
                      itemBuilder: (context, index) {
                        // Construire chaque élément de la liste
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.file(
                            File(_selectedImagePaths![index]),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 150.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 00.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.blue,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 00.0),
                                      height: 400,
                                      width: screenSize.width,
                                      child: SizedBox(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              /*border: Border.all(
                                             color: Colors.blue,
                                               ),*/
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _pickImagesFromGallery();
                                                        print(
                                                            "gallery clicked");
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/image/gallerie.png',
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  10), // Espacement entre l'image et le texte
                                                          Text("Photo/Video"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Logique à exécuter lors du clic sur l'image de l'étiquette
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/image/tag.png',
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                              "Identifier des personnes"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Logique à exécuter lors du clic sur l'image de l'étiquette
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/image/localisation.png',
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text("Je suis la"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Logique à exécuter lors du clic sur l'image de l'étiquette
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/image/video-call.png',
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text("Video Call"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Logique à exécuter lors du clic sur l'image de l'étiquette
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/image/camera.png',
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                              "Appareill Photo"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.horizontal_rule,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de la galerie
                                _pickImagesFromGallery();
                                print("gallri clicked");
                              },
                              child: Image.asset(
                                'assets/image/gallerie.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de l'étiquette
                              },
                              child: Image.asset(
                                'assets/image/tag.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de la localisation
                              },
                              child: Image.asset(
                                'assets/image/localisation.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de l'appel vidéo
                              },
                              child: Image.asset(
                                'assets/image/video-call.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de l'appareil photo
                              },
                              child: Image.asset(
                                'assets/image/camera.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
