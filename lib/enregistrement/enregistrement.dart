import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/posts/post.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Enregistrement extends StatefulWidget {
  
  const Enregistrement({super.key});

  @override
  
  State<Enregistrement> createState() => _EnregistrementState();
}

class _EnregistrementState extends State<Enregistrement> { 
  @override
  void initState() {
    super.initState();
   fetchEnregistment();
  }
  
  List<Map<String, dynamic>> posts = [];
  Future<void> fetchEnregistment() async {
    final url = Uri.parse("http://10.0.2.2:3000/enregister");
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    try {
      final response = await http.get(url ,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      }
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(data.map((item) {
            List<String> images =
                (item['images'] as List<dynamic>).map((image) {
              return image.toString().replaceAll('localhost', '10.0.2.2');
            }).toList();
            List<String> video = (item['videos'] as List<dynamic>).map((video) {
              return video.toString().replaceAll('localhost', '10.0.2.2');
            }).toList();
            item['videos'] = video;
            item['images'] = images;
            final id = item['_id'];
            final createdBy = item['createdBy'];
            final firstName = createdBy['firstName'];
            final lastName = createdBy['lastName'];
            final createdAt = item['createdAt'];
             final isOwner = item['isOwner'] as bool; // Add isOwner field
            String profilePhotoUrl =
                (item['createdBy']['photoProfil']['url'] as String)
                    .replaceAll('localhost', '10.0.2.2');

            // Updating item with user details

            // Updating item with user details
            item['_id'] = id;
            item['firstName'] = firstName;
            item['lastName'] = lastName;
            item['createdAt'] = createdAt;
            item['profilePhotoUrl'] = profilePhotoUrl;
            item['isOwner'] = isOwner;
            return item;
          }));
          /*posts.sort((a, b) => DateTime.parse(a['createdAt'])
              .compareTo(DateTime.parse(b['createdAt'])));*/
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
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
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/image/back.png",
                          width: 30,
                          height: 30,
                        )),
                    Text(
                        "Enregistrement",
                        style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 20,
                          color: myCustomColor,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/image/menudot.png",
                          width: 30,
                          height: 30,
                        )),
                  ],
                ),
              ),
            ),
             SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final postData = posts[index];
                    final postid = postData['_id'];
                    final postContent = postData['content'];
                    final postImages = postData['images'];
                      final postVideo = postData['videos'];
                    final firstName = postData['firstName'];
                    final lastName = postData['lastName'];
                    final createdAt = postData['createdAt'];
                    final photoProfil = postData['profilePhotoUrl'];
                    final userId = postData['createdBy']['_id'];
                    // Ajouter l'ID de l'utilisateur
                    final isOwner = postData['isOwner'];

                    return Post(
                      content: postContent,
                      images: postImages,
                      videos: postVideo,
                      firstName: firstName,
                      lastName: lastName,
                      createdAt: createdAt,
                      profilePhotoUrl: photoProfil,
                      createdByUserId: userId,
                      postid: postid,
                      isOwner: isOwner,
                      onDelete: fetchEnregistment,
                      onTapUserName: (userId) {
                      // Définir le comportement lorsqu'on clique sur le nom de l'utilisateur
                      print(
                          'User ID: $userId'); // Par exemple, imprime l'ID de l'utilisateur dans la console
                    },
                      // Par exemple, imprime l'ID de l'utilisateur dans la console
                    );
                  },
                  childCount: posts.length,
                ),
              ),
            )
          ]
          ),
      ),
    
            );
  }
}