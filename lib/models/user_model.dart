class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin', 'faculty', 'student'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isFaculty => role == 'faculty' || isAdmin;
}
