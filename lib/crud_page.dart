import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'login_page.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  late Box _contactsBox;

  @override
  void initState() {
    super.initState();
    // La box "contacts" est déjà ouverte dans main.dart
    _contactsBox = Hive.box('contacts');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _addContact() {
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty || phone.isEmpty) return;

    _contactsBox.add({
      'name': name,
      'phone': phone,
    });

    nameCtrl.clear();
    phoneCtrl.clear();
  }

  void _editContact(int index) {
    final contact = _contactsBox.getAt(index) as Map;

    nameCtrl.text = contact['name'] ?? '';
    phoneCtrl.text = contact['phone'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Téléphone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameCtrl.clear();
              phoneCtrl.clear();
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final newName = nameCtrl.text.trim();
              final newPhone = phoneCtrl.text.trim();

              if (newName.isEmpty || newPhone.isEmpty) return;

              _contactsBox.putAt(index, {
                'name': newName,
                'phone': newPhone,
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
    _contactsBox.deleteAt(index);
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
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Téléphone'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('Ajouter'),
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _contactsBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('Aucun contact'));
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (_, i) {
                      final contact = box.getAt(i) as Map;
                      final name = contact['name'] ?? '';
                      final phone = contact['phone'] ?? '';

                      return ListTile(
                        title: Text(name),
                        subtitle: Text(phone),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editContact(i),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteContact(i),
                            ),
                          ],
                        ),
                      );
                    },
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
