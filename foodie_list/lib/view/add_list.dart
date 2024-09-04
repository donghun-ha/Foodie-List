// 2024_09_04 15:30 추가 List page 작성
// athor: 하동훈

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foodie_list/model/store.dart';
import 'package:foodie_list/vm/database_handler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  // Property
  late DatabaseHandler handelr;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController estimateController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handelr = DatabaseHandler();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    estimateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 추가'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getImageFromGallery(ImageSource.gallery);
              },
              child: const Text('Image'),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.grey,
              child: Center(
                child: imageFile == null
                    ? const Text('이미지를 선택해 주십시오.')
                    : Image.file(File(imageFile!.path)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('위치 :'),
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: latitudeController,
                      decoration: const InputDecoration(
                        hintText: '위도',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: longitudeController,
                      decoration: const InputDecoration(
                        hintText: '경도',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: '맛집 이름을 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: '맛집 전화번호를 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 350,
              child: TextField(
                controller: estimateController,
                decoration: const InputDecoration(
                  hintText: '맛집 평가를 해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 70),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                insertList();
              },
              child: const Text('입력'),
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
        // seq : 자동생성 됨
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        image: getImage,
        latitude: double.parse(latitudeController.text.trim()),
        longitude: double.parse(longitudeController.text.trim()),
        estimate: estimateController.text.trim());
    int result = await handelr.insertStore(addFoodieList);
    if (result != 0) {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
        title: '입력 결과',
        middleText: '입력이 완료되었습니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          ),
        ]);
    setState(() {});
  }
}// End
