import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/config.dart';
import 'package:ycmedical/messagerie/CardConversation.dart';
import 'package:ycmedical/messagerie/conversation.dart';

class DiscussionWidget extends StatefulWidget {
  @override
  _DiscussionWidgetState createState() => _DiscussionWidgetState();
}

class _DiscussionWidgetState extends State<DiscussionWidget> {
  List<dynamic> conversations = [];

  @override
  void initState() {
    super.initState();
    getConversations(); // Appeler la méthode pour récupérer les conversations lors de l'initialisation de la page
  }

  Future<void> getConversations() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        Uri.parse(url + '/api/chat/getuserconversation'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> conversationsData =
            json.decode(response.body) as List<dynamic>;

        List<dynamic> modifiedConversations =
            conversationsData.map((conversation) {
          final profilePhotoMap =
              conversation['photoProfil'] as Map<String, dynamic>;
          final profilePhotoUrl = profilePhotoMap['url'] as String;
          final modifiedProfilePhotoUrl =
              profilePhotoUrl.replaceAll('localhost', '10.0.2.2');
          conversation['photoProfil']['url'] = modifiedProfilePhotoUrl;
          return conversation;
        }).toList();

        setState(() {
          conversations = modifiedConversations;
          print('Conversations:');
          print(conversations);
          print('****************************************************');
        });
      } else {
        throw Exception('Failed to load conversations: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load conversations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Example height, adjust as needed
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return GestureDetector(
            onTap: () {
              print(
                  'conversationId récupéré est : ${conversation['id']}'); // Utilisez ${} pour accéder à la valeur de la variable
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                    conversationId: conversation['id'],
                  ),
                ),
              );
            },
            child: ConversationCard(
              conversationId: conversation['_id'] ?? '',
              userName:
                  conversation['firstName'] + " " + conversation['lastName'] ??
                      'Utilisateur Inconnu',
              userImage: conversation['photoProfil']['url'] ?? '',
            ),
          );
        },
      ),
    );
  }
}
