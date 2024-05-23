import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/view/authentification/authprofsante.dart';
import 'package:http/http.dart' as http;

class Ami extends StatefulWidget {
  final String friendid;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final Function()? onUpdateFriendList;
  const Ami(
      {required this.firstName,
      required this.lastName,
      required this.friendid,
      required this.profilePhotoUrl,
      this.onUpdateFriendList,
      super.key});

  @override
  State<Ami> createState() => _AmiState();
}

class _AmiState extends State<Ami> {
  Future<void> removeFriend(String friendId) async {
    try {
      // Remplacez 'YOUR_API_ENDPOINT' par l'URL réelle de votre API back-end
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');

      final url = 'http://10.0.2.2:3000/api/user/RemoveFriend';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'friendId': friendId}),
      );
      if (response.statusCode == 200) {
        widget.onUpdateFriendList?.call();
        print('Ami retiré avec succès.');
      } else {
        // Affichez un message d'erreur à l'utilisateur
        print('Erreur lors de la suppression de l\'ami.');
      }
    } catch (error) {
      // Affichez un message d'erreur à l'utilisateur
      print('Erreur interne du serveur.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30, // adjust the size as needed
                    backgroundImage: NetworkImage(widget.profilePhotoUrl!),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.firstName! + " " + widget.lastName!,
                    style: TextStyle(
                      fontFamily: myfont,
                      fontSize: 15,
                      color: myCustomColor,
                    ),
                  ),
                ],
              ),
              /* SizedBox(
                width: 10,
              ),*/

              SizedBox(
                width: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                height: 35,
                width: 125,
                child: OutlinedButton(
                  onPressed: () {
                    removeFriend(widget.friendid);
                  },
                  child: Text(
                    "Retirer de la liste",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: myfont,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    backgroundColor: const Color.fromARGB(
                        0, 255, 255, 255), // Background color
                    foregroundColor: myCustomColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    side: BorderSide(
                      color: myCustomColor, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
