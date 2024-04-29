import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        var results = json.decode(response.body);
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(results);
          /*_searchResults.forEach((user) {
            user['photoProfil'] = convertImageUrl(user['photoProfil']);
            // Si vous avez également un champ 'photoCouverture', vous pouvez le traiter de la même manière
          });*/
        });
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête: $e');
    }
  }

  String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche d\'utilisateurs'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Recherche',
                      hintText: 'Entrez le prénom de l\'utilisateur',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
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
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var user = _searchResults[index];
                return ListTile(
                  /* leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoProfil']),
                  ),*/
                  title: Text('${user['firstName']} ${user['lastName']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
