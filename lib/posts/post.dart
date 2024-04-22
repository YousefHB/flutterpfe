import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post extends StatefulWidget {
  final String content;
  final List<String> images;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? profilePhotoUrl;
  const Post({
    Key? key,
    required this.content,
    required this.images,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.profilePhotoUrl,
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.blue, width: 2.0),
      ),
      child: Container(
        width: screenWidth * 0.9,
        height: showCommentSection
            ? 700
            : 400, // Augmentez la hauteur si la section de commentaire est visible
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Colors.grey, // Change the border color as needed
                          width: 2,
                        ),
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
                  children: [
                    Text(widget.firstName! + " " + widget.lastName!),
                    Text(
                      calculateTimestamp(),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/image/menudot.png",
                  width: 15,
                  height: 15,
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: Text(
                showFullText
                    ? widget.content
                    : widget.content.split(' ').take(20).join(' ') + '...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            if (widget.content.split(' ').length > 20)
              TextButton(
                onPressed: () {
                  setState(() {
                    showFullText = !showFullText;
                  });
                },
                child: Text(
                  showFullText ? 'Voir moins' : 'Voir plus',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.images.map((imageUrl) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 0.0),
                      child: Image.network(
                        imageUrl,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (showReactionRow)
            Row(
              children: [
                GestureDetector(
                  onTap : () {
                      setState(() {
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
                  onTap : () {
                      setState(() {
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
                  onTap : () {
                      setState(() {
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
                  onTap : () {
                      setState(() {
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
            Row(
              children: [
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      showReactionRow = true; // Afficher la rangée de réaction
                    });
                  },
                  child: Image.asset(
                    'assets/image/jaime.png',
                    width: 80,
                    height: 90,
                  ),
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
                    width: 140,
                    height: 140,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/image/partager.png',
                    width: 90,
                    height: 90,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/image/enregistrement.png',
                    width: 60,
                    height: 30,
                  ),
                ),
              ],
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
    );
  }
}
