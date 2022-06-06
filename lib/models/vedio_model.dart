import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String description;
  final String ownerid;
  final String songname;
  final Timestamp puplishdate;
  final String username;
  final String videoid;
  final String videoUrl;
  final String thumpnailurl;
  final String profileimageurl;
  final List likes;
  final List share;
  final List comments;

  VideoModel(
      {required this.description,
      required this.puplishdate,
      required this.videoUrl,
      required this.thumpnailurl,
      required this.profileimageurl,
      required this.username,
      required this.ownerid,
      required this.songname,
      required this.videoid,
      required this.likes,
      required this.share,
      required this.comments});

  static VideoModel fromjson(Map<String, dynamic> json) {
    return VideoModel(
        description: json['description'],
        puplishdate: json['puplishdate'],
        videoUrl: json['videoUrl'],
        thumpnailurl: json['thumpnailurl'],
        username: json['username'],
        profileimageurl: json['profileimageurl'],
        ownerid: json['ownerid'],
        songname: json['songname'],
        videoid: json['videoid'],
        likes: json['likes'],
        share: json['share'],
        comments: json['comments']);
  }

  static VideoModel fromesnap(DocumentSnapshot snap) {
    var datta = snap.data() as Map<String, dynamic>;

    return VideoModel(
        description: datta['description'],
        puplishdate: datta['puplishdate'],
        videoUrl: datta['videoUrl'],
        thumpnailurl: datta['thumpnailurl'],
        profileimageurl: datta['profileimageurl'],
        username: datta['username'],
        ownerid: datta['ownerid'],
        songname: datta['songname'],
        videoid: datta['videoid'],
        likes: datta['likes'],
        share: datta['share'],
        comments: datta['comments']);
  }

  Map<String, dynamic> tomap() {
    return {
      'description': description,
      'ownerid': ownerid,
      'songname': songname,
      'puplishdate': puplishdate,
      'videoid': videoid,
      'username': username,
      'videoUrl': videoUrl,
      'thumpnailurl': thumpnailurl,
      'profileimageurl': profileimageurl,
      'likes': likes,
      'share': share,
      'comments': comments
    };
  }
}
