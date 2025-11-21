import 'package:flutter/material.dart';
import 'login_page.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final List<Map<String, String>> _contacts = [];

  void _addContact() {
    if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
    setState(() {
      _contacts.add({'name': nameCtrl.text, 'phone': phoneCtrl.text});
      nameCtrl.clear();
      phoneCtrl.clear();
    });
  }

  void _editContact(int index) {
    nameCtrl.text = _contacts[index]['name']!;
    phoneCtrl.text = _contacts[index]['phone']!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Téléphone')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _contacts[index] = {
                  'name': nameCtrl.text,
                  'phone': phoneCtrl.text,
                };
              });
              nameCtrl.clear();
              phoneCtrl.clear();
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(int index) {
    setState(() => _contacts.removeAt(index));
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire CRUD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Téléphone')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addContact, child: const Text('Ajouter')),
            const Divider(),
            Expanded(
              child: _contacts.isEmpty
                  ? const Center(child: Text('Aucun contact'))
                  : ListView.builder(
                      itemCount: _contacts.length,
                      itemBuilder: (_, i) {
                        final c = _contacts[i];
                        return ListTile(
                          title: Text(c['name']!),
                          subtitle: Text(c['phone']!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editContact(i)),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteContact(i)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
