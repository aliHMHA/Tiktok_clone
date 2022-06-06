import 'package:flutter/material.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/controllers/upload_controller.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentsWindow extends StatelessWidget {
  final Comment comment;

  const CommentsWindow({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userid = firbaseAuth11.currentUser!.uid;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: backgroundColor, border: Border(top: BorderSide(width: 1))),
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            child: SizedBox(
              width: 60,
              height: 60,
              child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder:
                      const AssetImage('assets/images/placeHolder2.jpg'),
                  image: NetworkImage(comment.commenterimage)),
            ),
            radius: 30,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '${comment.commentername} ',
                      style: comment.useridd == firbaseAuth11.currentUser!.uid
                          ? const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )
                          : const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                  TextSpan(
                      text: comment.commentText,
                      style: const TextStyle(fontSize: 18))
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Text(
                      tago.format(comment.timedate.toDate()),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('${comment.likes.length.toString()} likes',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 17)),
                  ],
                ),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              UploadController.instance.likecomment(
                  commentownerid: comment.useridd,
                  uid: _userid,
                  videoid: comment.videoid,
                  likes: comment.likes,
                  commentid: comment.commentid);
            },
            icon: comment.likes.contains(_userid)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  )),
      ]),
      // Container(
      //   padding: const EdgeInsets.only(left: 30, top: 10),
      //   alignment: Alignment.centerLeft,
      //   child: Container(
      //     decoration: BoxDecoration(
      //         color: Colors.grey[600],
      //         // border: Border.all(),
      //         borderRadius: BorderRadius.all(Radius.circular(10))),
      //     padding: EdgeInsets.all(8),
      //     child: Text(
      //       comment.commentText,
      //       style: TextStyle(fontSize: 22),
      //     ),
      //   ),
      // ),
    );
  }
}
