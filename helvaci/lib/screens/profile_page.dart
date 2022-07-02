// ignore_for_file: file_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import '../main.dart';
import 'login_page.dart';
import 'my_plants.dart';

class ProfilePage extends StatefulWidget {
  var user;

  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

TextEditingController _firstController = TextEditingController();
TextEditingController _secondController = TextEditingController();
TextEditingController _thirdController = TextEditingController();
PlatformFile? pickedFile;
UploadTask? uploadTask;
bool isUploading = false;

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Sayfası'),
        actions: [
          (() {
            if (appUser!.isAdmin) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const MyPlants()),
                  );
                },
                icon: const Icon(CupertinoIcons.delete),
              );
            } else {
              return Container();
            }
          }()),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pickedFile == null
                  ? OutlinedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.image,
                        );
                        if (result?.files.single == null) {
                          pickedFile == null;
                          return;
                        }
                        setState(() {
                          pickedFile = result!.files.single;
                        });
                      },
                      child: const Text('Resim Seç'),
                    )
                  : Image.file(
                      File(pickedFile!.path!),
                      width: width * 0.5,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.9,
                child: TextField(
                  controller: _firstController,
                  autocorrect: false,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon:
                        Icon(CupertinoIcons.bubble_left, color: Colors.grey),
                    labelText: 'bitki-adi',
                    floatingLabelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.9,
                child: TextField(
                  controller: _thirdController,
                  autocorrect: false,
                  enableSuggestions: true,
                  minLines: 3,
                  maxLines: 3,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon:
                        Icon(CupertinoIcons.command, color: Colors.grey),
                    labelText: 'Açıklama',
                    floatingLabelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              (() {
                if (appUser!.isAdmin) {
                  if (isUploading) {
                    return SizedBox(
                      width: width * 0.4,
                      child: const SizedBox(
                        height: 41,
                        width: 20,
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  } else {
                    return OutlinedButton(
                      onPressed: () async {
                        setState(() {
                          isUploading = true;
                        });
                        final path = pickedFile!.path.toString();
                        final file = File(pickedFile!.path!);
                        uploadTask = storageRef.child(path).putFile(file);
                        final snapshot =
                            await uploadTask!.whenComplete(() => null);
                        final url = await snapshot.ref.getDownloadURL();
                        await firestore.collection('urunler').doc().set({
                          'bitki-adi': _firstController.text,
                          'kilo-fiyati': _secondController.text,
                          'aciklama': _thirdController.text,
                          'uploaderUID': widget.user!.uid,
                          'imageUrl': url,
                          'time': DateTime.now(),
                        });
                        setState(() {
                          isUploading = false;
                        });
                      },
                      child: const Text('Yükle'),
                    );
                  }
                } else {
                  return const Text('Admin değilsiniz.');
                }
              }()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      auth.signOut();
                      isLoginLoading = false;
                      isCreateLoading = false;
                    },
                    child: const Text('Çıkış Yap'),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () async {
                      firestore
                          .collection('users')
                          .doc(widget.user!.uid)
                          .delete();
                      firestore
                          .collection('users')
                          .doc(widget.user!.uid)
                          .collection('bitki')
                          .doc()
                          .delete();
                      auth.currentUser?.delete();
                      isLoginLoading = false;
                      isCreateLoading = false;
                    },
                    child: const Text('Hesabı Sil'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
