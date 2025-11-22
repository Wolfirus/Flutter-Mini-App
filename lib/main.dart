// lib/main.dart
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'signup_page.dart';
import 'contacts_page.dart';
import 'crud_page.dart';
import 'contact_detail_page.dart'; // just for type references

void main() {
  runApp(const MyApp());
}

class Contact {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String avatarUrl; // optional (for photo later)

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.avatarUrl = '',
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mini Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),

      // 👉 IMPORTANT: start on the login screen
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 1; // Start on Contacts tab

  /// 👉 This is the shared list of contacts for the whole app
  List<Contact> _contacts = [];

  void _addContact(Contact contact) {
    setState(() {
      _contacts = [..._contacts, contact];
    });
  }

  void _editContact(int index, Contact updated) {
    setState(() {
      _contacts = [
        for (int i = 0; i < _contacts.length; i++)
          if (i == index) updated else _contacts[i],
      ];
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts = [
        for (int i = 0; i < _contacts.length; i++)
          if (i != index) _contacts[i],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardPage(),
      ContactsPage(contacts: _contacts),
      CrudPage(
        contacts: _contacts,
        onAddContact: _addContact,
        onEditContact: _editContact,
        onDeleteContact: _deleteContact,
      ),
    ];

    final titles = [
      'Dashboard',
      'Contacts',
      'Manage Contacts',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'CRUD',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.dashboard,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Use the bottom navigation bar to access your contacts and manage them.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
