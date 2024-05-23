import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/profil/visiteprofilpatient.dart'; // Update this import to the correct file path

import '../posts/post.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  String _searchTerm = '';
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _executeSearch() async {
    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/user/rechercheutilisateur'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'searchTerm': _searchTerm}),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          var users = data['users'];
          setState(() {
            _searchResults = List<Map<String, dynamic>>.from(users);
          });
          print(_searchResults);
        } else {
          print('Erreur: ${data['message']}');
        }
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête: $e');
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset(
                        "assets/image/back.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Recherche",
                            style: TextStyle(
                              fontFamily: myfont,
                              fontSize: 20,
                              color: myCustomColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Recherche',
                          hintText: 'Rechercher',
                          filled: true, // Activer le remplissage
                          fillColor: const Color.fromARGB(
                              255, 255, 255, 255), // Couleur de fond
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rayon de bordure
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchTerm = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _executeSearch,
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var user = _searchResults[index];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['photoProfil']
                              .replaceAll('localhost', '10.0.2.2')),
                        ),
                        title: Text(
                          '${user['firstName']} ${user['lastName']}'
                        ),
                        subtitle: user['role'] == 'ProfessionnelSante'
                            ? Text('specialist de sante')
                            : null,
                        onTap: user['role'] != 'ProfessionnelSante'
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AutreProfilPatient(userId: user['id']),
                                  ),
                                );
                              }
                            : null,
                      ),
                      Divider(), // Ajouter un séparateur entre chaque élément
                    ],
                  );
                },
                childCount: _searchResults.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
