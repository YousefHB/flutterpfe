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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.blue, width: 2.0),
      ),
      child: Container(
        width: screenWidth * 0.7,
        height: 400,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
            //SizedBox(height: 50,),
            if (showReactionRow) // Check if reaction row should be visible
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle "J'aime"
                        setState(() {
                          showReactionRow = false; // Hide reaction row
                        });
                      },
                      child: Icon(Icons.thumb_up),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle "J'adore"
                        setState(() {
                          showReactionRow = false; // Hide reaction row
                        });
                      },
                      child: Icon(Icons.favorite),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle "Triste"
                        setState(() {
                          showReactionRow = false; // Hide reaction row
                        });
                      },
                      child: Icon(Icons.sentiment_dissatisfied),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle "Wow"
                        setState(() {
                          showReactionRow = false; // Hide reaction row
                        });
                      },
                      child: Icon(Icons.star),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                GestureDetector(
                  onLongPress: () {
                    // the principe here will be making the row of reaction visisble
                    setState(() {
                      showReactionRow = true; // Show reaction row
                    });
                  },
                  child: Image.asset(
                    'assets/image/jaime.png',
                    width: 80,
                    height: 90,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
