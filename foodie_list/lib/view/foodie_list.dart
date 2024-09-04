// 2024_09_04 14:35 main 화면 작성 시작
// ahthor : 하동훈

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodie_list/model/store.dart';
import 'package:foodie_list/view/add_list.dart';
import 'package:foodie_list/view/edit_list.dart';
import 'package:foodie_list/vm/database_handler.dart';
import 'package:get/get.dart';

class FoodieList extends StatefulWidget {
  const FoodieList({super.key});

  @override
  State<FoodieList> createState() => _FoodieListState();
}

class _FoodieListState extends State<FoodieList> {
  late DatabaseHandler handler;
  late Future<List<Store>> storesFuture;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    storesFuture = Future.value([]); // Future 초기값 설정
    _initializeDatabase(); // 그 다음에 데이터베이스 초기화
  }

  void _initializeDatabase() async {
    await handler.initializeDB(); // 데이터베이스 초기화
    setState(() {
      storesFuture = handler.queryStore(); // Future 설정 후 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 경험한 맛집 리스트'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const AddList())!.then((value) => reloadData());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Store>>(
        future: storesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          int? count = snapshot.data![index].seq;
                          await handler.deleteStore(count!);
                          reloadData();
                        },
                        backgroundColor: Colors.red,
                        label: '삭제',
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Get.to(() => const EditList(), arguments: [
                            snapshot.data![index].seq,
                            snapshot.data![index].name,
                            snapshot.data![index].phone,
                            snapshot.data![index].image,
                            snapshot.data![index].latitude,
                            snapshot.data![index].longitude,
                            snapshot.data![index].estimate
                          ])!
                              .then((value) => reloadData());
                        },
                        label: '수정',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    // onTap: () => ,
                    child: Card(
                      elevation: 5,
                      child: Center(
                        child: Row(
                          children: [
                            Image.memory(
                              snapshot.data![index].image,
                              width: 120,
                              height: 100,
                            ),
                            Column(
                              children: [
                                Text(snapshot.data![index].name),
                                Text(snapshot.data![index].phone),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('맛집 리스트를 추가해주세요.'));
          }
        },
      ),
    );
  }

  // --- Functions ---
  reloadData() {
    setState(() {
      storesFuture = handler.queryStore();
    });
  }
}// End
