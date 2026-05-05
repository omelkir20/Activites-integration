import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/etudiant.dart';

class ApiService {
  // Remplace par l'IP de ta machine (pas localhost sur un téléphone physique)
  static const String baseUrl = 'http://192.168.1.X:8080/api/etudiants';

  static Future<List<Etudiant>> fetchEtudiants() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Etudiant.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement');
    }
  }
}