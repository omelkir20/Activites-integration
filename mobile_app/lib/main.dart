import 'package:flutter/material.dart';
import 'models/etudiant.dart';
import 'services/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Étudiants',
      home: const EtudiantsPage(),
    );
  }
}

class EtudiantsPage extends StatefulWidget {
  const EtudiantsPage({super.key});
  @override
  State<EtudiantsPage> createState() => _EtudiantsPageState();
}

class _EtudiantsPageState extends State<EtudiantsPage> {
  late Future<List<Etudiant>> _futurEtudiants;

  @override
  void initState() {
    super.initState();
    _futurEtudiants = ApiService.fetchEtudiants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des étudiants')),
      body: FutureBuilder<List<Etudiant>>(
        future: _futurEtudiants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final etudiants = snapshot.data!;
          return ListView.builder(
            itemCount: etudiants.length,
            itemBuilder: (context, index) {
              final e = etudiants[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(e.nom),
                  subtitle: Text('CIN : ${e.cin}\nNé(e) le : ${e.dateNaissance}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}