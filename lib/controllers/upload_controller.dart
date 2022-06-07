import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/models/usermodel.dart';
import 'package:tiktok_clone/models/vedio_model.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {
  static UploadController instance = Get.find();
  // _compressvideo(String videopath) async {
  //   final compressedwdvideo = await VideoCompress.compressVideo(videopath,
  //       quality: VideoQuality.MediumQuality);

  //   final videofile = compressedwdvideo!.file;

  //   return compressedwdvideo.file;
  // }

  Future<String> uploadvideo(String videoid, String videopath) async {
    // final compressedwdvideo = await VideoCompress.compressVideo(videopath,
    //     quality: VideoQuality.LowQuality);

    final videofile = File(videopath);
    Reference ref = storage.ref().child('videos').child(videoid);
    UploadTask uploadtask = ref.putFile(videofile);
    TaskSnapshot task = await uploadtask;
    String videourl = await task.ref.getDownloadURL();

    return videourl;
  }

  // _getfilethumpnail(String videopath) async {
  //   final thumpnail = await VideoCompress.getFileThumbnail(videopath);
  //   return thumpnail;
  // }

  Future<String> uploadvideothumpnail(String videoid, String videopath) async {
    final thumpnail = await VideoCompress.getFileThumbnail(videopath);

    Reference ref = storage.ref().child('thumpnails').child(videoid);
    UploadTask uploadtask = ref.putFile(thumpnail);
    TaskSnapshot task = await uploadtask;
    String thumpnailurl = await task.ref.getDownloadURL();

    return thumpnailurl;
  }

  uploadveideoinfo(String caption, String song, String videopath) async {
    try {
      String videoid = const Uuid().v1();

      final videourl = await uploadvideo(videoid, videopath);
      final thumpurl = await uploadvideothumpnail(videoid, videopath);
      final usersnap = await firstore
          .collection('users')
          .doc(firbaseAuth11.currentUser!.uid)
          .get();
      UserModel _user = UserModel.fromesnap(usersnap);
      VideoModel model = VideoModel(
          songname: song,
          share: [],
          thumpnailurl: thumpurl,
          description: caption,
          puplishdate: Timestamp.fromDate(DateTime.now()),
          videoUrl: videourl,
          profileimageurl: _user.photo,
          username: _user.username,
          ownerid: _user.userid,
          videoid: videoid,
          likes: [],
          comments: []);
      await firstore.collection('videos').doc(videoid).set(model.tomap());
      await firstore
          .collection('users')
          .doc(firbaseAuth11.currentUser!.uid)
          .update({
        'videos': FieldValue.arrayUnion([videoid])
      });

      Get.back();
      Get.snackbar('done', 'uploaded successfuly');
    } catch (err) {
      Get.back();
      Get.snackbar('An error occerd', err.toString());
    }
  }

  Future<void> likevideo(
      {required String uid,
      required String videoid,
      required String videoOwnerid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        firstore.collection('videos').doc(videoid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        firstore.collection('users').doc(videoOwnerid).update({
          'likes': FieldValue.arrayRemove([uid + videoid])
        });
      } else {
        firstore.collection('videos').doc(videoid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        firstore.collection('users').doc(videoOwnerid).update({
          'likes': FieldValue.arrayUnion([uid + videoid])
        });
      }
    } catch (e) {
      Get.snackbar('An error occerd', e.toString());
    }
  }

  likecomment(
      {required String uid,
      required String videoid,
      required List likes,
      required String commentid,
      required commentownerid}) async {
    try {
      if (likes.contains(uid)) {
        firstore
            .collection('videos')
            .doc(videoid)
            .collection('comments')
            .doc(commentid)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
        firstore.collection('users').doc(commentownerid).update({
          'likes': FieldValue.arrayRemove([uid + videoid])
        });
      } else {
        firstore
            .collection('videos')
            .doc(videoid)
            .collection('comments')
            .doc(commentid)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
        firstore.collection('users').doc(commentownerid).update({
          'likes': FieldValue.arrayUnion([uid + videoid])
        });
      }
    } catch (e) {
      Get.snackbar('An error occerd', e.toString());
    }
  }

  Future<void> commentvideo(Comment comment) async {
    try {
      final ref = firstore.collection('videos').doc(comment.videoid);
      await ref
          .collection('comments')
          .doc(comment.commentid)
          .set(comment.tomap());

      await ref.update({
        'comments': FieldValue.arrayUnion([comment.commentid])
      });
    } catch (err) {
      Get.snackbar('An error occerd', err.toString());
    }
  }

  imageAndVideopicker(
      ImageSource imageee, BuildContext context, bool isvedio) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image;
    if (isvedio) {
      image = await _picker.pickVideo(source: imageee);
    } else {
      image = await _picker.pickImage(source: imageee);
    }

    if (image != null) {
      return image;
    } else {
      Get.snackbar('no file selected ', 'pleas selesct afile');
    }
  }

  Future<File?> showdialogforimagepick(
      {required BuildContext context,
      required Size media,
      required bool isvedio}) async {
    File? image;

    XFile? ggh;

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: const Text('Select image'),
              content: Container(
                padding: const EdgeInsets.only(top: 10),
                width: media.width * .5,
                height: media.height * .2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        ggh = await imageAndVideopicker(
                            ImageSource.gallery, context, isvedio);

                        Navigator.pop(ctx);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Gallary',
                                style: TextStyle(fontSize: 20),
                              ),
                            ]),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        ggh = await imageAndVideopicker(
                            ImageSource.camera, context, isvedio);

                        Navigator.pop(ctx);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(fontSize: 20),
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 161, 95, 172),
                      ),
                    ))
              ],
            ));
    if (ggh == null) {
      return image;
    } else {
      image = File(ggh!.path);
      return image;
    }
  }
}
