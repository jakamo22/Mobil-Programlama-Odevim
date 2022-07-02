import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({Key? key}) : super(key: key);

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Silme Sayfası')),
      body: SafeArea(
        child: StreamBuilder(
          stream: firestore
              .collection('urunler')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const Text("There is no expense");
              return ListView(
                children: getExpenseItems(snapshot),
              );
          },
        ),
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
                  debugPrint(snapshot.data!.docs.first.id);
                },
                child: Container(
                  width: width * 0.9,
                  color: Colors.black26,
                  child: ListTile(
                    title: Text(doc["bitki-adi"]),
                    subtitle: Text(doc["kilo-fiyati"]),
                    trailing: IconButton(icon: const Icon(CupertinoIcons.delete), onPressed: () {
                      firestore.collection('urunler').doc(doc.id).delete();
                    },),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}
