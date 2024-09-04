// 2024_09_04 14:40
// store model 작성
// author: 하동훈

import 'dart:typed_data';

class Store {
  int? seq;
  String name;
  String phone;
  Uint8List image;
  double? latitude;
  double? longitude;
  String estimate;

  Store(
      {this.seq,
      required this.name,
      required this.phone,
      required this.image,
      this.latitude,
      this.longitude,
      required this.estimate});

  Store.fromMap(Map<String, dynamic> res)
      : seq = res['seq'],
        name = res['name'],
        phone = res['phone'],
        image = res['image'],
        latitude = res['latitude'],
        longitude = res['longitude'],
        estimate = res['estimate'];
}
