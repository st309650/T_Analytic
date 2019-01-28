class User {
  final String bio;
  final String id;
  final String name;
  final String createdDate;

  User({this.bio, this.id, this.name, this.createdDate});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      bio: json['bio'],
      id: json['id'],
      name: json['name'],
      createdDate: json['createdDate'],
    );
  }
}