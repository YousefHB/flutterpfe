import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ycmedical/messagerie/Conversation.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  ConversationScreen({required this.conversationId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<String> messages = [];
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    initSocketIO();
  }

  @override
  void dispose() {
    // Déconnectez-vous du serveur lorsque le widget est supprimé
    socket.disconnect();
    super.dispose();
  }

  /*void initSocketIO() {
    // Initialisez la connexion avec le serveur Socket.IO
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('message', (data) {
      print('Received message from server: $data');
      // Mettre à jour l'interface utilisateur avec les nouveaux messages
      setState(() {
        messages.add(data['message'] as String);
      });
    });
    socket.on('newMessage', (data) {
      print('New message from server: $data');
      // Mettre à jour la liste des messages avec le nouveau message reçu
      setState(() {
        messages.add(data['text'] as String);
      });
    });

    // Connectez-vous au serveur
    socket.connect();

    // Écoutez les événements depuis le serveur
    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    // Gérez les erreurs de connexion
    socket.onConnectError((error) {
      print('Socket.IO connection error: $error');
    });
  }*/
  void initSocketIO() {
    // Initialisez la connexion avec le serveur Socket.IO
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('message', (data) {
      print('Received message from server: $data');
      // Vérifiez si le widget est monté avant de mettre à jour l'état
      if (mounted) {
        setState(() {
          messages.add(data['message'] as String);
        });
      }
    });
    socket.on('newMessage', (data) {
      print('New message from server: $data');
      // Vérifiez si le widget est monté avant de mettre à jour l'état
      if (mounted) {
        setState(() {
          messages.add(data['text'] as String);
        });
      }
    });

    // Connectez-vous au serveur
    socket.connect();

    // Écoutez les événements depuis le serveur
    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    // Gérez les erreurs de connexion
    socket.onConnectError((error) {
      print('Socket.IO connection error: $error');
    });
  }

  Future<void> fetchMessages() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    try {
      final response = await http.get(
        Uri.parse(url +
            '/api/chat/getMessagesByConversationId/${widget.conversationId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        setState(() {
          messages =
              responseData.map((data) => data['text'] as String).toList();
        });
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> sendMessage(String message) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    try {
      final response = await http.post(
        Uri.parse(url + '/api/chat/addMessage'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'conversationId': widget.conversationId,
          'text': message,
        }),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  color: Colors.grey[200],
                  child: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Envoyer le message lorsque l'utilisateur appuie sur le bouton d'envoi
                    sendMessage(messageController.text);
                    // Effacer le champ de texte après l'envoi
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
