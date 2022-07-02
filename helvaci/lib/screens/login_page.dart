// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helvaci/models/appuser.dart';
import '../home.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController _usernameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
bool isCreateLoading = false;
bool isLoginLoading = false;
bool value = false;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: width),
                const Text(
                  'Giriş Sayfası',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: width * 0.9,
                  child: TextField(
                    controller: _usernameController,
                    autocorrect: false,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      prefixIcon: Icon(CupertinoIcons.mail, color: Colors.grey),
                      hintText: 'Username (eğer kayıtlıysanız gerek yok)',
                      floatingLabelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: width * 0.9,
                  child: TextField(
                    controller: _emailController,
                    autocorrect: false,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      prefixIcon: Icon(CupertinoIcons.mail, color: Colors.grey),
                      hintText: 'Email adresiniz',
                      floatingLabelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: width * 0.9,
                  child: TextField(
                    controller: _passwordController,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      prefixIcon: Icon(CupertinoIcons.lock, color: Colors.grey),
                      hintText: 'Şifreniz',
                      floatingLabelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Admin misiniz?'),
                    const SizedBox(width: 20),
                    CupertinoSwitch(
                      value: value,
                      onChanged: (x) {
                        if (mounted) {
                          setState(() {
                           value = x;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isCreateLoading
                        ? SizedBox(
                            width: width * 0.4,
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : SizedBox(
                            width: width * 0.4,
                            child: OutlinedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isCreateLoading = true;
                                  });
                                  User? user = (await auth
                                          .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ))
                                      .user;
                                  await firestore
                                      .collection('users')
                                      .doc(user!.uid)
                                      .set({
                                    'userUid': user.uid,
                                    'username': _usernameController.text,
                                    'userEmail': user.email,
                                    'userPassword': _passwordController.text,
                                    'firstLogin': DateTime.now(),
                                    'lastLogin': DateTime.now(),
                                    'isAdmin': value,
                                  });
                                  appUser = AppUser(
                                    userEmail: user.email!,
                                    userUid: user.uid,
                                    isAdmin: value,
                                    username: '',
                                  );
                                } on FirebaseAuthException catch (e) {
                                  debugPrint('toast message:${e.toString()}');
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    gravity: ToastGravity.CENTER,
                                  );
                                  setState(() {
                                    isCreateLoading = false;
                                  });
                                }
                              },
                              child: const Text('Kayıt Ol'),
                            ),
                          ),
                    SizedBox(width: width * 0.1),
                    isLoginLoading
                        ? SizedBox(
                            width: width * 0.4,
                            child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : SizedBox(
                            width: width * 0.4,
                            child: OutlinedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isLoginLoading = true;
                                  });
                                  User? user =
                                      (await auth.signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ))
                                          .user;
                                  await firestore
                                      .collection('users')
                                      .doc(user!.uid)
                                      .update({
                                    'lastLogin': DateTime.now(),
                                  });
                                } on FirebaseAuthException catch (e) {
                                  debugPrint('toast message:${e.toString()}');
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    gravity: ToastGravity.CENTER,
                                  );
                                  setState(() {
                                    isLoginLoading = false;
                                  });
                                }
                              },
                              child: const Text('Giriş Yap'),
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../main.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// TextEditingController _emailController = TextEditingController();
// TextEditingController _passwordController = TextEditingController();
// User? user;

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login Page')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(height: 80),
//             SizedBox(
//               width: width * 0.9,
//               child: TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                   ),
//                   hintText: 'Email',
//                   // hintText: 'T.C Kimlik Numaranız',
//                   floatingLabelStyle: TextStyle(color: Colors.grey),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                     borderSide: BorderSide(color: Colors.transparent),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: width * 0.9,
//               child: TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                   ),
//                   hintText: 'Password',
//                   // hintText: 'T.C Kimlik Numaranız',
//                   floatingLabelStyle: TextStyle(color: Colors.grey),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                     borderSide: BorderSide(color: Colors.transparent),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: width * 0.5,
//               height: 40,
//               child: ElevatedButton(
//                 // GİRİŞ YAPMA İŞLEMLERİ BURADA YAPILACAK
//                 onPressed: () async {
//                   try {
//                     user = (await auth.signInWithEmailAndPassword(
//                       email: _emailController.text,
//                       password: _passwordController.text,
//                     ))
//                         .user;
//                     await firestore.collection('users').doc(user!.uid).update({
//                       'lastLogin': DateTime.now(),
//                     });
//                   } on FirebaseAuthException catch (e) {
//                     debugPrint('toast message:${e.toString()}');
//                     Fluttertoast.showToast(
//                       msg: e.toString(),
//                       gravity: ToastGravity.CENTER,
//                     );
//                   }
//                 },
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   elevation: MaterialStateProperty.all<double>(0),
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                     const Color.fromARGB(255, 60, 54, 133),
//                   ),
//                 ),
//                 child: const Text(
//                   'Giriş Yap',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
