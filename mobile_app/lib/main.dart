import 'package:flutter/material.dart';
import 'models/etudiant.dart';
import 'models/departement.dart';
import 'services/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniManager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [EtudiantsPage(), DepartementsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Étudiants',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Départements',
          ),
        ],
      ),
    );
  }
}

// ─── ÉTUDIANTS PAGE ───────────────────────────────────────────────────────────

class EtudiantsPage extends StatefulWidget {
  const EtudiantsPage({super.key});
  @override
  State<EtudiantsPage> createState() => _EtudiantsPageState();
}

class _EtudiantsPageState extends State<EtudiantsPage> {
  List<Etudiant> _etudiants = [];
  List<Departement> _departements = [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        ApiService.fetchEtudiants(),
        ApiService.fetchDepartements(),
      ]);
      setState(() {
        _etudiants    = results[0] as List<Etudiant>;
        _departements = results[1] as List<Departement>;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _deptName(int? id) {
    if (id == null) return '—';
    try { return _departements.firstWhere((d) => d.id == id).nom; }
    catch (_) { return '—'; }
  }

  List<Etudiant> get _filtered => _search.isEmpty
      ? _etudiants
      : _etudiants.where((e) =>
          e.nom.toLowerCase().contains(_search.toLowerCase()) ||
          e.cin.toLowerCase().contains(_search.toLowerCase())).toList();

  void _showForm([Etudiant? etudiant]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EtudiantForm(
        etudiant: etudiant,
        departements: _departements,
        onSaved: _load,
      ),
    );
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer'),
        content: const Text('Supprimer cet étudiant ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true) { await ApiService.deleteEtudiant(id); _load(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Étudiants'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Erreur : $_error'))
              : _filtered.isEmpty
                  ? const Center(child: Text('Aucun étudiant.'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (ctx, i) {
                          final e = _filtered[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(child: Text(e.nom[0].toUpperCase())),
                              title: Text(e.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'CIN : ${e.cin}\nNé(e) le : ${e.dateNaissance}'
                                '${e.annee != null ? "\nAnnée ${e.annee}" : ""}'
                                '\nDépt : ${_deptName(e.departementId)}',
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _showForm(e)),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () => _delete(e.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

// ─── DÉPARTEMENTS PAGE ────────────────────────────────────────────────────────

class DepartementsPage extends StatefulWidget {
  const DepartementsPage({super.key});
  @override
  State<DepartementsPage> createState() => _DepartementsPageState();
}

class _DepartementsPageState extends State<DepartementsPage> {
  List<Departement> _departements = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final d = await ApiService.fetchDepartements();
      setState(() { _departements = d; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _showForm([Departement? dept]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DepartementForm(departement: dept, onSaved: _load),
    );
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer'),
        content: const Text('Supprimer ce département ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true) { await ApiService.deleteDepartement(id); _load(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Départements')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Erreur : $_error'))
              : _departements.isEmpty
                  ? const Center(child: Text('Aucun département.'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _departements.length,
                        itemBuilder: (ctx, i) {
                          final d = _departements[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(d.code?.isNotEmpty == true ? d.code![0] : '?'),
                              ),
                              title: Text(d.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Code : ${d.code ?? "—"}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _showForm(d)),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () => _delete(d.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

// ─── FORMS ────────────────────────────────────────────────────────────────────

class EtudiantForm extends StatefulWidget {
  final Etudiant? etudiant;
  final List<Departement> departements;
  final VoidCallback onSaved;
  const EtudiantForm({super.key, this.etudiant, required this.departements, required this.onSaved});
  @override
  State<EtudiantForm> createState() => _EtudiantFormState();
}

class _EtudiantFormState extends State<EtudiantForm> {
  final _cin  = TextEditingController();
  final _nom  = TextEditingController();
  final _date = TextEditingController();
  int _annee = 1;
  int? _deptId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.etudiant;
    if (e != null) {
      _cin.text  = e.cin;
      _nom.text  = e.nom;
      _date.text = e.dateNaissance;
      _annee  = e.annee ?? 1;
      _deptId = e.departementId;
    }
  }

  Future<void> _save() async {
    if (_nom.text.trim().isEmpty || _cin.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final dto = Etudiant(
      id: widget.etudiant?.id ?? 0,
      cin: _cin.text.trim(),
      nom: _nom.text.trim(),
      dateNaissance: _date.text,
      annee: _annee,
      departementId: _deptId,
    );
    try {
      if (widget.etudiant == null) await ApiService.createEtudiant(dto);
      else await ApiService.updateEtudiant(dto.id, dto);
      if (mounted) { Navigator.pop(context); widget.onSaved(); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.etudiant == null ? 'Nouvel étudiant' : 'Modifier étudiant',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(controller: _cin, decoration: const InputDecoration(labelText: 'CIN', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _date, decoration: const InputDecoration(labelText: 'Date naissance (AAAA-MM-JJ)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _annee,
              decoration: const InputDecoration(labelText: 'Année', border: OutlineInputBorder()),
              items: [1, 2, 3].map((a) => DropdownMenuItem(value: a, child: Text('Année $a'))).toList(),
              onChanged: (v) => setState(() => _annee = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _deptId,
              decoration: const InputDecoration(labelText: 'Département', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: null, child: Text('— Aucun —')),
                ...widget.departements.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nom))),
              ],
              onChanged: (v) => setState(() => _deptId = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Enregistrer'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class DepartementForm extends StatefulWidget {
  final Departement? departement;
  final VoidCallback onSaved;
  const DepartementForm({super.key, this.departement, required this.onSaved});
  @override
  State<DepartementForm> createState() => _DepartementFormState();
}

class _DepartementFormState extends State<DepartementForm> {
  final _nom  = TextEditingController();
  final _code = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.departement != null) {
      _nom.text  = widget.departement!.nom;
      _code.text = widget.departement!.code ?? '';
    }
  }

  Future<void> _save() async {
    if (_nom.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final dto = Departement(
      id: widget.departement?.id ?? 0,
      nom: _nom.text.trim(),
      code: _code.text.trim().toUpperCase(),
    );
    try {
      if (widget.departement == null) await ApiService.createDepartement(dto);
      else await ApiService.updateDepartement(dto.id, dto);
      if (mounted) { Navigator.pop(context); widget.onSaved(); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.departement == null ? 'Nouveau département' : 'Modifier département',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _code, decoration: const InputDecoration(labelText: 'Code', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Enregistrer'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
