import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/config.dart';
import 'package:ycmedical/posts/post.dart';

class ProfilPatient extends StatefulWidget {
  const ProfilPatient({Key? key}) : super(key: key);

  @override
  State<ProfilPatient> createState() => _ProfilPatientState();
}

class _ProfilPatientState extends State<ProfilPatient> {
  List<Map<String, dynamic>> posts = [];
  late Map<String, dynamic> _userInfo;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _userInfo = {};
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      return;
    }

    try {
      final Map<String, dynamic> fetchedUserInfo =
          await fetchUserInfo(accessToken);
      setState(() {
        _userInfo = fetchedUserInfo;
      });
    } catch (error) {
      print('Error fetching user info: $error');
    }
  }

  String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
  }

  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(userinfo),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userInfo = jsonDecode(response.body);

        userInfo['user']['photoProfil'] =
            convertImageUrl(userInfo['user']['photoProfil']);
        userInfo['user']['photoCouverture'] =
            convertImageUrl(userInfo['user']['photoCouverture']);

        return userInfo;
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user info: $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: _userInfo.isNotEmpty
                ? Text(
                    '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}',
                  )
                : Text('Chargement...'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu),
              ),
            ],
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: _userInfo.isNotEmpty
                  ? Image.network(
                      _userInfo['user']['photoCouverture'],
                      fit: BoxFit.cover,
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _userInfo.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            _userInfo['user']['photoProfil'],
                          ),
                        )
                      : CircularProgressIndicator(),
                  SizedBox(height: 20),
                  _userInfo.isNotEmpty
                      ? Text(
                          '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}',
                          style: TextStyle(fontSize: 20),
                        )
                      : CircularProgressIndicator(),
                  SizedBox(height: 20),
                  // Affichez d'autres informations sur l'utilisateur ici
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Publications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final postData = posts[index];
                final postContent = postData['content'];
                final postImages = postData['images'];
                final firstName = postData['firstName'];
                final lastName = postData['lastName'];
                final createdAt = postData['createdAt'];
                final photoProfil = postData['profilePhotoUrl'];
                return Post(
                  content: postContent,
                  images: postImages,
                  firstName: firstName,
                  lastName: lastName,
                  createdAt: createdAt,
                  profilePhotoUrl: photoProfil,
                );
              },
              childCount: posts.length >= 5 ? 5 : posts.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse(getmypost);
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(data.map((item) {
            List<String> images =
                (item['images'] as List<dynamic>).map((image) {
              return image.toString().replaceAll('localhost', '10.0.2.2');
            }).toList();
            item['images'] = images;
            final createdBy = item['createdBy'];
            final firstName = createdBy['firstName'];
            final lastName = createdBy['lastName'];
            final createdAt = item['createdAt'];
            String profilePhotoUrl =
                (item['createdBy']['photoProfil']['url'] as String)
                    .replaceAll('localhost', '10.0.2.2');

            item['firstName'] = firstName;
            item['lastName'] = lastName;
            item['createdAt'] = createdAt;
            item['profilePhotoUrl'] = profilePhotoUrl;
            return item;
          }));
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }
}
