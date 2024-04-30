import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/profil/ami.dart';
import 'package:http/http.dart' as http;
import '../posts/post.dart';
typedef FriendUpdateCallback = void Function();
class ListAmie extends StatefulWidget {
  final FriendUpdateCallback? onUpdateFriendList;

  const ListAmie({super.key ,this.onUpdateFriendList});

  @override
  State<ListAmie> createState() => _ListAmieState();
}

class _ListAmieState extends State<ListAmie> {
  List<Map<String, dynamic>> friends = [];
  Future<void> fetchFriend() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final url =
        'http://10.0.2.2:3000/api/user/listFriends'; // Remplacez par votre URL de l'endpoint Node.js

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data =
          responseData['friends']; // Access the list of invitations
      setState(() {
        friends = List<Map<String, dynamic>>.from(data.map((item) {
          final id = item['id'];
          final firstName = item['firstName'];
          final lastName = item['lastName'];
           final photoProfil = (item['photoProfil']['url'] as String)
          .replaceAll('localhost', '10.0.2.2'); // Replace 'localhost' with '10.0.2.2' // Access the URL directly
          return {
            'id': id,
            'firstName': firstName,
            'lastName': lastName,
            'profilePhotoUrl':
                photoProfil, // Change to match the variable name used in your Flutter code
          };
        }));
        
        print('Received invitations: ${response.body}');
      });
    } else {
      print('Failed to fetch invitations: ${response.statusCode}');
      throw Exception('Failed to fetch invitations');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFriend();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                              "List d'ami(e)",
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
               SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final friendData = friends[index];

                    final firstName = friendData['firstName'];
                    final lastName = friendData['lastName'];
                    final photoProfil = friendData['profilePhotoUrl'];
                    final id = friendData[
                        'id']; // Assurez-vous de récupérer l'ID correctement

                    // Vous devez fournir les valeurs requises pour créer une instance de InvitResu
                    return Ami(
                      firstName: firstName,
                      lastName: lastName,
                      friendid: id, // Utilisez l'ID ici
                      profilePhotoUrl: photoProfil,
                     onUpdateFriendList: fetchFriend,
                    );
                  },
                  childCount: friends.length,
                  
                ),
              ),
                ],
          )
   ),
    );
  }
}
