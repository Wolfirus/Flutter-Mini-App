// lib/contacts_page.dart
import 'package:flutter/material.dart';
import 'models/contact.dart';
import 'services/hive_service.dart';
import 'contact_detail_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contacts = HiveService.loadContacts();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    }
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  void _openForm({int? index}) {
    if (index != null) {
      final contact = _contacts[index];
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
                  onPressed: () async {
                    final name = _nameCtrl.text.trim();
                    final phone = _phoneCtrl.text.trim();
                    final email = _emailCtrl.text.trim();

                    if (name.isEmpty || phone.isEmpty) return;

                    String id;
                    if (index == null) {
                      id = DateTime.now()
                          .millisecondsSinceEpoch
                          .toString();
                    } else {
                      id = _contacts[index].id;
                    }

                    final contact = Contact(
                      id: id,
                      name: name,
                      phone: phone,
                      email: email.isEmpty ? 'no-email@example.com' : email,
                    );

                    if (index == null) {
                      setState(() {
                        _contacts = [..._contacts, contact];
                      });
                    } else {
                      setState(() {
                        _contacts = [
                          for (int i = 0; i < _contacts.length; i++)
                            if (i == index) contact else _contacts[i],
                        ];
                      });
                    }

                    await HiveService.saveContact(contact);

                    if (mounted) {
                      Navigator.pop(context);
                    }
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

  void _deleteContact(int index) async {
    final contact = _contacts[index];
    setState(() {
      _contacts = [
        for (int i = 0; i < _contacts.length; i++)
          if (i != index) _contacts[i],
      ];
    });
    await HiveService.deleteContact(contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: _contacts.isEmpty
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
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Hero(
                      tag: 'avatar_${contact.id}',
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: contact.avatarUrl.isNotEmpty
                            ? NetworkImage(contact.avatarUrl)
                            : null,
                        child: contact.avatarUrl.isEmpty
                            ? Text(
                          _getInitials(contact.name),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                            : null,
                      ),
                    ),
                    title: Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      contact.phone,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ContactDetailPage(contact: contact),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openForm(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteContact(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}


