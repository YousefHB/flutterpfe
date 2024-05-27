import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../posts/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Creepost.dart';

class Page_detaill extends StatefulWidget {
  final String PageId;
  const Page_detaill({Key? key, required this.PageId}) : super(key: key);

  @override
  State<Page_detaill> createState() => _Page_detaillState();
}

class _Page_detaillState extends State<Page_detaill> {
  Map<String, dynamic>? _userPage;
  List<Map<String, dynamic>> posts = [];
  Future<void> _fetchPage(String pageId) async {
    try {
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/page/getPage/$pageId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['message'] == 'Page') {
          var pages = data['page'];
          setState(() {
            _userPage = Map<String, dynamic>.from(pages);
          });
          print(_userPage);
        } else {
          print('Erreur: ${data['msg']}');
        }
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête: $e');
    }
  }
  Future<void> fetchPosts(String pageId) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/page/AllPosts/$pageId');
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
            // final isOwner = item['isOwner'] as bool; // Add isOwner field
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
          //  item['isOwner'] = isOwner;
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
  void initState() {
    super.initState();
    _fetchPage(widget.PageId);
    fetchPosts(widget.PageId);
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
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _userPage?['nom'] ?? 'Loading...',
                        style: TextStyle(
                          fontFamily: myfont,
                          fontSize: 20,
                          color: myCustomColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/image/menudot.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //if (_userPage != null && _userPage!['photoPage'] != null)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      _userPage!['photoPage']['url']
                          .replaceAll('localhost', '10.0.2.2'),
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          '4 Abonné(e)s',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: myfont,
                            fontSize: 17,
                            color: myCustomColor,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddpostPage(PageId: widget.PageId),
                        ),
                      );
                        },
                        child: Row(
                          children: [
                            Text(
                              " Crée post",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: myfont,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myCustomColor, // Background color
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // Rounded corners
                          ),
                          side: BorderSide(
                            color: myCustomColor, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox( height: 15),
                    Text(
                      "Publications",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 17,
                        color: myCustomColor,
                      ),
                    ),
                    Divider(
                      color: myCustomColor, // Couleur du Divider
                      thickness: 1, // Épaisseur du Divider
                      height: 1, // Hauteur du Divider
                    ),
                  ],
                ),
              ),
            ),
            // Add other widgets here
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
                   // final isOwner = postData['isOwner'];

                    return Post(
                      content: postContent,
                      images: postImages,
                         videos: postVideo,
                      firstName: _userPage?['nom'],
                      lastName: '',
                      createdAt: createdAt,
                      profilePhotoUrl:  _userPage!['photoPage']['url']
                          .replaceAll('localhost', '10.0.2.2'),
                      createdByUserId: userId,
                      postid: postid,
                      isOwner: true,
                      onDelete: tst,
                      onTapUserName: (userId) {
                         print(
                          'User ID: $userId'); 
                      },
                      // Par exemple, imprime l'ID de l'utilisateur dans la console
                    );
                  },
                  childCount: posts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void tst (){
  print('tst');
}