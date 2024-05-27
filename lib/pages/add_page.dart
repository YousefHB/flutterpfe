import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../posts/post.dart';

class Ajoute_page extends StatefulWidget {
  const Ajoute_page({super.key});

  @override
  State<Ajoute_page> createState() => _Ajoute_pState();
}

class _Ajoute_pState extends State<Ajoute_page> {
  final TextEditingController pageName = TextEditingController();
  final TextEditingController pageDesc = TextEditingController();
  String? _selectedImagePath;

   Future<void> _createPage() async {
      final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final uri = Uri.parse('http://10.0.2.2:3000/api/page/createPage');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['nom'] = pageName.text;
    request.fields['description'] = pageDesc.text;

    if (_selectedImagePath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photoCouverture',
        _selectedImagePath!,
        contentType: MediaType('photoCouverture', 'png'),
      ));
    }

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      print('Page created successfully: ${responseBody.body}');
    } else {
      print('Failed to create page: ${responseBody.body}');
    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Créer Page",
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 20,
                        color: myCustomColor,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: pageName,
                      cursorColor: myCustomColor1,
                      decoration: InputDecoration(
                        hintText: "Nom de page",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                      ),
                    ),
                      SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: pageDesc,
                      cursorColor: myCustomColor1,
                      decoration: InputDecoration(
                        hintText: "Description sur la page",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onTap: () async {
                        final pickedFile =
                            await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile == null) {
                          print('Aucune image sélectionnée.');
                        } else {
                          print('Image sélectionnée : ${pickedFile.path}');
                          setState(() {
                            _selectedImagePath = pickedFile.path;
                          });
                        }
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          'assets/image/gallerie.png',
                          width: 5,
                          height: 5,
                        ),
                        hintText: "Sélectionnez une photo de couverture",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                      ),
                      
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_selectedImagePath != null)
                      Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ElevatedButton(
                    onPressed: () {
                      _createPage();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: myCustomColor, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(28.0), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 65), // Adjust padding as needed
                    ),
                    child: Text(
                      'Créer page',
                      style: TextStyle(
                        fontFamily: 'ArialRounded',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

