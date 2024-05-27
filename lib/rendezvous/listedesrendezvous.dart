import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ycmedical/config.dart';
import 'package:ycmedical/rendezvous/cardrendezvousdemande.dart'; // Importez votre carte CardRendezVousDemande
import 'package:http/http.dart' as http;

class listrendezvousdemande extends StatefulWidget {
  const listrendezvousdemande({Key? key}) : super(key: key);

  @override
  State<listrendezvousdemande> createState() => _listrendezvousdemandeState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _listrendezvousdemandeState extends State<listrendezvousdemande> {
  bool isLoading = true;
  List<CardRendezVousDemande> appointments =
      []; // Liste pour stocker les rendez-vous

  // Méthode pour récupérer les rendez-vous demandés pour le médecin spécifique
  Future<void> fetchDoctorRendezvous() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');

    final url = 'http://10.0.2.2:3000/rendezvous/appointments/doctor';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> appointmentsData =
          json.decode(response.body)['appointments'];
      print('Rendez-vous récupérés: $appointmentsData');

      final pendingAppointments = appointmentsData
          .where((appointment) => appointment['status'] == 'pending')
          .toList();

      setState(() {
        appointments = List<CardRendezVousDemande>.from(
          pendingAppointments.asMap().entries.map((entry) {
            return CardRendezVousDemande.fromJson(
              entry.value,
              (id) => approveAppointment(id, entry.key),
              (id) => rejectAppointment(id, entry.key),
            );
          }),
        );
        isLoading = false;
      });
    } else {
      print('Failed to fetch doctor rendezvous: ${response.statusCode}');
      throw Exception('Failed to fetch doctor rendezvous');
    }
  }

  @override
  void initState() {
    super.initState();
    // Appeler la méthode pour récupérer les rendez-vous lorsque le widget est initialisé
    fetchDoctorRendezvous();
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
              Color.fromRGBO(233, 254, 255, 1),
              Color.fromRGBO(214, 252, 255, 1),
              Color.fromRGBO(212, 250, 255, 1),
              Color.fromRGBO(221, 253, 255, 0.965),
            ],
            stops: [0.0, 0.5, 0.8, 1],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/image/back.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Text(
                          "Liste des rendez-vous demandés",
                          style: TextStyle(
                            fontFamily: myfont,
                            fontSize: 14,
                            color: myCustomColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/image/menudot.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        // Créez une instance de CardRendezVousDemande pour chaque rendez-vous
                        return CardRendezVousDemande(
                          date: appointments[index].date,
                          month: appointments[index].month,
                          hour: appointments[index].hour,
                          firstName: appointments[index].firstName,
                          lastName: appointments[index].lastName,
                          email: appointments[index].email,
                          phoneNumber: appointments[index].phoneNumber,
                          idAppointment: appointments[index].idAppointment,
                          onApprove: (id) => onApprove(id, index),
                          onReject: (id) => onReject(id, index),
                        );
                      },
                      childCount: appointments.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> approveAppointment(String id, int index) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    final url = 'http://10.0.2.2:3000/rendezvous/appointments/approve/$id';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Rendez-vous approuvé avec succès');
      setState(() {
        appointments.removeAt(index);
      });
      // Mettez à jour l'UI ou effectuez d'autres actions nécessaires après l'approbation du rendez-vous
    } else {
      print('Failed to approve appointment: ${response.statusCode}');
      // Gérez les erreurs qui pourraient survenir lors de l'approbation du rendez-vous
    }
  }

  Future<void> rejectAppointment(String id, int index) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'accessToken');
    final url = 'http://10.0.2.2:3000/rendezvous/appointments/reject/$id';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Rendez-vous rejeté avec succès');
      setState(() {
        appointments.removeAt(index);
      });
      // Mettez à jour l'UI ou effectuez d'autres actions nécessaires après le rejet du rendez-vous
    } else {
      print('Failed to reject appointment: ${response.statusCode}');
      // Gérez les erreurs qui pourraient survenir lors du rejet du rendez-vous
    }
  }

  void onApprove(String id, int index) {
    approveAppointment(id, index);
  }

  void onReject(String id, int index) {
    rejectAppointment(id, index);
  }
}
