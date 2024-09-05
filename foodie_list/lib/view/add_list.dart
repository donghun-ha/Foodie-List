import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodie_list/model/store.dart';
import 'package:foodie_list/vm/database_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  // Property
  late DatabaseHandler handler;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController estimateController;
  double? latData; // 위도 데이터
  double? longData; // 경도 데이터
  Position? currentPosition; // nullable로 선언
  bool canRun = false;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    estimateController = TextEditingController();
    getCurrentLocation(); // 초기 위치 가져오기
  }

  Future<void> getCurrentLocation() async {
    // 초기 위치: 학원 위치 설정 (예: 37.4973294, 127.0293198)
    try {
      Position position = await Geolocator.getCurrentPosition();
      currentPosition = position;
      canRun = true;
      latData = currentPosition?.latitude ?? 37.4973294;
      longData = currentPosition?.longitude ?? 127.0293198;

      // TextController에 초기 위치 설정
      latitudeController.text = latData.toString();
      longitudeController.text = longData.toString();

      setState(() {});
    } catch (e) {
      latData = 37.4973294; // 예시 학원 위치
      longData = 127.0293198;
      latitudeController.text = latData.toString();
      longitudeController.text = longData.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Restaurant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/back.png'),
            fit: BoxFit.cover,
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/back.png',
                fit: BoxFit.cover, // 이미지를 전체 영역에 맞게 조정
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        getImageFromGallery(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFD4D05),
                        foregroundColor: Colors.white,
                        fixedSize: const Size(150, 0),
                      ),
                      child: const Text(
                        'Image',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 200,
                    child: Center(
                      child: imageFile == null
                          ? const Text('Please select an image.')
                          : Image.file(File(imageFile!.path)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Location :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 135,
                            child: TextField(
                              controller: latitudeController,
                              decoration: InputDecoration(
                                hintText:
                                    '위도: ${latData ?? '위도 정보를 가져올 수 없습니다.'}',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 135,
                            child: TextField(
                              controller: longitudeController,
                              decoration: InputDecoration(
                                hintText:
                                    '경도: ${longData ?? '경도 정보를 가져올 수 없습니다.'}',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Name : ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: '맛집 이름을 입력해주세요.',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Phone : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 296,
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '맛집 전화번호를 입력해주세요.',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  14), // 최대 12글자로 제한
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          ' Rating : ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 290,
                          child: TextField(
                            controller: estimateController,
                            decoration: const InputDecoration(
                              hintText: '맛집 평가를 해주세요.',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 70),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: ElevatedButton(
                      onPressed: () {
                        insertList();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 0),
                        backgroundColor: const Color(0xffFBB816),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- functions ---
  Future getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickerFile = await picker.pickImage(source: imageSource);
    if (pickerFile == null) {
      return;
    } else {
      imageFile = XFile(pickerFile.path);
      setState(() {});
    }
  }

  Future insertList() async {
    if (imageFile == null) {
      print("이미지를 선택해주세요.");
      return;
    }
    // File Type을 byte Type으로 변환하기
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var addFoodieList = Store(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      image: getImage,
      latitude:
          double.tryParse(latitudeController.text.trim()) ?? latData ?? 0.0,
      longitude:
          double.tryParse(longitudeController.text.trim()) ?? longData ?? 0.0,
      estimate: estimateController.text.trim(),
    );
    int result = await handler.insertStore(addFoodieList);
    if (result != 0) {
      _showDialog();
    }
  }

  void _showDialog() {
    Get.defaultDialog(
      title: '입력 결과',
      middleText: '입력이 완료되었습니다.',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
    setState(() {});
  }
}
