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
import 'package:ycmedical/messagerie/discussion.dart';
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
  final storage = FlutterSecureStorage();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await fetchCurrentUserId(); // Wait for fetchCurrentUserId to complete
    fetchMessages(); // Now it's safe to call fetchMessages
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

  Future<String?> fetchCurrentUserId() async {
    try {
      // Fetch the access token from storage
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken != null) {
        // Make a GET request to your backend endpoint to fetch user info
        final response = await http.get(
          Uri.parse(userinfo),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          // Decode the response JSON
          Map<String, dynamic> userInfo = jsonDecode(response.body);
          // Extract first name and last name from the response
          String? firstName = userInfo['user']['firstName'];
          String? lastName = userInfo['user']['lastName'];
          currentUserId = '$firstName $lastName';
          print('*********Current************ Full Name: $currentUserId');
          return currentUserId;
        } else {
          print('Failed to fetch user info: ${response.statusCode}');
          return null;
        }
      }
    } catch (error) {
      print('Error fetching current user full name: $error');
    }
    return null; // Return null if fetching full name fails
  }

  Future<void> fetchMessages() async {
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
          String senderId = data['sender'] as String;
          print('Sender ID: $senderId'); // Print senderId here
          Message message = Message(
            text: data['text'] as String,
            images: List<String>.from(
                data['images']?.map((imageUrl) => convertImageUrl(imageUrl)) ??
                    []),
            videos: List<String>.from(data['videos'] ?? []),
            documents: List<Map<String, dynamic>>.from(data['documents'] ?? []),
            senderId: senderId,
          );
          newMessages.add(message);
        }

        setState(() {
          messages.clear();
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

  int compareSenderIds(Message message) {
    // Trim both senderId and currentUserId to remove any leading or trailing spaces
    String trimmedSenderId = message.senderId.trim();
    String trimmedCurrentUserId = currentUserId!.trim();

    if (trimmedSenderId == trimmedCurrentUserId) {
      print("yesssssssssss");
      return 1;
    } else {
      ("Nooooooooooooo");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(240, 254, 255, 1),
              Color.fromRGBO(229, 253, 255, 1),
              Color.fromRGBO(212, 250, 255, 0.873),
              Color.fromRGBO(203, 252, 255, 0.827),
            ],
            stops: [0.0, 0.5, 0.8, 1],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  Message message = messages[index];
                  int x = compareSenderIds(message);
                  return Align(
                    alignment:
                        x == 1 ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: x == 1
                          ? null
                          : MediaQuery.of(context).size.width *
                              0.7, // Adjust the width conditionally
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),

                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(
                              255, 198, 245, 255), // Border color
                          width: 1.0, // Border width
                        ),
                        color: x == 1
                            ? Color.fromARGB(80, 0, 158, 226)
                            : Color.fromARGB(80, 56, 184, 196),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(165, 214, 255, 254)
                                .withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: x == 1
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: x == 1 ? Colors.black : Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          if (message.images.isNotEmpty)
                            Column(
                              crossAxisAlignment: x == 1
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Images:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                for (String image in message.images)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(image),
                                    ),
                                  ),
                              ],
                            ),
                          if (message.videos.isNotEmpty)
                            Column(
                              crossAxisAlignment: x == 1
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Videos:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                for (String videoUrl in message.videos)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: VideoPlayerWidget(
                                        videoUrl: convertImageUrl(videoUrl)),
                                  ),
                              ],
                            ),
                          if (message.documents.isNotEmpty)
                            Column(
                              crossAxisAlignment: x == 1
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Documents:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                for (Map<String, dynamic> document
                                    in message.documents)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      document['filename'],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {
                                      // Open the document or perform an associated action
                                    },
                                  ),
                              ],
                            ),
                        ],
                      ),
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
                      // Send the message when the user presses the send button
                      sendMessage(messageController.text, selectedImages,
                          selectedVideos, selectedDocuments);
                      // Clear the text field after sending
                      messageController.clear();
                    },
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
