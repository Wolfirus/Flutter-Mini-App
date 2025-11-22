// lib/models/contact.dart
class Contact {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String avatarUrl; // optional, for photo later

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  factory Contact.fromMap(Map<dynamic, dynamic> map) {
    return Contact(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      avatarUrl: (map['avatarUrl'] ?? '') as String,
    );
  }
}
