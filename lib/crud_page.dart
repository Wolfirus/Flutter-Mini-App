// lib/crud_page.dart
import 'package:flutter/material.dart';
import 'main.dart'; // Contact class

class CrudPage extends StatefulWidget {
  final List<Contact> contacts;
  final void Function(Contact contact) onAddContact;
  final void Function(int index, Contact updated) onEditContact;
  final void Function(int index) onDeleteContact;

  const CrudPage({
    super.key,
    required this.contacts,
    required this.onAddContact,
    required this.onEditContact,
    required this.onDeleteContact,
  });

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _openForm({int? index}) {
    if (index != null) {
      final contact = widget.contacts[index];
      _nameCtrl.text = contact.name;
      _phoneCtrl.text = contact.phone;
      _emailCtrl.text = contact.email;
    } else {
      _nameCtrl.clear();
      _phoneCtrl.clear();
      _emailCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Text(
                index == null ? 'Add Contact' : 'Edit Contact',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final name = _nameCtrl.text.trim();
                    final phone = _phoneCtrl.text.trim();
                    final email = _emailCtrl.text.trim();

                    if (name.isEmpty || phone.isEmpty) return;

                    final newContact = Contact(
                      id: index?.toString() ??
                          DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                      name: name,
                      phone: phone,
                      email: email.isEmpty ? 'no-email@example.com' : email,
                    );

                    if (index == null) {
                      widget.onAddContact(newContact);
                    } else {
                      widget.onEditContact(index, newContact);
                    }

                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(index == null ? 'Add' : 'Save'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _delete(int index) {
    widget.onDeleteContact(index);
  }

  @override
  Widget build(BuildContext context) {
    final contacts = widget.contacts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: contacts.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.inbox_outlined,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'No contacts yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Use the + button below to add your first contact.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final c = contacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  c.name.isNotEmpty
                      ? c.name[0].toUpperCase()
                      : '?',
                ),
              ),
              title: Text(c.name),
              subtitle: Text(c.phone),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _openForm(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
