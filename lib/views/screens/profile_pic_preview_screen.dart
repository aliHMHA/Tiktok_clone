import 'package:flutter/material.dart';

class ProfilPicPrevies extends StatelessWidget {
  final String imageurl;
  const ProfilPicPrevies({Key? key, required this.imageurl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FadeInImage(
        image: NetworkImage(imageurl),
        placeholder: const AssetImage('assets/images/placeHolder2.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}
