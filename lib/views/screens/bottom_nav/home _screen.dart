import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/models/vedio_model.dart';
import 'package:tiktok_clone/views/screens/player_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? videoid;
  final String? vidreoowneroid;

  const HomeScreen(
      {Key? key, required this.vidreoowneroid, required this.videoid})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  musicalbumicon(String profilimage) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: [Colors.white, Colors.grey]),
                borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  profilimage,
                  fit: BoxFit.cover,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool runSpecificvedio = widget.videoid != null;
      List<VideoModel> videolist = widget.videoid != null
          ? VideoController.instance.videolist
              .where((element) => element.ownerid == widget.vidreoowneroid)
              .toList()
          : VideoController.instance.videolist;
      return PageView.builder(
          itemCount: videolist.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, ind) {
            VideoModel video = runSpecificvedio
                ? videolist
                    .where((element) => element.videoid == widget.videoid)
                    .toList()[0]
                : videolist[ind];

            VideoController.instance.currentvideo = video;
            runSpecificvedio = false;
            return PlayerScreen(
              video: video,
              isfromprofile: widget.videoid != null,
            );
          });
    });
  }
}
