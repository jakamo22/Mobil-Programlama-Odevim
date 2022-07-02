import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'models/appuser.dart';
import 'screens/bottom_navbar.dart';
import 'screens/login_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

User? user1;
AppUser? appUser;
String? page;

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    
    auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        debugPrint('user boş');
        if (mounted) {
          setState(() {
            page = 'login';
          });
        }
      } else {
        debugPrint('user boş değil');
        debugPrint(user.uid);
        user1 = user;
        final snapshot =
            await firestore.collection('users').doc(user.uid).get();
        appUser = AppUser(
          userEmail: snapshot.data()!['userEmail'],
          username: snapshot.data()!['username'],
          userUid: snapshot.data()!['userUid'],
          isAdmin: snapshot.data()!['isAdmin'],
          // bioText: snapshot.data()!['bioText'],
          // followerCount: snapshot.data()!['followerCount'],
          // followingCount: snapshot.data()!['followingCount'],
          // postCount: snapshot.data()!['postCount'],
          // emailVerified: user.emailVerified,
          // userPhotoUrl: snapshot.data()!['userPhotoUrl'],
          // isPrivate: snapshot.data()!['isPrivate'],
        );
        debugPrint(appUser!.userEmail);
        debugPrint(appUser!.username);
        debugPrint(appUser!.userUid);
        debugPrint(appUser!.isAdmin.toString());
        if (mounted) {
          setState(() {
            page = 'main';
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case 'login':
        {
          return const LoginPage();
        }
      case 'main':
        {
          return const BottomNavBar();
        }
      default:
        {
          return const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
