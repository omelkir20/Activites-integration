class Etudiant {
  final int id;
  final String cin;
  final String nom;
  final String? dateNaissance;
  final String? email;
  // FIX: anneePremiereInscription (vraie année ex: 2022) au lieu de annee (1/2/3)
  final int? anneePremiereInscription;
  final int? departementId;
  final String? departementNom;
  final int? age;

  Etudiant({
    required this.id,
    required this.cin,
    required this.nom,
    this.dateNaissance,
    this.email,
    this.anneePremiereInscription,
    this.departementId,
    this.departementNom,
    this.age,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'] as int,
      cin: json['cin'] ?? '',
      nom: json['nom'] ?? '',
      dateNaissance: json['dateNaissance']?.toString(),
      email: json['email'],
      // FIX: lecture du bon champ
      anneePremiereInscription: json['anneePremiereInscription'] as int?,
      departementId: json['departementId'] as int?,
      departementNom: json['departementNom'],
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cin': cin,
      'nom': nom,
      'dateNaissance': dateNaissance,
      'email': email,
      // FIX: envoi du bon champ au backend
      'anneePremiereInscription': anneePremiereInscription,
      'departementId': departementId,
    };
  }
}