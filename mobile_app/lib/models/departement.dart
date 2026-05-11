// FIX: Le backend DepartementDTO n'a que id et nom.
// Le champ "code" n'existe pas — supprimé.
class Departement {
  final int id;
  final String nom;

  Departement({
    required this.id,
    required this.nom,
  });

  factory Departement.fromJson(Map<String, dynamic> json) {
    return Departement(
      id: json['id'] as int,
      nom: json['nom'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
    };
  }
}