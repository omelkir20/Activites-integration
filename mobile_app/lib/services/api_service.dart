import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/etudiant.dart';
import '../models/departement.dart';

class ApiService {
  // FIX: baseUrl général, pas hardcodé sur /etudiants
  // Sur émulateur Android utiliser 10.0.2.2 au lieu de localhost
  static const String baseUrl = 'http://localhost:8080/api';

  static const _headers = {'Content-Type': 'application/json'};

  // ── ÉTUDIANTS ──────────────────────────────────────────────────────────────

  static Future<List<Etudiant>> fetchEtudiants() async {
    final res = await http.get(Uri.parse('$baseUrl/etudiants'));
    _checkStatus(res);
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((j) => Etudiant.fromJson(j)).toList();
  }

  static Future<Etudiant> createEtudiant(Etudiant e) async {
    final res = await http.post(
      Uri.parse('$baseUrl/etudiants'),
      headers: _headers,
      body: jsonEncode(e.toJson()),
    );
    _checkStatus(res, expected: 201);
    return Etudiant.fromJson(jsonDecode(res.body));
  }

  static Future<Etudiant> updateEtudiant(int id, Etudiant e) async {
    final res = await http.put(
      Uri.parse('$baseUrl/etudiants/$id'),
      headers: _headers,
      body: jsonEncode(e.toJson()),
    );
    _checkStatus(res);
    return Etudiant.fromJson(jsonDecode(res.body));
  }

  static Future<void> deleteEtudiant(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/etudiants/$id'));
    _checkStatus(res, expected: 204);
  }

  // ── DÉPARTEMENTS ───────────────────────────────────────────────────────────

  static Future<List<Departement>> fetchDepartements() async {
    final res = await http.get(Uri.parse('$baseUrl/departements'));
    _checkStatus(res);
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((j) => Departement.fromJson(j)).toList();
  }

  static Future<Departement> createDepartement(Departement d) async {
    final res = await http.post(
      Uri.parse('$baseUrl/departements'),
      headers: _headers,
      body: jsonEncode(d.toJson()),
    );
    _checkStatus(res, expected: 201);
    return Departement.fromJson(jsonDecode(res.body));
  }

  static Future<Departement> updateDepartement(int id, Departement d) async {
    final res = await http.put(
      Uri.parse('$baseUrl/departements/$id'),
      headers: _headers,
      body: jsonEncode(d.toJson()),
    );
    _checkStatus(res);
    return Departement.fromJson(jsonDecode(res.body));
  }

  static Future<void> deleteDepartement(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/departements/$id'));
    _checkStatus(res, expected: 204);
  }

  // ── HELPER ─────────────────────────────────────────────────────────────────

  static void _checkStatus(http.Response res, {int expected = 200}) {
    if (res.statusCode != expected) {
      throw Exception(
          'Erreur serveur ${res.statusCode}: ${res.body}');
    }
  }
}