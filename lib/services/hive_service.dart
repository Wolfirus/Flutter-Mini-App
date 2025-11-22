// lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact.dart';

class HiveService {
  static const String contactsBoxName = 'contacts_box';
  static const String usersBoxName = 'users_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(contactsBoxName);
    await Hive.openBox(usersBoxName);
  }

  static Box get _contactsBox => Hive.box(contactsBoxName);
  static Box get _usersBox => Hive.box(usersBoxName);

  // ---------- CONTACTS ----------

  static List<Contact> loadContacts() {
    return _contactsBox.values.map((value) {
      final map = Map<dynamic, dynamic>.from(value as Map);
      return Contact.fromMap(map);
    }).toList();
  }

  static Future<void> saveContact(Contact contact) async {
    await _contactsBox.put(contact.id, contact.toMap());
  }

  static Future<void> deleteContact(String id) async {
    await _contactsBox.delete(id);
  }

  // ---------- USERS / AUTH ----------

  static Future<void> saveUser({
    required String email,
    required String password,
  }) async {
    await _usersBox.put(email, {
      'email': email,
      'password': password,
    });
  }

  static bool userExists(String email) {
    return _usersBox.containsKey(email);
  }

  static bool validateUser(String email, String password) {
    if (!_usersBox.containsKey(email)) return false;
    final data =
    Map<dynamic, dynamic>.from(_usersBox.get(email) as Map<dynamic, dynamic>);
    final storedPassword = data['password'] as String;
    return storedPassword == password;
  }
}
