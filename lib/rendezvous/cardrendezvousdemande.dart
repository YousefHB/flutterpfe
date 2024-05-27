import 'package:flutter/material.dart';

// Widget pour afficher un rendez-vous sous forme de Card
class CardRendezVousDemande extends StatefulWidget {
  final String date;
  final String month;
  final String hour;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String idAppointment;
  final Function(String) onApprove;
  final Function(String) onReject;
  CardRendezVousDemande({
    required this.date,
    required this.month,
    required this.hour,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.idAppointment,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<CardRendezVousDemande> createState() => _CardRendezVousDemandeState();

  static CardRendezVousDemande fromJson(Map<String, dynamic> json,
      Function(String) onApprove, Function(String) onReject) {
    return CardRendezVousDemande(
      date: json['appointmentDetails']['date'].toString() ?? '',
      month: json['appointmentDetails']['month'].toString() ?? '',
      hour: json['appointmentDetails']['hour'].toString() ?? '',
      firstName: json['patient']['patientDetails']['firstName'] ?? '',
      lastName: json['patient']['patientDetails']['lastName'] ?? '',
      email: json['patient']['patientDetails']['email'] ?? '',
      phoneNumber: json['patient']['patientDetails']['phoneNumber'] ?? '',
      idAppointment: json['id'] ?? '',
      onApprove: onApprove,
      onReject: onReject,
    );
  }
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _CardRendezVousDemandeState extends State<CardRendezVousDemande> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: Card(
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vous avez une demande de rendez-vous le ${widget.date}/${widget.month} à ${widget.hour}h, Créé par "${widget.firstName} ${widget.lastName}"',
                style: TextStyle(
                  fontFamily: myfont,
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 28, 53),
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Email : ${widget.email}',
                style: TextStyle(
                  fontFamily: myfont,
                  fontSize: 12,
                  color: Color.fromARGB(255, 0, 47, 87),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Téléphone : ${widget.phoneNumber}',
                style: TextStyle(
                  fontFamily: myfont,
                  fontSize: 12,
                  color: Color.fromARGB(255, 0, 47, 87),
                ),
              ),
              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApprove(widget.idAppointment);
                      },
                      child: Text(
                        "Approuver",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: myfont,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myCustomColor, // Couleur de fond
                        foregroundColor: Colors.white, // Couleur du texte
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // Coins arrondis
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onReject(widget.idAppointment);
                      },
                      child: Text(
                        "Rejeter",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: myfont,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myCustomColor1, // Couleur de fond
                        foregroundColor: Colors.white, // Couleur du texte
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // Coins arrondis
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
