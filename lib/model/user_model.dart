class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;
  final String phoneNumber;

  UserModel(
      {required this.uid, required this.email, required this.name, required this.photoUrl, required this.phoneNumber});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'photoUrl': photoUrl,
        'phoneNumber': phoneNumber,
      };
}
