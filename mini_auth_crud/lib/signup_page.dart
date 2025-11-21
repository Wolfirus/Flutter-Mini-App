import 'package:flutter/material.dart';
import 'crud_page.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void _handleSignUp() {
    String email = emailCtrl.text.trim();
    String pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showDialog('Erreur', 'Veuillez remplir tous les champs');
      return;
    }

    // 👉 Normally you'd save user info here
    // For now, directly go to CRUD page
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
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
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
                onPressed: _handleSignUp, child: const Text("S'inscrire")),
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
