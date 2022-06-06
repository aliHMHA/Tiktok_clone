import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/controllers/upload_controller.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/models/usermodel.dart';
import 'package:tiktok_clone/models/vedio_model.dart';
import 'package:tiktok_clone/views/widgets/commentswindow.dart';
import 'package:uuid/uuid.dart';

class CommentsScreen extends StatefulWidget {
  final bool isPush;

  const CommentsScreen({Key? key, required this.isPush}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _ConnebtsScreenState();
}

class _ConnebtsScreenState extends State<CommentsScreen> {
  @override
  void initState() {
    super.initState();
    getuser();
    commentStream();
  }

  @override
  void dispose() {
    super.dispose();
    commentcontoller.dispose();
    _commenttstream.cancel();
  }

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _commenttstream;

  commentStream() {
    if (video == null) {
      return;
    }
    _commentList.clear();
    _commenttstream = FirebaseFirestore.instance
        .collection('videos')
        .doc(video.videoid)
        .collection('comments')
        .orderBy('timedate', descending: true)
        .snapshots()
        .listen((event) {
      _commentList = [];
      for (var element in event.docs) {
        _commentList.add(Comment.fromjson(element.data()));
      }
      setState(() {});
    });
  }

  getuser() async {
    final snap = await firstore
        .collection('users')
        .doc(firbaseAuth11.currentUser!.uid)
        .get();

    setState(() {
      _isloadinguser = false;
      _user = UserModel.fromesnap(snap);
    });
  }

  VideoModel video = VideoController.instance.vedio;

  bool novideoloaded = VideoController.instance.vedio == null;

  List<Comment> _commentList = [];
  final TextEditingController commentcontoller = TextEditingController();
  late UserModel _user;
  bool _isloadinguser = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: widget.isPush
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text('Comments'))
            : null,
        body: _isloadinguser
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Container(
                child: novideoloaded
                    ? Center(
                        child: Text('there is no loaded video '),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: media.size.height * .9,
                              width: double.infinity,
                              color: backgroundColor,
                              child: Column(
                                children: [
                                  // _commentList.length == 0
                                  //     ?
                                  //      Expanded(
                                  //         child: Center(
                                  //             child: Text(
                                  //         'No comments , be the first',
                                  //         style: TextStyle(fontSize: 20),
                                  //       )))
                                  //     :
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: _commentList.length,
                                        itemBuilder: (ctx, ind) =>
                                            CommentsWindow(
                                                comment: _commentList[ind])),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Container(
                              width: double.infinity,
                              height: media.size.height * .1,
                              decoration: const BoxDecoration(
                                  color: backgroundColor,
                                  border: Border(
                                      top: BorderSide(
                                          width: 1, color: Colors.white))),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(_user.photo)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                      width: media.size.width * .55,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null) {
                                            return 'pleas write some thing first ';
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: commentcontoller,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'write a comment...'),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        if (commentcontoller.text.isEmpty ||
                                            commentcontoller.text == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      ' pleas enter acomment first')));
                                        } else {
                                          // setState(() {
                                          //   _isloaging = true;
                                          // });
                                          final commentid = const Uuid().v1();
                                          await UploadController.instance
                                              .commentvideo(Comment(
                                                  likes: [],
                                                  commentid: commentid,
                                                  commentText:
                                                      commentcontoller.text,
                                                  timedate: Timestamp.fromDate(
                                                      DateTime.now()),
                                                  videoid: video.videoid,
                                                  useridd: _user.userid,
                                                  commenterimage: _user.photo,
                                                  commentername:
                                                      _user.username));
                                          commentcontoller.text = '';
                                        }
                                        commentcontoller.clear();
                                        // setState(() {
                                        //   _isloaging = false;
                                        // });
                                      },
                                      child:
                                          // _isloaging? CircularProgressIndicator():
                                          const Text('Comment')),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ));
  }
}



//  Container(
//           height: media.size.height * .9,
//           width: double.infinity,
//           color: mobileBackgroundColor,
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                     itemCount: commentprov.getcomments.length,
//                     itemBuilder: (ctx, ind) =>
//                         CommentsWindow(comment: commentprov.getcomments[ind])),
//               ),
//             ],
//           ),
//         )



// ssss



// StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.videoid)
//             .collection('comments')
//             .orderBy('timedate')
//             .snapshots(),
//         builder:
//             (cont, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             print(widget.videoid);
//             return Container(
//               height: media.height * .8,
//               width: double.infinity,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                         itemCount: snap.data.docs.length,
//                         itemBuilder: (ctx, ind) => CommentsWindow(
//                             comment: Comment.fromsnap(snap.data.docs[ind]))),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.symmetric(),
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         border: Border(
//                             top: BorderSide(
//                                 width: 1,
//                                 color: Color.fromARGB(255, 168, 238, 98)))),
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         Consumer<Authprovider>(
//                           builder: (ctx, value, ch) => CircleAvatar(
//                               radius: 20,
//                               backgroundImage:
//                                   NetworkImage(value.getdattttta.imageURL)),
//                         ),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Container(
//                             width: media.width * .55,
//                             child: TextFormField(
//                               validator: (value) {
//                                 if (value.length == 0) {
//                                   return 'pleas write some thing first ';
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                               controller: commentcontoller,
//                               decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'write a comment...'),
//                             )),
//                         TextButton(
//                             onPressed: () async {
//                               if (commentcontoller.text.length == 0 ||
//                                   commentcontoller.text == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content: Text(
//                                             ' pleas enter acomment first')));
//                               } else {
//                                 // setState(() {
//                                 //   _isloaging = true;
//                                 // });
//                                 final commentid = Uuid().v1();
//                                 await postprovidr.commentpost(Comment(
//                                     commentid: commentid,
//                                     commentText: commentcontoller.text,
//                                     timedate:
//                                         Timestamp.fromDate(DateTime.now()),
//                                     videoid: widget.videoid,
//                                     useridd: auth.getdattttta.uid,
//                                     commenterimage: auth.getdattttta.imageURL,
//                                     commentername: auth.getdattttta.name));
//                               }
//                               // setState(() {
//                               //   _isloaging = false;
//                               // });
//                             },
//                             child:
//                                 // _isloaging? CircularProgressIndicator():
//                                 Text('Comment')),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         });





// HashChangeEvent
// return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.videoid)
//             .collection('comments')
//             .orderBy('timedate')
//             .snapshots(),
//         builder:
//             (cont, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: CircularProgressIndicator(
//               color: primaryColor,
//             ));
//           } else {
//             return Container(
//               height: media.height * .8,
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       child: ListView.builder(
//                           itemCount: snap.data!.docs.length,
//                           itemBuilder: (ctx, ind) => CommentsWindow(
//                               comment: Comment.fromsnap(snap.data!.docs[ind]))),
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.symmetric(),
//                     decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         border: const Border(
//                             top: BorderSide(
//                                 width: 1,
//                                 color: Color.fromARGB(255, 168, 238, 98)))),
//                     padding: const EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         Consumer<UserProvider>(
//                           builder: (ctx, value, ch) => CircleAvatar(
//                               radius: 20,
//                               backgroundImage:
//                                   NetworkImage(value.getuserinfo.photo)),
//                         ),
//                         const SizedBox(
//                           width: 15,
//                         ),
//                         Container(
//                             width: media.width * .55,
//                             child: TextFormField(
//                               controller: commentcontoller,
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: 'write a comment...'),
//                             )),
//                         TextButton(
//                             onPressed: () async {
//                               if (commentcontoller.text.isEmpty ||
//                                   commentcontoller.text == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             ' pleas enter acomment first')));
//                               } else {
//                                 // setState(() {
//                                 //   _isloaging = true;
//                                 // });
//                                 final commentid = const Uuid().v1();
//                                 await StorageMethods().commentpost(Comment(
//                                     commentid: commentid,
//                                     commentText: commentcontoller.text,
//                                     timedate:
//                                         Timestamp.fromDate(DateTime.now()),
//                                     videoid: widget.videoid,
//                                     useridd: userprov.getuserinfo.userid,
//                                     commenterimage: userprov.getuserinfo.photo,
//                                     commentername:
//                                         userprov.getuserinfo.username));
//                               }
//                               // setState(() {
//                               //   _isloaging = false;
//                               // });
//                             },
//                             child:
//                                 // _isloaging? CircularProgressIndicator():
//                                 const Text('Comment')),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         });