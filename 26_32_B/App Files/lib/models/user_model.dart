
class UserModel {
  final String id; // Unique user ID
  final String name; // Full name of the user
  final String email; // Email of the user
  final String
      password; // Encrypted or plain password (depending on implementation)
  final String role; // Role of the user: 'Admin' or 'User'
  final List<String> bookedEvents; // List of event IDs booked by the user

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.bookedEvents,
  });

  // Converts UserModel to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'bookedEvents': bookedEvents,
    };
  }

  // Converts JSON back to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      bookedEvents: List<String>.from(json['bookedEvents'] ?? []),
    );
  }

  // Create an empty user instance (useful for initialization)
  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      password: '',
      role: 'User', // Default role
      bookedEvents: [],
    );
  }
}
