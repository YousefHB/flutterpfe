import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/config.dart';
import 'package:ycmedical/posts/post.dart';

class AutreProfilPatient extends StatefulWidget {
  final String userId;

  const AutreProfilPatient({Key? key, required this.userId}) : super(key: key);

  @override
  State<AutreProfilPatient> createState() => _AutreProfilPatientState();
}

class _AutreProfilPatientState extends State<AutreProfilPatient> {
  List<Map<String, dynamic>> posts = [];
  late Map<String, dynamic> _userInfo =
      {}; // Initialisation avec une valeur par défaut vide
  bool invitationSent = false;
  @override
  @override
  void initState() {
    super.initState();
    invitationSent = false;

    fetchPosts(widget.userId);
    final storage = FlutterSecureStorage();
    storage.read(key: 'accessToken').then((accessToken) {
      if (accessToken != null) {
        fetchUserInfo(widget.userId, accessToken).then((userInfo) {
          setState(() {
            _userInfo = userInfo;
          });
        }).catchError((error) {
          print('Error fetching user info: $error');
        });
      } else {
        print('Access token is null');
      }
    }).catchError((error) {
      print('Error fetching access token: $error');
    });
  }

  Future<Map<String, dynamic>> fetchUserInfo(
      String userId, String accessToken) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/user/profil/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $accessToken', // Ajoutez le jeton d'authentification ici
        },
      );

      if (response.statusCode == 200) {
        print('Fetching user info for ID: $userId');
        Map<String, dynamic> userInfo = jsonDecode(response.body);

        // Accéder à la clé 'photoProfil' et imprimer le nom de l'image
        var photoProfilName = userInfo['user']['photoProfil']['url'];
        print('Nom de l\'image de profil: $photoProfilName');
        userInfo['user']['photoProfil']['url'] =
            convertImageUrl(userInfo['user']['photoProfil']['url']);
        var photoProfilame = userInfo['user']['photoProfil']['url'];
        print('***Nom de l\'image de profil aprés modif: $photoProfilame');

        return userInfo;
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user info: $error');
    }
  }

  Future<void> createConversation(String receiverId) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');

    try {
      final String apiUrl = 'http://10.0.2.2:3000/api/chat/createConversation';
      final Map<String, dynamic> body = {'receiverId': receiverId};
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Conversation created successfully');
        setState(() {
          var conversationCreated = true;
        });
      } else {
        print('Error creating conversation: ${response.statusCode}');
        print(jsonDecode(response.body)['msg']);
      }
    } catch (error) {
      print('Error creating conversation: $error');
    }
  }

  Future<void> sendFriendInvitation(String receiverId) async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    try {
      final String apiUrl =
          'http://10.0.2.2:3000/api/user/sendFriendInvitation';
      final Map<String, dynamic> body = {'receiverId': receiverId};

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $accessToken', // Ajoutez le jeton d'authentification dans les en-têtes
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Invitation envoyée avec succès');
        setState(() {
          invitationSent = true;
        });
      } else {
        print(
            'Erreur lors de l\'envoi de l\'invitation: ${response.statusCode}');
        print(jsonDecode(response.body)['errorMsg']);
      }
    } catch (error) {
      print('Erreur lors de l\'envoi de l\'invitation: $error');
    }
  }

  String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
  }

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
                    Text(
                        _userInfo.isNotEmpty
                            ? '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}'
                            : 'Chargement...', // le nom de patient ici
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
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.5, // épaisseur de la bordure
                          color: Colors
                              .transparent, // couleur de la bordure (transparente pour ne pas interférer avec le dégradé)
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            myCustomColor1,
                            myCustomColor,
                          ], // couleurs du dégradé
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                          _userInfo['user']['photoProfil']['url'] ??
                              'assets/image/people.png',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    _userInfo.isNotEmpty
                        ? Text(
                            '${_userInfo['user']['firstName']} ${_userInfo['user']['lastName']}',
                            style: TextStyle(
                              fontSize: 20,
                              color: myCustomColor,
                              fontFamily: myfont,
                            ),
                          )
                        : CircularProgressIndicator(),
                    SizedBox(height: 20),
                    // Affichez d'autres informations sur l'utilisateur ici
                  ],
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
                      
                      OutlinedButton(
                        onPressed: invitationSent
                            ? null // Désactivez le bouton si l'invitation a déjà été envoyée
                            : () {
                                // Appeler la fonction sendFriendInvitation lorsque l'utilisateur appuie sur le bouton
                                sendFriendInvitation(widget.userId);
                              },
                        child: Text(
                          invitationSent
                              ? 'Invitation envoyée'
                              : '+ Ajouter ami(e)', // Modifier le texte en fonction de l'état
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: myfont,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myCustomColor, // Background color
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 6),
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
                      OutlinedButton(
                        onPressed: () => createConversation(widget.userId),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image/chat.png",
                              width: 15,
                              height: 15,
                            ),
                            Text(
                              " Envoyer un message",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: myfont,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 6),
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
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                  child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              )),
            ),
            SliverList(
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
                  final isOwner = postData['isOwner'] ?? false;

                  // Ajouter l'ID de l'utilisateur

                  return Post(
                    postid: postid,
                    content: postContent,
                    images: postImages,
                    videos: postVideo,
                    firstName: firstName,
                    lastName: lastName,
                    createdAt: createdAt,
                    profilePhotoUrl: photoProfil,
                    createdByUserId: userId,
                    isOwner: isOwner,
                    onDelete: fetchpost,

                    onTapUserName: (userId) {
                      // Définir le comportement lorsqu'on clique sur le nom de l'utilisateur
                      print(
                          'User ID: $userId'); // Par exemple, imprime l'ID de l'utilisateur dans la console
                    },
                  );
                },
                childCount: posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchPosts(String userId) async {
    final url = Uri.parse('http://10.0.2.2:3000/posts/$userId');
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
            final id = item['_id'];
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
            item['_id'] = id;
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

void fetchpost() {
  print("object");
}
