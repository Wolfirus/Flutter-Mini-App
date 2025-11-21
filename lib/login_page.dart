import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'signup_page.dart';
import 'crud_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  late Box _usersBox;

  @override
  void initState() {
    super.initState();
    // La box "users" est ouverte dans main.dart
    _usersBox = Hive.box('users');
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showDialog('Erreur', 'Veuillez remplir tous les champs');
      return;
    }

    // Vérifier si l'utilisateur existe
    final userData = _usersBox.get(email);

    if (userData == null) {
      _showDialog('Erreur', 'Aucun compte trouvé pour cet email');
      return;
    }

    // userData est un Map sauvegardé lors de l'inscription
    final storedPassword = (userData as Map)['password'] ?? '';

    if (storedPassword != pass) {
      _showDialog('Erreur', 'Mot de passe incorrect');
      return;
    }

    // Connexion réussie → aller à la page CRUD
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CrudPage()),
    );
  }

  void _showDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Connexion'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpPage()),
                );
              },
              child: const Text("Pas de compte ? Inscrivez-vous"),
            ),
          ],
        ),
      ),
    );
  }
}
