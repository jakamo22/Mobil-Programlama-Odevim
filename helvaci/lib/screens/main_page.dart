// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/screens/detail_page.dart';
import '/home.dart';
import '/main.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitki Bilgileri'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("urunler")
                // .where('isAdmin', isEqualTo: true)
                .orderBy('time', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text("There is no expense");
              return ListView(
                children: getExpenseItems(snapshot),
              );
            }),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    final width = MediaQuery.of(context).size.width;
    return snapshot.data!.docs
        .map(
          (doc) => Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DetailPage(
                          aciklama: doc["aciklama"],
                          imageurl: doc["imageUrl"],
                          // kilofiyati: doc["kilo-fiyati"],
                          meyvesebzeadi: doc["bitki-adi"],
                          time: doc["time"],
                          user: user1,
                        ),
                      ));
                },
                child: Container(
                  width: width * 0.9,
                  color: Colors.black26,
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: doc["imageUrl"],
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(doc["bitki-adi"]),
                    // subtitle: Text(doc["kilo-fiyati"]),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}
