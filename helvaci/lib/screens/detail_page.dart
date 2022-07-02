import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class DetailPage extends StatefulWidget {
  var aciklama;
  var imageurl;
  var meyvesebzeadi;
  var time;
  var user;
  DetailPage({
    Key? key,
    required this.meyvesebzeadi,
    required this.aciklama,
    required this.imageurl,
    required this.time,
    required this.user,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detaylar'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: width * 0.1),
              CachedNetworkImage(
                imageUrl: widget.imageurl,
                placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 20),
              Text(widget.meyvesebzeadi),
              const SizedBox(height: 20),
              Text(widget.aciklama),
              // const SizedBox(height: 20),
              // Text(widget.kilofiyati),
            ],
          ),
        ),
      ),
    );
  }
}
