// To parse this JSON data, do
//
//     final picsumImage = picsumImageFromJson(jsonString);

import 'dart:convert';

List<PicsumImage> picsumImageFromJson(String str) => List<PicsumImage>.from(
    json.decode(str).map((x) => PicsumImage.fromJson(x)));

String picsumImageToJson(List<PicsumImage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PicsumPayload {
  List<PicsumImage> picsumImages;

  PicsumPayload(this.picsumImages);
}

class PicsumImage {
  String id;
  String author;
  int width;
  int height;
  String url;
  String downloadUrl;

  PicsumImage({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory PicsumImage.fromJson(Map<String, dynamic> json) => PicsumImage(
        id: json["id"],
        author: json["author"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        downloadUrl: json["download_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "width": width,
        "height": height,
        "url": url,
        "download_url": downloadUrl,
      };
}
