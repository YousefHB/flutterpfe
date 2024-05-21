import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ycmedical/config.dart';

class CardRendezVous extends StatefulWidget {
  final String profilID;
  final String? profilImage;
  final String? firstname;
  final String? lastname;
  final String? specialite;
  final String? city;
  final Function(String) onRequestAppointment;
  CardRendezVous({
    required this.profilID,
    this.profilImage,
    this.firstname,
    this.lastname,
    this.specialite,
    this.city,
    required this.onRequestAppointment,
  });

  @override
  State<CardRendezVous> createState() => _CardRendezVousState();
}

class _CardRendezVousState extends State<CardRendezVous> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();

  Future<void> _requestAppointment() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    try {
      // Retrieve the user ID from secure storage

      final response = await http.post(
        Uri.parse(url + '/rendezvous/appointments'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'doctorId': widget.profilID,
          'date': _dateController.text,
          'month': _monthController.text,
          'hour': _hourController.text,
        }),
      );

      if (response.statusCode == 201) {
        // If the request was successful
        print('Appointment created successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Rendez-vous créé avec succès!'),
        ));
      } else {
        // If the request failed
        print('Failed to create appointment');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la création du rendez-vous'),
        ));
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la création du rendez-vous'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color myCustomColor = Color(0xFF009EE2);
    const Color myCustomColor1 = Color(0xFF38B8c4);
    const String myfont = 'ArialRounded';
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 1, // Ajoutez de l'élévation pour une ombre
        color: const Color.fromARGB(
            255, 255, 255, 255), // Définir la couleur de fond blanche
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Ajoutez des coins arrondis
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.profilImage != null)
                    ClipOval(
                      child: Image.network(
                        widget.profilImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.firstname}',
                            style: TextStyle(
                              fontFamily: myfont,
                              fontSize: 20,
                              color: myCustomColor,
                            ),
                          ),
                          SizedBox(width: 7), // Espace entre les noms
                          Text(
                            '${widget.lastname}',
                            style: TextStyle(
                              fontFamily: myfont,
                              fontSize: 20,
                              color: myCustomColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // Espace entre les noms

                      Text(
                        ' spécialité : ${widget.specialite}',
                        style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 26, 48),
                        ),
                      ),
                      SizedBox(height: 7), // Espace entre les noms

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/localisation.png",
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            'Tunisie ,${widget.city}',
                            style: TextStyle(
                              fontFamily: myfont,
                              fontSize: 12,
                              color: Color.fromARGB(255, 82, 82, 82),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 20), // Espace entre les sections de la carte
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrer les champs de texte
                children: [
                  Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            myCustomColor, // Définir la couleur de la bordure ici
                        width: 1.0, // Définir la largeur de la bordure ici
                      ),
                      borderRadius: BorderRadius.circular(
                          10.0), // Définir le rayon de la bordure ici
                    ),
                    child: TextField(
                      controller: _dateController,
                      keyboardType: TextInputType.number,
                      cursorColor: myCustomColor1,
                      decoration: InputDecoration(
                        hintText: "Date",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 10,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            myCustomColor, // Définir la couleur de la bordure ici
                        width: 1.0, // Définir la largeur de la bordure ici
                      ),
                      borderRadius: BorderRadius.circular(
                          10.0), // Définir le rayon de la bordure ici
                    ),
                    child: TextField(
                      controller: _monthController,
                      keyboardType: TextInputType.datetime,
                      cursorColor: myCustomColor1,
                      decoration: InputDecoration(
                        hintText: "mois",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 10,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            myCustomColor, // Définir la couleur de la bordure ici
                        width: 1.0, // Définir la largeur de la bordure ici
                      ),
                      borderRadius: BorderRadius.circular(
                          10.0), // Définir le rayon de la bordure ici
                    ),
                    child: TextField(
                      controller: _hourController,
                      keyboardType: TextInputType.datetime,
                      cursorColor: myCustomColor1,
                      decoration: InputDecoration(
                        hintText: "heure",
                        hintStyle: TextStyle(
                          fontFamily: "ArialRounded",
                          fontSize: 10,
                          color: Color.fromARGB(224, 89, 111, 114),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Espace entre les sections de la carte
              Container(
                width: 230,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onRequestAppointment(widget.profilID);
                    _requestAppointment();
                  },
                  child: Text(
                    "Demander un rendez-vous",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: myfont,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myCustomColor, // Couleur de fond
                    foregroundColor: Colors.white, // Couleur du texte
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25.0), // Coins arrondis
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
