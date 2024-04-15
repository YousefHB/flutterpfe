import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String content;
  final List<String> images;

  const Post({Key? key, required this.content, required this.images})
      : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool showFullText = false;
  bool showReactionRow = false;
  bool showCommentSection = false; // Nouvel état pour contrôler la visibilité de la section de commentaire
  TextEditingController commentController = TextEditingController(); // Contrôleur pour le champ de texte du commentaire
  List<String> comments = ['Commentaire 1', 'Commentaire 2']; // Liste de commentaires fictifs

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
        height: showCommentSection ? 700 : 400, // Augmentez la hauteur si la section de commentaire est visible
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/image/profile.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
              child: Text(
                showFullText ? widget.content : widget.content.split(' ').take(20).join(' ') + '...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
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
                      showCommentSection = !showCommentSection; // Afficher ou masquer la section de commentaire
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
                            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 0.0),
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
