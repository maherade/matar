import 'package:mattar/module/weather%20model.dart';

/// id : 835
/// title : "تحديثات النماذج العددية"
/// date : "2023-04-12 05:32:00"
/// country : "لبنان"
/// details : "توقعات الامطار لليوم الاربعاء من النموذج الالماني"
/// schedule : ""
/// hide : ""
/// likes : 0
/// shares : 0
/// files : [{"id":1032,"outlook_id":"835","file":"64360a586da7b.jpg"}]
/// comments : []

class SpecialModel {
  SpecialModel({
    this.id,
    this.title,
    this.date,
    this.country,
    this.details,
    this.schedule,
    this.hide,
    this.likes,
    this.shares,
    this.files,
    this.comments,
  });

  SpecialModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    country = json['country'];
    details = json['details'];
    schedule = json['schedule'];
    hide = json['hide'];
    likes = json['likes'];
    shares = json['shares'];
    if (json['files'] != null) {
      files = [];
      json['files'].forEach((v) {
        files?.add(Files.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comments.fromJson(v));
      });
    }
  }

  int? id;
  String? title;
  String? date;
  String? country;
  String? details;
  String? schedule;
  String? hide;
  int? likes;
  int? shares;
  List<Files>? files;
  List<dynamic>? comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['date'] = date;
    map['country'] = country;
    map['details'] = details;
    map['schedule'] = schedule;
    map['hide'] = hide;
    map['likes'] = likes;
    map['shares'] = shares;
    if (files != null) {
      map['files'] = files?.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1032
/// outlook_id : "835"
/// file : "64360a586da7b.jpg"

class Files {
  Files({
    this.id,
    this.outlookId,
    this.file,
  });

  Files.fromJson(dynamic json) {
    id = json['id'];
    outlookId = json['outlook_id'];
    file = json['file'];
  }

  int? id;
  String? outlookId;
  String? file;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['outlook_id'] = outlookId;
    map['file'] = file;
    return map;
  }
}
