// lib/contact_detail_page.dart
import 'package:flutter/material.dart';
import 'main.dart'; // for Contact class

class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({
    super.key,
    required this.contact,
  });

  String get initials {
    final parts = contact.name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    }
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Hero(
                    tag: 'avatar_${contact.id}',
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: contact.avatarUrl.isNotEmpty
                          ? NetworkImage(contact.avatarUrl)
                          : null,
                      child: contact.avatarUrl.isEmpty
                          ? Text(
                        initials,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    contact.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contact.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(icon: Icons.call, label: 'Call'),
                      const SizedBox(width: 24),
                      _ActionButton(icon: Icons.message, label: 'Message'),
                      const SizedBox(width: 24),
                      _ActionButton(icon: Icons.email, label: 'Email'),
                    ],
                  )
                ],
              ),
            ),

            // Details
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _InfoTile(
                    title: "Phone",
                    value: contact.phone,
                    icon: Icons.phone_android,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    title: "Email",
                    value: contact.email,
                    icon: Icons.alternate_email,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
