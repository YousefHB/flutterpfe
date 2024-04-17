import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ycmedical/config.dart';
import 'package:ycmedical/data/widget.dart/cities.dart';
import 'package:ycmedical/data/widget.dart/pays.dart';
import 'package:ycmedical/data/widget.dart/specilaite.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ycmedical/view/authentification/signin.dart';

class ProfSanteSignUp extends StatefulWidget {
  final String tokenCode; // Ajouter un champ pour le token

  ProfSanteSignUp({required this.tokenCode});
  @override
  State<ProfSanteSignUp> createState() => _ProfSanteSignUpState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _ProfSanteSignUpState extends State<ProfSanteSignUp> {
  var selectedGender;
  PlatformFile? selectedFile;
  TextEditingController fileController =
      TextEditingController(); // Nouveau contrôleur pour le champ de fichier

  final TextEditingController countryController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  TextEditingController specialiteController = TextEditingController();
  File? _selectedFile;
  List<File> _selectedFiles =
      []; // Modifier le type de _selectedFile pour contenir une liste de fichiers

  List<PlatformFile> selectedFiles = [];

  @override
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
              Color.fromRGBO(100, 218, 229, 0.854),
              Color.fromRGBO(146, 226, 232, 0.886),
              Color.fromRGBO(194, 248, 255, 0.922),
              Color.fromRGBO(222, 248, 255, 0.664),
            ],
            stops: [0.0, 0.27, 0.47, 1],
          ),
        ),
        child: Center(
            child: Container(
          margin: EdgeInsetsDirectional.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "créer un compte",
                style: TextStyle(
                  fontFamily: 'ArialRounded',
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                child: Column(
                  children: [
                    PaysList(paysController: _paysController),
                    SizedBox(
                      height: 20,
                    ),
                    CityList(countryController: countryController),
                    SizedBox(
                      height: 20,
                    ),
                    SpecialiteList(specController: specialiteController),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            215, 255, 255, 255), // Background color
                        borderRadius:
                            BorderRadius.circular(25.0), // Border radius
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 137, 137, 137)
                                .withOpacity(0.6), // Couleur de l'ombre
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 5), // Déplace l'ombre vers le bas
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text(
                            "Genre",
                          ),
                          style: TextStyle(
                            fontFamily: "ArialRounded",
                            fontSize: 12,
                            color: Color.fromARGB(239, 89, 111, 114),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: ["Homme", "Femme"]
                              .map((e) => DropdownMenuItem(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedGender = val!;
                            });
                          },
                          value: selectedGender),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            215, 255, 255, 255), // Background color
                        borderRadius:
                            BorderRadius.circular(25.0), // Border radius
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 137, 137, 137)
                                .withOpacity(0.6), // Couleur de l'ombre
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 5), // Déplace l'ombre vers le bas
                          ),
                        ],
                      ),
                      child: TextField(
                        onTap: () async {
                          await _chooseFiles(); // Appeler la fonction _chooseFiles() pour choisir des fichiers
                          if (_selectedFiles.isNotEmpty) {
                            setState(() {
                              fileController.text = _selectedFiles
                                  .map((file) => file.path)
                                  .join(
                                      ", "); // Mettre à jour le texte avec les chemins des fichiers sélectionnés
                            });
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_file),
                          hintText: _selectedFiles.isNotEmpty
                              ? _selectedFiles.map((file) => file.path).join(
                                  ", ") // Afficher tous les chemins de fichiers sélectionnés s'il y en a
                              : "Sélectionnez un fichier",

                          hintStyle: TextStyle(
                            fontFamily: "ArialRounded",
                            fontSize: 12,
                            color: Color.fromARGB(224, 89, 111, 114),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          //alignLabelWithHint: true, // Center label vertically
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 170,
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          "Crée",
                          style: TextStyle(
                            fontSize: 15,
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
                    ),
                  ],
                ),
              )
            ],
          ),
        )),
      ))),
    );
  }

  /*Future<void> _chooseFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }*/
  Future<void> _chooseFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Permettre la sélection de plusieurs fichiers
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.paths.map((path) => File(path!)).toList();
        fileController.text =
            _selectedFiles.map((file) => file.path).join(", ");
      });
    }
  }

  /*Future<void> _submitForm() async {
    print('selectedGender: $selectedGender');
    print('countryController.text: ${countryController.text}');
    print('_paysController.text: ${_paysController.text}');
    print('specialiteController.text: ${specialiteController.text}');
    print('_selectedFile: $_selectedFile');

    String token = widget.tokenCode;

    if (_selectedFile != null &&
        selectedGender.isNotEmpty &&
        countryController.text.isNotEmpty &&
        _paysController.text.isNotEmpty &&
        specialiteController.text.isNotEmpty) {
      var request = http.MultipartRequest(
          'POST', Uri.parse(url + '/api/auth/registerProfessionnel/$token'));
      request.fields['genre'] = selectedGender;
      request.fields['ville'] = countryController.text;
      request.fields['pays'] = _paysController.text;
      request.fields['specialite'] = specialiteController.text;
      request.files.add(
          await http.MultipartFile.fromPath('documents', _selectedFile!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Professionnel inscrit avec succès');
      } else {
        print('Erreur lors de l\'inscription: ${response.body}');
      }
    } else {
      print('Veuillez remplir tous les champs et choisir un document');
    }
  }*/
  Future<void> _submitForm() async {
    print('selectedGender: $selectedGender');
    print('countryController.text: ${countryController.text}');
    print('_paysController.text: ${_paysController.text}');
    print('specialiteController.text: ${specialiteController.text}');
    print(
        '_selectedFiles: $_selectedFiles'); // Utiliser _selectedFiles pour afficher tous les fichiers sélectionnés

    String token = widget.tokenCode;

    if (_selectedFiles.isNotEmpty &&
        selectedGender.isNotEmpty &&
        countryController.text.isNotEmpty &&
        _paysController.text.isNotEmpty &&
        specialiteController.text.isNotEmpty) {
      var request = http.MultipartRequest(
          'POST', Uri.parse(url + '/api/auth/registerProfessionnel/$token'));
      request.fields['genre'] = selectedGender;
      request.fields['city'] = countryController.text;
      request.fields['country'] = _paysController.text;
      request.fields['specialty'] = specialiteController.text;

      for (var file in _selectedFiles) {
        request.files
            .add(await http.MultipartFile.fromPath('documents', file.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Professionnel inscrit avec succès');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SigninScreen()));
      } else {
        print('Erreur lors de l\'inscription: ${response.body}');
      }
    } else {
      print('Veuillez remplir tous les champs et choisir un document');
    }
  }
}
