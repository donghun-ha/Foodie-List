import 'package:flutter/material.dart';
import 'package:foodie_list/view/foodie_list.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // 3초 후에 메인 화면으로 이동
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.to(const FoodieList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/back.png',
              fit: BoxFit.cover, // 이미지를 전체 영역에 맞게 조정
            ),
          ),
          Center(
            child: Image.asset(
              'images/logo.png',
            ),
          ),
        ],
      ),
    );
  }
}
