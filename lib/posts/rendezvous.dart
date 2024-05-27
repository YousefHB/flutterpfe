import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ycmedical/config.dart';
import 'package:ycmedical/rendezvous/cardrendezvous.dart';
import 'package:ycmedical/rendezvous/classprofsant%C3%A9.dart';
import 'package:ycmedical/rendezvous/listedesrendezvous.dart';

class RendezVous extends StatefulWidget {
  const RendezVous({super.key});

  @override
  State<RendezVous> createState() => _RendezVousState();
}

const Color myCustomColor = Color(0xFF009EE2);
const Color myCustomColor1 = Color(0xFF38B8c4);
const String myfont = 'ArialRounded';

class _RendezVousState extends State<RendezVous> {
  List<Professional> professionals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfessionals();
  }

  void requestAppointment(String professionalId) {
    print('Appointment requested for professional ID: $professionalId');
    // Ajoutez ici votre logique pour gérer la demande de rendez-vous
  }

  Future<void> fetchProfessionals() async {
    final response =
        await http.get(Uri.parse(url + '/api/admin/getAllProSantes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        professionals =
            data.map((json) => Professional.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      // Handle server errors
      setState(() {
        isLoading = false;
      });
    }
  }

  /****************
   * ***************** */
  final GlobalKey _menuKey = GlobalKey();

  void _showMenu() {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'requested_appointments',
          child: Container(
            decoration: BoxDecoration(
              color: Colors
                  .white, // Assurez-vous que l'arrière-plan est blanc ou une autre couleur appropriée
              borderRadius: BorderRadius.circular(8.0), // Radius des bords
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(
                8.0), // Padding pour donner de l'espace autour du texte
            child: Text(
              'Rendez-vous demandés',
              style: TextStyle(
                fontFamily: 'myfont',
                fontSize:
                    14, // Assurez-vous que la taille de la police est appropriée
                color: Color.fromARGB(255, 0, 26, 48),
              ),
            ),
          ),
        ),
        // Ajoutez d'autres éléments de menu ici
      ],
      elevation:
          0, // Retirez l'élévation pour enlever le fond du menu contextuel
      color: Colors.transparent, // Rendre le fond transparent
    ).then((value) {
      if (value != null) {
        _onMenuItemSelected(value);
      }
    });
  }

  void _onMenuItemSelected(String value) {
    switch (value) {
      case 'requested_appointments':
        // Action pour les rendez-vous demandés
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => listrendezvousdemande()),
        );
        print('Rendez-vous demandés sélectionnés');
        break;
      // Ajoutez d'autres cas si nécessaire
    }
  }

  /********** */
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
                          "Rendez-vous",
                          style: TextStyle(
                            fontFamily: myfont,
                            fontSize: 20,
                            color: myCustomColor,
                          ),
                        ),
                        IconButton(
                          key: _menuKey,
                          onPressed: _showMenu,
                          icon: Image.asset(
                            "assets/image/menudot.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      "assets/image/rendezvous.png",
                      width: 200,
                      height: 160,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '"Bienvenue ! Prenez rendez-vous pour \n une consultation médicale en quelques clics"',
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 26, 48),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Professionnels Santé",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: myfont,
                        fontSize: 17,
                        color: myCustomColor,
                      ),
                    ),
                    Divider(
                      color: myCustomColor, // Couleur du Divider
                      thickness: 1, // Épaisseur du Divider
                      height: 1, // Hauteur du Divider
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                      (context, index) {
                        final professional = professionals[index];
                        return CardRendezVous(
                          profilID: professional.id,
                          profilImage: professional.profileImage,
                          firstname: professional.firstName,
                          lastname: professional.lastName,
                          specialite: professional.specialty,
                          city: professional.city,
                          onRequestAppointment: requestAppointment,
                        );
                      },
                      childCount: professionals.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
