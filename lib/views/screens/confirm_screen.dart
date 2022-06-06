import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/upload_controller.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File video;
  final String path;
  const ConfirmScreen({Key? key, required this.path, required this.video})
      : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  TextEditingController songcontroller = TextEditingController();
  TextEditingController captioncontroller = TextEditingController();

  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    setState(() {
      videoController = VideoPlayerController.file(widget.video);
    });
    videoController.initialize();
    videoController.play();
    videoController.setVolume(1);
    videoController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: _media.width,
        height: _media.height,
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: _media.height * .7,
                    width: _media.width,
                    child: VideoPlayer(videoController),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: songcontroller,
                    decoration: const InputDecoration(
                        label: Text('Enter the Song name'),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: captioncontroller,
                    decoration: const InputDecoration(
                        label: Text('Enter a Caption'),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          fixedSize: Size(_media.width * .5, 50)),
                      onPressed: () async {
                        setState(() {
                          _isloading = true;
                        });

                        if (captioncontroller.text.isNotEmpty ||
                            songcontroller.text.isNotEmpty) {
                          await UploadController.instance.uploadveideoinfo(
                              captioncontroller.text,
                              songcontroller.text,
                              widget.path);

                          setState(() {
                            _isloading = false;
                          });
                        } else {
                          Get.snackbar(
                              'not completed fields', 'pleas complete it.');
                        }
                      },
                      child: _isloading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : const Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
