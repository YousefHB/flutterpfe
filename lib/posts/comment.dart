import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String? commenterPhotoUrl;
  final String? commenterFName;
  final String? commenterLFName;
  final String? content;
  final String ?specialty;
  final String ?id;
  final String ?userid;
  final bool isOwner;
  const Comment({
    required this.commenterPhotoUrl,
    required this.commenterFName,
    required this.commenterLFName,
    required this.content,
    required this.specialty,
    required this.id,
    required this.userid,
    required this.isOwner,
  });

  @override
  State<Comment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
           decoration: BoxDecoration(
            color: const Color.fromARGB(255, 226, 222, 222), // Couleur de fond grise
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
                Image.asset(
                  'assets/image/menudot.png'
                )
            ],
          ),
         
        ),
      ],
    );
  }
}
