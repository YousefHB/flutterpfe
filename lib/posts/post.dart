import 'dart:convert';
import 'dart:ffi';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';
import 'package:ycmedical/videoplayer.dart';
import 'comment.dart';

class Post extends StatefulWidget {
  final String content;
  final List<String> images;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? profilePhotoUrl;
  final String createdByUserId;
  final String postid;
  final List<String> videos;
  final Function(String userId) onTapUserName;
  final bool isOwner;
  final VoidCallback onDelete;
  const Post({
    Key? key,
    required this.postid,
    required this.content,
    required this.images,
     required this.videos,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.profilePhotoUrl,
    required this.createdByUserId,
    required this.onTapUserName,
    required this.isOwner,
    required this.onDelete,
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
  List<Map<String, dynamic>> comments = []; // Changez le type de la liste
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
  //  late String _selectedOption;
  //  String currentUserId = '';
  /*  Future<void> isCurrentUserPost() async {
  final storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'accessToken');
  if (accessToken != null) {
    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(accessToken.split(" ")[1]))));
    final userId = decodedToken['userId']; // Assuming 'userId' is the key in your JWT payload
    
    setState(() {
      currentUserId = userId;
    });
    print('Current User ID: $currentUserId'); // Print the current user ID for debugging
  } else {
    print('Access token is null'); // Print an error message if access token is null
  }
}

*/
String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
  }
  @override
  void initState() {
    super.initState();
    fetchUserReactions();
    // isCurrentUserPost();
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
  Future<void> deleteReaction(String postId) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    final url = Uri.parse('http://10.0.2.2:3000/reaction/');
    
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'postId': postId}),
      );

      if (response.statusCode == 204) {
        print('Reaction deleted successfully');
        fetchUserReactionsOnPost(widget.postid);
      } else if (response.statusCode == 404) {
        print('Reaction not found');
      } else {
        print('Failed to delete reaction: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting reaction: $e');
    }
  }

  Future<void> PostComment(String content, post) async {
    try {
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      final url = 'http://10.0.2.2:3000/comment';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': content,
          'post': post,
        }),
      );

      if (response.statusCode == 201) {
        fetchPostComment(post);
        print('Commentaire envoyé');
      } else {
        print('Échec de l\'envoi du commentaire: ${response.statusCode}');
        // Vous pouvez gérer les erreurs de manière plus détaillée ici si nécessaire
      }
    } catch (error) {
      print('Erreur lors de l\'envoi du commentaire: $error');
      // Gérez les erreurs ici si nécessaire
    }
  }

  Future<void> fetchPostComment(String post) async {
    try {
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      final url = 'http://10.0.2.2:3000/comment/$post';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments = List<Map<String, dynamic>>.from(data.map((item) {
            final user = item['user'] as Map<String, dynamic>;
            // final photoProfil = user['photoProfil'] as Map<String, dynamic>;
            final images = (item['user']['photoProfil']['url'] as String)
                .replaceAll('localhost',
                    '10.0.2.2'); // Replace 'localhost' with '10.0.2.2' // Access the URL directly
            final id = item['_id'];
            final firstName = user['firstName'].toString();
            final lastName = user['lastName'].toString();
            final specialty = user['specialty'] != null
                ? user['specialty'].toString()
                : ''; // Vérifiez si specialty est null
            final content = item['content'].toString();
            // final createdAt = item['createdAt'].toString();
            final isOwner = item['isOwner'] as bool; // Add isOwner field
            return {
              '_id': id,
              'firstName': firstName,
              'lastName': lastName,
              'user': {
                'specialty': specialty
              }, // Mettez la spécialité dans la structure user
              'content': content,
              'images': images,
              'specialty': specialty,
              'isOwner': isOwner, // Include isOwner field in the comment
              // 'createdAt': createdAt,
            };
          }));
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> deletePost(String postId, void Function() refreshPosts) async {
    final url = 'http://10.0.2.2:3000/posts/$postId';
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $accessToken', // Assurez-vous de passer le jeton d'accès correctement
    };

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Le post a été supprimé avec succès
        print('Post deleted successfully');
        refreshPosts();
      } else if (response.statusCode == 404) {
        // Le post n'a pas été trouvé
        print('Post not found');
      } else if (response.statusCode == 403) {
        // L'utilisateur n'est pas autorisé à supprimer ce post
        print('Unauthorized: You can only delete your own posts');
      } else {
        // Une erreur inattendue s'est produite
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (error) {
      // Une erreur de connexion s'est produite
      print('Connection error: $error');
    }
  }

  Future<void> updatePost(
      String postId, String newContent, void Function() refreshPosts) async {
    try {
      // Construire le corps de la requête
      final Map<String, dynamic> body = {
        'content': newContent,
      };

      // Construire l'URL de l'endpoint
      final String url = 'http://10.0.2.2:3000/posts/updateAuth/$postId';
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      // Faire la requête HTTP
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      // Analyser la réponse
      if (response.statusCode == 200) {
        refreshPosts();
        print('Publication mise à jour avec succès');
      } else if (response.statusCode == 404) {
        // Le post n'a pas été trouvé
        print('Post not found');
      } else if (response.statusCode == 403) {
        // L'utilisateur n'est pas autorisé à mettre à jour ce post
        print('Unauthorized: You can only update your own posts');
      } else {
        // Une erreur inattendue s'est produite
        print('Unexpected error: ${response.statusCode}');
      }
    } catch (error) {
      // Une erreur de connexion s'est produite
      print('Connection error: $error');
    }
  }

  void _showEditDialog() {
    TextEditingController contentController =
        TextEditingController(text: widget.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Modifier publication',
            style: TextStyle(color: Colors.blue), // Couleur bleue pour le titre
          ),
          content: TextField(
            controller: contentController,
            decoration: InputDecoration(hintText: 'Nouveau contenu'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                    color:
                        Colors.blue), // Couleur bleue pour le texte du bouton
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updatePost(
                    widget.postid, contentController.text, widget.onDelete);
                Navigator.of(context).pop();
              },
              child: Text(
                'Enregistrer',
                style: TextStyle(
                    color:
                        Colors.blue), // Couleur bleue pour le texte du bouton
              ),
            ),
          ],
        );
      },
    );
  }

  void tst() {
    fetchPostComment(widget.postid);
  }

  Future<void> createEnregistrement(String postId) async {
    try {
      final url = Uri.parse("http://10.0.2.2:3000/enregister");
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
      final body = jsonEncode({'post': postId});
      final response = await http.post((url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: body);
      if (response.statusCode == 201) {
        print('Enregistrement créé avec succès.');
      } else {
        print(
            'Erreur lors de la création de l\'enregistrement: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la création de l\'enregistrement: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaList = [...widget.images, ...widget.videos];
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
           height: (widget.images.isEmpty && widget.videos.isEmpty)
    ? 350
    : (showFullText || showCommentSection)
        ? 700
        : 550,


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
                        /*Text(
                        currentUserId
                      ),*/
                      ],
                    ),
                    // Inside your build method, compare the access token directly with the post id
                    //  if (currentUserId == widget.createdByUserId) // Compare with createdByUserId
                     Spacer(),
                    if (widget.isOwner)
                      GestureDetector(
                        onTap: () {
                          final RenderBox overlay = Overlay.of(context)!
                              .context
                              .findRenderObject() as RenderBox;
                          final RelativeRect position = RelativeRect.fromSize(
                            Rect.fromLTRB(
                                MediaQuery.of(context).size.width - 10,
                                100,
                                MediaQuery.of(context).size.width,
                                0),
                            overlay.size,
                          );

                          showMenu(
                            context: context,
                            position: position,
                            items: [
                              PopupMenuItem(
                                onTap: () {
                                  _showEditDialog();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.blue, // Couleur de l'icône
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Espacement entre le texte et l'icône
                                    Text(
                                      'Modifier publication',
                                      style: TextStyle(
                                        color: Colors.blue, // Couleur du texte
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  deletePost(widget.postid, widget.onDelete);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.blue, // Couleur de l'icône
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Espacement entre le texte et l'icône
                                    Text(
                                      'Supprimer publication',
                                      style: TextStyle(
                                        color: Colors.blue, // Couleur du texte
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            elevation: 8.0,
                            color: Colors
                                .white, // Couleur de fond du menu déroulant
                          );
                        },
                        child: Image.asset(
                          'assets/image/menudot.png',
                          width: 20.0,
                          height: 20.0,
                        ),
                      ),
SizedBox(width: 5,),
// Then, conditionally show the button based on whether the user is viewing their own post
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
  itemCount: mediaList.length,
  itemBuilder: (context, index) {
    String mediaUrl = mediaList[index];
    bool isImage = widget.images.contains(mediaUrl);
    
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width, // Prend la largeur totale de l'écran
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isImage)
              Image.network(
                convertImageUrl(mediaUrl),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width, // Prend toute la hauteur du conteneur
              )
            else
              Builder(
                builder: (context) {
                  print("Rendering video with URL: ${convertImageUrl(mediaUrl)}");
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: VideoPlayerWidget(
                      videoUrl: convertImageUrl(mediaUrl),
                    ),
                  );
                },
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
                        onTap: () {
                          deleteReaction(widget.postid);
                           setState(() {
                          reactionAsset = 'assets/image/jaime.png';
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
                          fetchPostComment(widget.postid);
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
                        onTap: () {
                          createEnregistrement(widget.postid);
                        },
                        child: Image.asset(
                          'assets/image/enregistrement.png',
                          width: 25,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Comments section
                if (showCommentSection)
                  Expanded(
                    child: Column(
                      children: [
                        // Text field for entering comments
                        TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Enter your comment',
                            suffixIcon: IconButton(
                              onPressed: () {
                                PostComment(
                                    commentController.text, widget.postid);
                                setState(() {
                                  commentController.clear();
                                });
                              },
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        /*  Expanded(
        child: Container(
          // Height for the comment section
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/image/Rjaime.png"),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test $index',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Subtitle $index"),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),*/

                        // List of comments
                        Container(
                          child: Expanded(
                            child: CustomScrollView(
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(8.0),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        final comment = comments[index];
                                        return Comment(
                                          commenterPhotoUrl: comment['images'],
                                          commenterFName: comment['firstName'],
                                          commenterLFName: comment['lastName'],
                                          content: comment['content'],
                                          specialty: comment['specialty'] ?? '',
                                          id: comment['_id'],
                                          userid: comment['user']['_id'],
                                          isOwner: comment['isOwner'],
                                          onRefresh: () =>
                                              fetchPostComment(widget.postid),

                                              
                                        );
                                        
                                      },
                                      childCount: comments.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
