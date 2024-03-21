import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ycmedical/data/widget.dart/cities.dart';
import 'package:ycmedical/data/widget.dart/pays.dart';
import 'package:ycmedical/data/widget.dart/specilaite.dart';

class ProfSanteSignUp extends StatefulWidget {
  const ProfSanteSignUp({super.key});

  @override
  State<ProfSanteSignUp> createState() => _ProfSanteSignUpState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'FSPDemoUniformPro';

class _ProfSanteSignUpState extends State<ProfSanteSignUp> {
  var selectedGender;
  // les **************** controller **
  TextEditingController _filecontroller = TextEditingController();
  String? _selectedFileName;

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
                  fontFamily: 'FSPDemoUniformPro',
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                child: Column(
                  children: [
                    PaysList(),
                    SizedBox(
                      height: 20,
                    ),
                    CityList(),
                    SizedBox(
                      height: 20,
                    ),
                    SpecialiteList(),
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
                            fontFamily: "FSPDemoUniformPro",
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
                        controller: specialiteController,
                      
                          // open file
                          final file = result!.files.first;
                          openFile(file);
                          print('path: ${file.path}');
                          print('extension: ${file.extension}');
                          final newFile = await saveFilePermanenetly(file);
                          print('From path: ${file.path}');
                          print('To Path : ${newFile.path}');
                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              _selectedFileName = result.files.first.name;
                            });
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_file),
                          hintText: _selectedFileName ??
                              "Attacher votre preuved'identité médicale",
                          hintStyle: TextStyle(
                            fontFamily: "FSPDemoUniformPro",
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
                        onPressed: () {},
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

  Future<File> saveFilePermanenetly(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
