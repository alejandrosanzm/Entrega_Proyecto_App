import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class Letter {
  final int id;
  final String writer;
  final String letter;
  final String image;
  final int publicLikes;
  final String date;
  final String profile;

  Letter({
    this.id,
    this.writer,
    this.letter,
    this.image,
    this.publicLikes,
    this.date,
    this.profile,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'],
      writer: json['writer'],
      letter: json['letter'],
      image: json['image'],
      publicLikes: json['public_likes'],
      date: json['date'],
      profile: json['profile'],
    );
  }

  Map toJson() => {
        'id': id,
        'writer': writer,
        'letter': letter,
        'image': image,
        'public_likes': publicLikes,
        'date': date,
        'profile': profile,
      };
}
