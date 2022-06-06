import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tiktok_clone/controllers/upload_controller.dart';
import 'package:tiktok_clone/views/screens/confirm_screen.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  File? image;

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              image = await UploadController.instance.showdialogforimagepick(
                  context: context, media: _media, isvedio: true);
              if (image != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            ConfirmScreen(path: image!.path, video: image!)));
              }
            },
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                primary: Colors.red,
                onPrimary: Colors.black,
                fixedSize: Size(_media.width * .7, 60)),
            child: const Text('Add a video.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      ),
    );
  }
}
