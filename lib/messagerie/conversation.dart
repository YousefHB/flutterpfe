import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:ycmedical/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ycmedical/messagerie/Conversation.dart';
import 'package:ycmedical/messagerie/classmessage.dart';
import 'package:ycmedical/videoplayer.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  ConversationScreen({required this.conversationId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Message> messages = [];
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<File> selectedImages = [];
  List<File> selectedVideos = [];
  List<File> selectedDocuments = [];

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

  void initSocketIO() {
    // Initialisez la connexion avec le serveur Socket.IO
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('message', (data) {
      print('Received message from server: $data');
      setState(() {
        if (data['message'] != null) {
          messages.add(Message(
            text: data['message'] as String,
            senderId: data['sender'] as String,
            images: [],
            videos: [],
            documents: [],
          ));
        } else if (data['text'] != null) {
          messages.add(Message(
            text: data['text'] as String,
            senderId: data['sender'] as String,
            images: [],
            videos: [],
            documents: [],
          ));
        }
      });
    });

    socket.on('newMessage', (data) {
      print('New message from server: $data');
      setState(() {
        if (data['text'] != null) {
          messages.add(Message(
            text: data['text'] as String,
            senderId: data['sender'] as String,
            images: [],
            videos: [],
            documents: [],
          ));
        }
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
  }

  String convertImageUrl(String imageUrl) {
    return imageUrl.replaceAll('localhost', '10.0.2.2');
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
        List<Message> newMessages = [];

        for (var data in responseData) {
          Message message = Message(
            text: data['text'] as String,
            images: List<String>.from(
                data['images']?.map((imageUrl) => convertImageUrl(imageUrl)) ??
                    []),
            videos: List<String>.from(data['videos'] ?? []),
            documents: List<Map<String, dynamic>>.from(data['documents'] ?? []),
            senderId: data['sender'] as String,
          );
          newMessages.add(message);
        }

        setState(() {
          // Clear existing messages list before adding new ones
          messages.clear();
          // Add the new messages to the list
          messages.addAll(newMessages);
        });
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> selectFiles() async {
    // Open file picker to select images
    FilePickerResult? imagesResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    // Open file picker to select videos
    FilePickerResult? videosResult = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    // Open file picker to select documents
    FilePickerResult? documentsResult = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    // Update selected files lists
    setState(() {
      selectedImages =
          imagesResult?.files.map((e) => File(e.path!)).toList() ?? [];
      selectedVideos =
          videosResult?.files.map((e) => File(e.path!)).toList() ?? [];
      selectedDocuments =
          documentsResult?.files.map((e) => File(e.path!)).toList() ?? [];
    });
  }

  Future<void> sendMessage(String message, List<File> images, List<File> videos,
      List<File> documents) async {
    try {
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'accessToken');

      // Create multipart request for uploading files
      var request = http.MultipartRequest(
          'POST', Uri.parse(url + '/api/chat/addMessage'));

      // Add text message to the request
      request.fields['conversationId'] = widget.conversationId;
      request.fields['text'] = message;

      // Add images to the request
      for (var image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('images', image.path));
      }

      // Add videos to the request
      for (var video in videos) {
        request.files
            .add(await http.MultipartFile.fromPath('videos', video.path));
      }

      // Add documents to the request
      for (var document in documents) {
        request.files
            .add(await http.MultipartFile.fromPath('document', document.path));
      }

      // Set authorization header
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Send the request
      var streamedResponse = await request.send();

      // Check the response status
      if (streamedResponse.statusCode == 200) {
        print('Message sent successfully');
        socket.emit('sendMessage', {
          'conversationId': widget.conversationId,
          'text': message,
          // Include any other necessary data here
        });
        // Clear selected files
        selectedImages.clear();
        selectedVideos.clear();
        selectedDocuments.clear();
        await fetchMessages();
      } else {
        throw Exception(
            'Failed to send message: ${streamedResponse.statusCode}');
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
                // Accédez à l'objet Message à l'index donné
                Message message = messages[index];

                // Construisez un widget pour afficher les informations du message
                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Affichez le texte du message
                      Text(message.text),
                      // Affichez les images du message s'il y en a
                      if (message.images.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Images:'),
                            // Affichez chaque image du message
                            for (String image in message.images)
                              Image.network(image),
                          ],
                        ),
                      // Affichez les vidéos du message s'il y en a
                      if (message.videos.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Videos:'),
                            // Affichez chaque vidéo du message
                            for (String videoUrl in message.videos)
                              VideoPlayerWidget(
                                  videoUrl: convertImageUrl(videoUrl)),
                          ],
                        ),

                      // Affichez les documents du message s'il y en a
                      if (message.documents.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Documents:'),
                            // Affichez chaque document du message
                            for (Map<String, dynamic> document
                                in message.documents)
                              ListTile(
                                title: Text(document['filename']),
                                onTap: () {
                                  // Ouvrez le document ou effectuez une action associée
                                },
                              ),
                          ],
                        ),
                    ],
                  ),
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
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // Call the function to select files
                    selectFiles();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Envoyer le message lorsque l'utilisateur appuie sur le bouton d'envoi
                    sendMessage(messageController.text, selectedImages,
                        selectedVideos, selectedDocuments);
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
