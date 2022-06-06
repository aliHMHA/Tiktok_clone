import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String useridd;
  String videoid;
  Timestamp timedate;
  String commentText;
  String commenterimage;
  String commentername;
  List likes;
  String commentid;

  Comment(
      {required this.commentText,
      required this.timedate,
      required this.videoid,
      required this.useridd,
      required this.commenterimage,
      required this.commentername,
      required this.likes,
      required this.commentid});

  static Comment fromjson(Map<String, dynamic> json) {
    return Comment(
        useridd: json['userid'],
        timedate: json['timedate'],
        commentText: json['commenttext'],
        videoid: json['videoid'],
        commenterimage: json['commenterimage'],
        commentername: json['commentername'],
        likes: json['likes'],
        commentid: json['commentid']);
  }

  static Comment fromsnap(DocumentSnapshot snap) {
    final json = snap.data() as Map<String, dynamic>;
    return Comment(
        useridd: json['userid'],
        timedate: json['timedate'],
        commentText: json['commenttext'],
        videoid: json['videoid'],
        commenterimage: json['commenterimage'],
        commentername: json['commentername'],
        likes: json['likes'],
        commentid: json['commentid']);
  }

  Map<String, dynamic> tomap() {
    return {
      'userid': useridd,
      'timedate': timedate,
      'commenttext': commentText,
      'videoid': videoid,
      'commenterimage': commenterimage,
      'commentername': commentername,
      'likes': likes,
      'commentid': commentid
    };
  }
}
