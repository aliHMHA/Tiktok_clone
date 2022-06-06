import 'package:flutter/material.dart';

class CustomIcon extends StatefulWidget {
  const CustomIcon({Key? key}) : super(key: key);

  @override
  State<CustomIcon> createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 60,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Color.fromARGB(255, 32, 211, 234)),
          width: 50,
          height: 45,
          margin: EdgeInsets.only(left: 10),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Color.fromARGB(255, 250, 45, 108),
          ),
          width: 50,
          height: 45,
          margin: EdgeInsets.only(right: 10),
        ),
        Positioned(
          left: 6,
          right: 6,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Colors.white,
            ),
            width: 50,
            height: 45,
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.black,
            ),
          ),
        )
      ]),
    );
  }
}
