import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';

class Post extends StatefulWidget {
  final String content;
  final List<String> images;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? profilePhotoUrl;
  final String createdByUserId;
  final String postid;
  final Function(String userId) onTapUserName;

  const Post({
    Key? key,
    required this.postid,
    required this.content,
    required this.images,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.profilePhotoUrl,
    required this.createdByUserId,
    required this.onTapUserName,
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _PostState extends State<Post> {
  bool showFullText = false;
  bool showReactionRow = false;
  bool showCommentSection =
      false; // Nouvel état pour contrôler la visibilité de la section de commentaire
  TextEditingController commentController =
      TextEditingController(); // Contrôleur pour le champ de texte du commentaire
  List<String> comments = [
    'Commentaire 1',
    'Commentaire 2'
  ]; // Liste de commentaires fictifs
  String calculateTimestamp() {
    if (widget.createdAt != null) {
      // Convert createdAt to DateTime object
      DateTime createdAtDateTime = DateTime.parse(widget.createdAt!);

      // Calculate the difference between current time and createdAt time
      Duration difference = DateTime.now().difference(createdAtDateTime);

      // Calculate the difference in minutes, hours, and days
      int differenceInMinutes = difference.inMinutes;
      int differenceInHours = difference.inHours;
      int differenceInDays = difference.inDays;

      if (differenceInMinutes < 60) {
        // If less than an hour, display minutes
        return 'il y a $differenceInMinutes min';
      } else if (differenceInHours < 24) {
        // If less than a day, display hours
        return 'il y a $differenceInHours h';
      } else if (differenceInDays == 1) {
        // If exactly one day, display "1 J"
        return 'il y a 1 J';
      } else {
        // If more than one day, display number of days
        return 'il y a $differenceInDays J';
      }
    } else {
      return 'Unknown'; // Handle case when createdAt is null
    }
  }

  String reactionAsset = 'assets/image/jaime.png';
  @override
  void initState() {
    super.initState();
    fetchUserReactions();
  }

  void _handleTapUserName() {
    // Call the callback function with the user's ID
    widget.onTapUserName(widget.createdByUserId);
  }

  // Function to handle creating or updating reactions
  Future<void> handleReaction(String type) async {
    final String api = addreaction;
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final response = await http.post(
      Uri.parse(api),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "post": widget.postid,
        "type": type,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      await fetchUserReactions();
    } else {
      print(type);
      print('token ${accessToken}');
      print('Failed to create/update reaction: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchUserReactionsOnPost(String postId) async {
    final String apireaction = apireactiontoget + postId;
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse(apireaction),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Parse response body
      final List<dynamic> userReactions = jsonDecode(response.body);

      // Extract reaction types from the response
      final List<String> reactionTypes =
          userReactions.map((reaction) => reaction['type'] as String).toList();

      return reactionTypes;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to fetch user reactions on post');
    }
  }

  Future<void> fetchUserReactions() async {
    try {
      List<String> userReactions =
          await fetchUserReactionsOnPost(widget.postid);

      if (userReactions.contains("like")) {
        setState(() {
          reactionAsset = 'assets/image/Rjaime.png';
        });
      } else if (userReactions.contains("bravo")) {
        setState(() {
          reactionAsset = 'assets/image/bravo.png';
        });
      } else if (userReactions.contains("love")) {
        setState(() {
          reactionAsset = 'assets/image/jadore.png';
        });
      } else if (userReactions.contains("triste")) {
        setState(() {
          reactionAsset = 'assets/image/trist.png';
        });
      }
    } catch (error) {
      // Gérer l'erreur lors de la récupération des réactions
      print('Erreur lors de la récupération des réactions : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Expanded(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: myCustomColor, width: 1.0),
          ),
          child: Container(
            width: screenWidth * 0.8,
            height: widget.images.isNotEmpty || showFullText ? 550 : 300,
            // Augmentez la hauteur si la section de commentaire est visible
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget.profilePhotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      30), // Half of the width/height to make it circular
                                  child: Image.network(
                                    widget.profilePhotoUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/image/profile.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _handleTapUserName();
                          },
                          child: Text(
                            widget.firstName! + " " + widget.lastName!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: myfont,
                                letterSpacing: 1.4,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          calculateTimestamp(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: myCustomColor,
                              fontFamily: myfont,
                              fontSize: 11),
                        ),
                      ],
                    ),
                    /*Image.asset(
                      "assets/image/menudot.png",
                      width: 15,
                      height: 15,
                    )*/
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final int wordLimit = constraints.maxWidth <= 200
                          ? 5
                          : 10; // Limite de mots basée sur la largeur du conteneur
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            showFullText
                                ? widget.content
                                : widget.content
                                        .split(' ')
                                        .take(wordLimit)
                                        .join(' ') +
                                    '...',
                            style: TextStyle(
                              fontFamily: myfont,
                              letterSpacing: 1.4,
                              height: 1.7,
                              fontSize: 14,
                            ),
                          ),
                          if (widget.content.split(' ').length > wordLimit)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showFullText = !showFullText;
                                });
                              },
                              child: Text(
                                showFullText ? 'Voir moins' : 'Voir plus',
                                style: TextStyle(color: myCustomColor),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),

                    height:
                        double.infinity, // Ajustez la hauteur selon vos besoins
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context)
                                .size
                                .width, // Prend la largeur totale de l'écran
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(widget.images[index],
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width // Prend toute la hauteur du conteneur
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (showReactionRow)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            print('Post ID: ${widget.postid}');
                            handleReaction("like");
                            showReactionRow = false;
                          });
                        },
                        child: Image.asset(
                          'assets/image/Rjaime.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            handleReaction("love");
                            showReactionRow = false;
                          });
                        },
                        child: Image.asset(
                          'assets/image/jadore.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            handleReaction("bravo");
                            showReactionRow = false;
                          });
                        },
                        child: Image.asset(
                          'assets/image/bravo.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            handleReaction("triste");
                            showReactionRow = false;
                          });
                        },
                        child: Image.asset(
                          'assets/image/trist.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            showReactionRow =
                                true; // Afficher la rangée de réaction
                          });
                        },
                        child: Image.asset(
                          reactionAsset,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showCommentSection =
                                !showCommentSection; // Afficher ou masquer la section de commentaire
                          });
                        },
                        child: Image.asset(
                          'assets/image/commentaire.png',
                          width: 90,
                          height: 65,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/image/partager.png',
                          width: 70,
                          height: 80,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/image/enregistrement.png',
                          width: 25,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCommentSection) // Afficher la section de commentaire si nécessaire
                  Container(
                    child: Column(
                      children: [
                        TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Entrez votre commentaire',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  comments.add(commentController.text);
                                  commentController.clear();
                                });
                              },
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: comments.map((comment) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 0.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(comment),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
