import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

class InvitResu extends StatefulWidget {
  final String senderid;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
   final Function()? onUpdateInvitations; 
  const InvitResu(
      {required this.firstName,
      required this.lastName,
      required this.senderid,
      required this.profilePhotoUrl,
      this.onUpdateInvitations, 
      super.key});

  @override
  State<InvitResu> createState() => _InvitResuState();
}

class _InvitResuState extends State<InvitResu> {
  Future<void> acceptFriendInvitation(String senderId) async {
  try {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final url = 'http://10.0.2.2:3000/api/user/acceptFriendInvitation';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'senderId': senderId}),
    );

    if (response.statusCode == 200) {
      widget.onUpdateInvitations?.call();
      print('invit accepter');
    } else {
      // Handle error
      print('Failed to accept friend invitation: ${response.statusCode}');
    }
  } catch (error) {
    // Handle error
    print('Error accepting friend invitation: $error');
  }
}
Future<void> RejectFriendInvitation(String senderId) async {
  try {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final url = 'http://10.0.2.2:3000/api/user/RejectFriendInvitation';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'senderId': senderId}),
    );

    if (response.statusCode == 200) {
      widget.onUpdateInvitations?.call();
      print('invit accepter');
    } else {
      // Handle error
      print('Failed to accept friend invitation: ${response.statusCode}');
    }
  } catch (error) {
    // Handle error
    print('Error accepting friend invitation: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25, // adjust the size as needed
                backgroundImage: NetworkImage(widget.profilePhotoUrl!),
              ),
              Text(
                widget.firstName! + " " + widget.lastName!,
                style: TextStyle(
                  fontFamily: myfont,
                  fontSize: 20,
                  color: myCustomColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                height: 30,
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    print(widget.senderid);
                    acceptFriendInvitation(widget.senderid);
                  },
                  child: Text(
                    "Confirmer",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: myfont,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myCustomColor, // Background color
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    side: BorderSide(
                      color: myCustomColor, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    RejectFriendInvitation(widget.senderid);
                  },
                  child: Text(
                    "Supprimer",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: myfont,
                        color: Color.fromARGB(99, 63, 62, 62)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(188, 214, 210, 210),
                    foregroundColor: myCustomColor,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    side: BorderSide(
                      color: Colors.transparent, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
