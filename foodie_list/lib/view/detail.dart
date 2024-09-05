import 'package:flutter/material.dart';
import 'package:foodie_list/model/store.dart';
import 'package:foodie_list/view/geolocate.dart';
import 'package:get/get.dart';

class Detail extends StatelessWidget {
  final Store store;

  const Detail({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          store.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ), // 가게명으로 앱바 제목 설정
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/back.png',
              fit: BoxFit.cover, // 이미지를 전체 영역에 맞게 조정
            ),
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.33,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(store.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3, // 카드 높이 설정
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${store.phone}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estimate: ${store.estimate}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(
                              Icons.location_on,
                            ),
                            onPressed: () {
                              Get.to(() => const Geolocate(), arguments: [
                                store.latitude,
                                store.longitude,
                              ]);
                            },
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.red,
                              iconSize: 40,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
