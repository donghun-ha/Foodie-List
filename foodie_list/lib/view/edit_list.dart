import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foodie_list/model/store.dart';
import 'package:foodie_list/vm/database_handler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditList extends StatefulWidget {
  const EditList({super.key});

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  // Property
  late DatabaseHandler handelr;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;
  late Future<List<Store>> storesFuture;
  var inputValue = Get.arguments ?? "___";

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handelr = DatabaseHandler();
    nameController = TextEditingController(text: inputValue[1] ?? '');
    phoneController = TextEditingController(text: inputValue[2] ?? '');
    estimateController = TextEditingController(text: inputValue[6] ?? '');
    storesFuture = Future.value([]);
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    // await handler.initializeDB(); // 데이터베이스 초기화
    setState(() {
      storesFuture = handelr.queryStore(); // Future 설정 후 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 수정'),
      ),
      body: FutureBuilder<List<Store>>(
        future: storesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              ? inputValue[3] != null
                                  ? Image.memory(inputValue[3])
                                  : const Text('이미지를 선택해 주십시오.')
                              : Image.file(File(imageFile!.path)),
                        ),
                      ),
                      Text('위도 : ${inputValue[4]}'),
                      Text('경도 : ${inputValue[5]}'),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: TextField(
                          controller: estimateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 70),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => updateList(),
                        child: const Text('수정'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
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

  Future updateList() async {
    if (imageFile == null) {
      return;
    }
    // File Type을 byte Type으로 변환하기
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var editFoodieList = Store(
      seq: inputValue[0],
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      image: getImage,
      latitude: double.parse(inputValue[4].toString()),
      longitude: double.parse(inputValue[5].toString()),
      estimate: estimateController.text.trim(),
    );

    int result = await handelr.updateStore(editFoodieList);
    if (result != 0) {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
        title: '수정 결과',
        middleText: '수정이 완료되었습니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('OK'),
          ),
        ]);
    setState(() {});
  }
}// End
