import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ycmedical/data/widget.dart/cities.dart';
import 'package:ycmedical/data/widget.dart/pays.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../posts/post.dart';

class Modif_profil extends StatefulWidget {
  const Modif_profil({super.key});

  @override
  State<Modif_profil> createState() => _Modif_profilState();
}

class _Modif_profilState extends State<Modif_profil> {
  String? _selectedImagePath;
  final TextEditingController nbrTel = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController Adress = TextEditingController();
   Future<void> _updateProfile() async {
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');

      if (accessToken == null) {
        print('Access token not found');
        return;
      }

      final uri = Uri.parse('http://10.0.2.2:3000/api/user/updateUser');
      var request = http.MultipartRequest('PUT', uri);

      // Adding text fields
      request.fields['phoneNumber'] = nbrTel.text;
      request.fields['country'] = _paysController.text;
      request.fields['city'] = countryController.text;

      // Adding image file
      if (_selectedImagePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profil', _selectedImagePath!,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Adding headers
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Log request details
      print('Sending request to $uri');
      print('Request headers: ${request.headers}');
      print('Request fields: ${request.fields}');
      if (request.files.isNotEmpty) {
        print('Request files: ${request.files.first.field}');
      }

      // Sending request
      var response = await request.send();

      // Log response status
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var result = json.decode(responseData);
        if (result['success']) {
          // Handle success
          print('Profile updated successfully');
          _clearAllFields();
        } else {
          // Handle failure
          print('Failed to update profile: ${result['message']}');
        }
      } else {
        // Log response body for debugging
        var responseData = await response.stream.bytesToString();
        print('Response body: $responseData');
        print('Server error: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception occurred: $e');
    }
  }
  void _clearAllFields() {
    setState(() {
      nbrTel.clear();
      _paysController.clear();
      countryController.clear();
      Adress.clear();
      _selectedImagePath = null;
    });
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
        child: CustomScrollView(slivers: [
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
                    "Modifier le profil ",
                    style: TextStyle(
                      fontFamily: myfont,
                      fontSize: 20,
                      color: myCustomColor,
                    ),
                  ),
                  Image.asset(
                    "assets/image/pen.png",
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            /*decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),*/
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 137, 137,
                          137), // Background color matching AppTextField
                      borderRadius:
                          BorderRadius.circular(25.0), // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 137, 137, 137)
                              .withOpacity(0.6), // Shadow color
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 5), // Move the shadow downwards
                        ),
                      ],
                    ),
                    child: TextField(
                      onTap: () async {
                        final pickedFile = await ImagePicker().pickImage(
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
                        hintText: "Modifier la photo de profil",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(
                            215, 255, 255, 255), // Matching fill color
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(
                              25.0), // Matching border radius
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                      ),
                    ),
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
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 137, 137,
                          137), // Background color matching AppTextField
                      borderRadius:
                          BorderRadius.circular(25.0), // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 137, 137, 137)
                              .withOpacity(0.6), // Shadow color
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 5), // Move the shadow downwards
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: nbrTel,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontFamily: "ArialRounded",
                        fontSize: 15,
                        color: Color.fromARGB(239, 89, 111, 114),
                      ),
                      decoration: InputDecoration(
                        hintText: "Numéro de téléphone",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        /*suffixIcon: Icon(
        Icons.arrow_drop_down,
        size: 24.0,
        color: Color.fromARGB(224, 89, 111, 114),
      ),*/
                        filled: true,
                        fillColor: Color.fromARGB(
                            215, 255, 255, 255), // Matching fill color
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      PaysList(paysController: _paysController),
                      SizedBox(
                        height: 20,
                      ),
                      CityList(countryController: countryController),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 137, 137,
                          137), // Background color matching AppTextField
                      borderRadius:
                          BorderRadius.circular(25.0), // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 137, 137, 137)
                              .withOpacity(0.6), // Shadow color
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 5), // Move the shadow downwards
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: Adress,
                      cursorColor: myCustomColor1,
                      decoration: InputDecoration(
                        hintText: "Adresse",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 12,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(
                            215, 255, 255, 255), // Matching fill color
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(
                              25.0), // Matching border radius
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 180,
                    height: 40,
                    child: ElevatedButton(
                      
                         onPressed: _updateProfile,
                      
                      child: Text(
                        "Modifier",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: myfont,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myCustomColor, // Background color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // Rounded corners
                        ),
                      ),
                    ),
                  )
                ]),
          ))
        ]),
      ),
    );
  }
}
