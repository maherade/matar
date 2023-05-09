import 'package:flutter/material.dart';

class FullMapScreen extends StatelessWidget {
  String? image;
  int? index;

  FullMapScreen({super.key, required this.image, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                child: InteractiveViewer(
                  child: Image.network(
                    image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("can not load image");
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
