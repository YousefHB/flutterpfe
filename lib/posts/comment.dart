import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class Comment extends StatefulWidget {
  final String? commenterPhotoUrl;
  final String? commenterFName;
  final String? commenterLFName;
  final String? content;
  final String ?specialty;
  final String ?id;
  final String ?userid;
  final bool isOwner;
   final VoidCallback onRefresh;
  const Comment({
    required this.commenterPhotoUrl,
    required this.commenterFName,
    required this.commenterLFName,
    required this.content,
    required this.specialty,
    required this.id,
    required this.userid,
    required this.isOwner,
    required this.onRefresh,
  });

  @override
  State<Comment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Comment> {
  Future<void> deleteComment(String commentId , void Function() onRefrech) async {
  try {
    final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:3000/comment/$commentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Comment deleted successfully');
      onRefrech();
      // Vous pouvez effectuer des actions supplémentaires ici si nécessaire
    } else if (response.statusCode == 404) {
      print('Comment not found');
    } else {
      print('Failed to delete comment: ${response.statusCode}');
    }
  } catch (error) {
    print('Error deleting comment: $error');
  }
}
Future<void> updateComment(String commentId, String newContent , void Function() onRefrech) async {
  try {
     final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final url = 'http://10.0.2.2:3000/comment/$commentId'; // Replace with your server's URL and endpoint
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{
        'content': newContent,
      }),
    );

    if (response.statusCode == 200) {
      print('Comment updated successfully');
      onRefrech();
      // Handle success, if needed
    } else {
      print('Failed to update comment: ${response.statusCode}');
      // Handle failure, if needed
    }
  } catch (error) {
    print('Error updating comment: $error');
    // Handle error, if needed
  }
}
void _showEditDialog() {
    TextEditingController contentController = TextEditingController(text: widget.content);

    showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text(
        'Modifier commentaire',
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
            style: TextStyle(color: Colors.blue), // Couleur bleue pour le texte du bouton
          ),
        ),
        ElevatedButton(
          onPressed: () {
             updateComment( widget.id! ,contentController.text , widget.onRefresh);
            Navigator.of(context).pop();
          },
          child: Text(
            'Enregistrer',
            style: TextStyle(color: Colors.blue), // Couleur bleue pour le texte du bouton
          ),
        ),
      ],
    );
  },
);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
           decoration: BoxDecoration(
            color: Color.fromARGB(255, 226, 226, 226), // Couleur de fond grise
            borderRadius: BorderRadius.circular(25),
             border: Border.all(color: Color.fromARGB(255, 136, 228, 240)), // Rayon de 10 pour les coins
          ),
          padding:  EdgeInsets.fromLTRB(0, 10, 0, 10), // Padding de 25 de chaque côté
          child: Row(
            children: [
              if (widget.commenterPhotoUrl != null) // Vérifier si commenterPhotoUrl est non nul
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.commenterPhotoUrl!),
                ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.commenterFName} ${widget.commenterLFName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.content!),
                  ],
                ),
              ),
              if (widget.specialty!.isNotEmpty)
                Text(
                  "Specialite: ${widget.specialty!}",
                  style: TextStyle(color: Colors.blue), // Couleur du texte en bleu
                ),
                if (widget.isOwner) 
  GestureDetector(
    onTap: () {
      final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
      final RelativeRect position = RelativeRect.fromSize(
        Rect.fromLTRB(MediaQuery.of(context).size.width - 10, 100, MediaQuery.of(context).size.width, 0),
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
            size: 20, // Taille de l'icône réduite
            color: Colors.blue, // Couleur de l'icône
          ),
          SizedBox(width: 5), // Réduire l'espacement entre le texte et l'icône
          Text(
            'Modifier commentaire',
            style: TextStyle(
              fontSize: 14, // Taille de la police réduite
              color: Colors.blue, // Couleur du texte
            ),
          ),
        ],
      ),
    ),
    PopupMenuItem(
      onTap: () {
       deleteComment(widget.id! , widget.onRefresh);
      },
      child: Row(
        children: [
          Icon(
            Icons.delete,
            size: 20, // Taille de l'icône réduite
            color: Colors.blue, // Couleur de l'icône
          ),
          SizedBox(width: 5), // Réduire l'espacement entre le texte et l'icône
          Text(
            'Supprimer commentaire',
            style: TextStyle(
              fontSize: 14, // Taille de la police réduite
              color: Colors.blue, // Couleur du texte
            ),
          ),
        ],
      ),
    ),
  ],
  elevation: 8.0,
  color: Colors.white, // Couleur de fond du menu déroulant
);

    },
    child: Image.asset(
      'assets/image/menudot.png',
      width: 15.0,
      height: 15.0,
    ),
  ),
            ],
          ),
         
        ),
      ],
    );
  }
}
