import 'package:flutter/material.dart';

class ConversationCard extends StatefulWidget {
  final String conversationId;
  final String? userImage;
  final String? userName;
  final String? lastMessage; // Nouvelle propriété pour le dernier message

  ConversationCard({
    required this.conversationId,
    this.userImage,
    this.userName,
    this.lastMessage, // Ajoutez lastMessage au constructeur
  });

  @override
  State<ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  @override
  Widget build(BuildContext context) {
    const Color myCustomColor = Color(0xFF009EE2);
    const Color myCustomColor1 = Color(0xFF38B8c4);
    const String myfont = 'ArialRounded';
    return Card(
      elevation: 0, // Retirez l'ombre si nécessaire
      color: Colors.transparent, // Rend la carte transparente
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.userImage != null)
            ClipOval(
              child: Image.network(
                widget.userImage!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.userName}',
                style: TextStyle(
                  fontFamily: myfont,
                  fontSize: 17,
                  color: myCustomColor,
                ),
              ),
              if (widget.lastMessage !=
                  null) // Afficher le dernier message s'il est disponible
                Text(
                  widget.lastMessage!,
                  style: TextStyle(
                    fontFamily: myfont,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
