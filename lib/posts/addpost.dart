import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';

import 'homescreen.dart';

class Addpost extends StatefulWidget {
  const Addpost({Key? key}) : super(key: key);

  @override
  State<Addpost> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Addpost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedImagePath;
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedImagePath =
        null; // Initialisation de _selectedImagePath à null dans initState
  }

  void _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('Aucune image sélectionnée.');
    } else {
      print('Image sélectionnée : $pickedFile');
      setState(() {
        _selectedImagePath = pickedFile.path;
        print('Chemin de l\'image sélectionnée : $_selectedImagePath');
      });
    }
  }

  void _publishPost() async {
    // URL de votre API pour publier les posts
    final String apiUrl = 'http://192.168.56.1:3000/posts';

    // Création de la requête HTTP pour envoyer l'image et le texte à l'API
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Ajouter l'image avec le bon type de contenu
    request.files.add(await http.MultipartFile.fromPath(
      'images',
      _selectedImagePath!,
      contentType: MediaType('image',
          'png'), // Spécifier le type de contenu directement comme 'image/png'
    ));

    // Ajout du texte du champ de texte à la requête
    request.fields['content'] = _textFieldController.text;

    // Envoi de la requête à l'API
    var response = await request.send();

    // Vérification du code de réponse de l'API
    if (response.statusCode == 201) {
      print('Publication réussie !');

      // Effacer le contenu du TextField et réinitialiser l'image sélectionnée
      _textFieldController.clear(); // Effacer le contenu du TextField
      setState(() {
        _selectedImagePath = null; // Réinitialiser l'image sélectionnée
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("publication reussi"),
        action: SnackBarAction(label: "undo", onPressed: () {}),
      ));
    } else {
      print('Échec de la publication. Code d\'état: ${response.statusCode}');
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
                   /* Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return Homescreen();
                    }));*/
                  },
                     child: Image.asset(
                        'assets/images/back.png',
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
                            Image.asset(
                              'assets/images/profile.png',
                              width: 50,
                              height: 50,
                            ),
                            Text("Lorem ipsum"),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _publishPost,
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
                    // Affichage de l'image sélectionnée
                    child: Column(
                      children: [
                        if (_selectedImagePath != null)
                          Image.file(
                            File(_selectedImagePath!),
                            width: 300,
                            height: 300,
                            fit: BoxFit
                                .cover, // Ajuste l'image pour couvrir la boîte de 100x100
                          )
                        else
                          SizedBox(
                              width: 100,
                              height:
                                  100), // Si aucune image n'est sélectionnée, afficher un SizedBox de 100x100
                      ],
                    ),
                  ),
                  SizedBox(height: 250.0),
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
                                                    SizedBox(height: 30,),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _pickImageFromGallery();
                                                        print(
                                                            "gallery clicked");
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/gallerie.png',
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
                                                            'assets/images/tag.png',
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
                                                            'assets/images/localisation.png',
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
                                                            'assets/images/video-call.png',
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
                                                            'assets/images/camera.png',
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
                                _pickImageFromGallery();
                                print("gallri clicked");
                              },
                              child: Image.asset(
                                'assets/images/gallerie.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de l'étiquette
                              },
                              child: Image.asset(
                                'assets/images/tag.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de la localisation
                              },
                              child: Image.asset(
                                'assets/images/localisation.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de l'appel vidéo
                              },
                              child: Image.asset(
                                'assets/images/video-call.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Logique à exécuter lors du clic sur l'image de l'appareil photo
                              },
                              child: Image.asset(
                                'assets/images/camera.png',
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
