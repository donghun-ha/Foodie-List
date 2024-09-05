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
    setState(() {
      storesFuture = handelr.queryStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
          FutureBuilder<List<Store>>(
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                getImageFromGallery(ImageSource.gallery);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFD4D05),
                                foregroundColor: Colors.white,
                                fixedSize: const Size(150, 0),
                              ),
                              child: const Text('Image'),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 200,
                            child: Center(
                              child: imageFile == null
                                  ? inputValue[3] != null
                                      ? Image.memory(inputValue[3])
                                      : const Text('Please select an image')
                                  : Image.file(File(imageFile!.path)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '위도 : ${inputValue[4]}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '경도 : ${inputValue[5]}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                              onPressed: () => updateList(),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 0),
                                backgroundColor: const Color(0xffFBB816),
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // --- functions ---
  Future getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickerFile = await picker.pickImage(source: imageSource);
    if (pickerFile != null) {
      setState(() {
        imageFile = XFile(pickerFile.path);
      });
    }
  }

  Future updateList() async {
    Uint8List getImage;
    if (imageFile != null) {
      File imageFile1 = File(imageFile!.path);
      getImage = await imageFile1.readAsBytes();
    } else {
      getImage = inputValue[3];
    }

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
    } else {
      // 수정 실패 시 처리
      Get.snackbar('오류', '수정에 실패했습니다.');
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
              Get.back();
              // 수정 완료 후 화면 새로고침
              setState(() {
                _initializeDatabase();
              });
            },
            child: const Text('OK'),
          ),
        ]);
  }
}
