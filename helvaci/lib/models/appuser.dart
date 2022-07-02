import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String username;
  final String userEmail;
  final String userUid;
  final bool isAdmin;

  AppUser({
    required this.isAdmin,
    required this.userEmail,
    required this.username,
    required this.userUid,
  });

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      username: doc['userName'],
      userEmail: doc['userEmail'],
      userUid: doc['userUid'],
      isAdmin: doc['isPrivate'],
    );
  }
}
