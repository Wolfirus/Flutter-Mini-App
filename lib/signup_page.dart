import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  void _handleSignUp() {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showDialog('Erreur', 'Veuillez remplir tous les champs');
      return;
    }

    // Vérifier si un compte avec cet email existe déjà
    if (_usersBox.containsKey(email)) {
      _showDialog('Erreur', 'Un compte existe déjà avec cet email');
      return;
    }

    // Sauvegarder l'utilisateur dans Hive
    _usersBox.put(email, {
      'email': email,
      'password': pass,
    });

    emailCtrl.clear();
    passCtrl.clear();

    // Option 1 : revenir à l'écran de connexion après inscription
    _showDialog(
      'Succès',
      'Compte créé avec succès. Vous pouvez maintenant vous connecter.',
      onOk: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      },
    );
  }

  void _showDialog(String title, String msg, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
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
              onPressed: _handleSignUp,
              child: const Text("S'inscrire"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Déjà un compte ? Connectez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
