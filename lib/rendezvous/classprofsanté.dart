class Professional {
  final String id;
  final String? profileImage;
  final String? firstName;
  final String? lastName;
  final String? specialty;
  final String? city;

  Professional({
    required this.id,
    this.profileImage,
    this.firstName,
    this.lastName,
    this.specialty,
    this.city,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    String convertImageUrl(String imageUrl) {
      return imageUrl.replaceAll('localhost', '10.0.2.2');
    }

    return Professional(
      id: json['_id'],
      profileImage: json['photoProfil'] != null
          ? convertImageUrl(json['photoProfil']['url'])
          : null,
      firstName: json['firstName'],
      lastName: json['lastName'],
      specialty: json['specialty'],
      city: json['city'],
    );
  }
}
