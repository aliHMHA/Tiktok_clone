import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/controllers/upload_controller.dart';
import 'package:tiktok_clone/models/vedio_model.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/comments_scren.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/profile_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok_clone/views/widgets/circule_animation.dart';

class PlayerScreen extends StatefulWidget {
  final VideoModel video;
  final bool isfromprofile;

  const PlayerScreen({
    Key? key,
    required this.video,
    required this.isfromprofile,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = VideoPlayerController.network(widget.video.videoUrl);
    });
    _controller.initialize();
    _controller.play();
    _controller.setVolume(1);
    _controller.setLooping(false);

    _controller.addListener(() {
      setState(() {
        _isplayng = !_isplayng;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool _isplayng = true;

  musicalbumicon() {
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
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/placeHolder2.jpg'),
                  image: NetworkImage(
                    widget.video.profileimageurl,
                  ),
                  fit: BoxFit.cover,
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (_isplayng) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              },
              child: VideoPlayer(_controller),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              height: _media.height * .6,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!widget.isfromprofile) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (stx) => ProfileScreen(
                                        profileOnerid: widget.video.ownerid,
                                      )));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Stack(
                        children: [
                          const SizedBox(
                            height: 69,
                            width: 64,
                          ),
                          Positioned(
                            top: 0,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CircleAvatar(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder: const AssetImage(
                                            'assets/images/placeHolder2.jpg'),
                                        image: NetworkImage(
                                            widget.video.profileimageurl)),
                                  ),
                                  radius: 30,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            left: 21,
                            child: CircleAvatar(
                              radius: 11,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () => UploadController.instance.likevideo(
                            videoOwnerid: widget.video.ownerid,
                            uid: firbaseAuth11.currentUser!.uid,
                            videoid: widget.video.videoid,
                            likes: widget.video.likes),
                        icon: widget.video.likes
                                .contains(firbaseAuth11.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 40,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 40,
                              )),
                    Text(widget.video.likes.length.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white)),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const CommentsScreen(
                                    isPush: true,
                                  )));
                        },
                        icon: const Icon(
                          Icons.comment_outlined,
                          color: Colors.white,
                          size: 40,
                        )),
                    Text(
                      widget.video.comments.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.snackbar('Not yet', 'It will be avilable soon');
                        },
                        icon: const Icon(
                          Icons.reply,
                          color: Colors.white,
                          size: 40,
                        )),
                    Text(widget.video.share.length.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    CircilAnimation(
                      child: musicalbumicon(),
                    )
                  ]),
            ),
            Positioned(
                left: 7,
                bottom: 5,
                child: SizedBox(
                  width: _media.width * .75,
                  height: _media.height * .1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        widget.video.description,
                        style:
                            const TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.audiotrack_sharp,
                            color: Colors.white,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            widget.video.songname,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            if (!_isplayng)
              GestureDetector(
                onTap: () {
                  if (_isplayng) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 120,
                      color: Colors.grey[350],
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
