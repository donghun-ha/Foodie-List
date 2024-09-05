import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodie_list/model/store.dart';
import 'package:foodie_list/view/add_list.dart';
import 'package:foodie_list/view/edit_list.dart';
import 'package:foodie_list/view/detail.dart'; // DetailPage 추가
import 'package:foodie_list/vm/database_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class FoodieList extends StatefulWidget {
  const FoodieList({super.key});

  @override
  State<FoodieList> createState() => _FoodieListState();
}

class _FoodieListState extends State<FoodieList> {
  late DatabaseHandler handler;
  late Future<List<Store>> storesFuture;
  final TextEditingController _searchController = TextEditingController();
  Position? currentPosition; // 현재 위치 저장을 위한 변수

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    storesFuture = Future.value([]); // Future 초기값 설정
    _initializeDatabase(); // 그 다음에 데이터베이스 초기화
  }

  void _initializeDatabase() async {
    await handler.initializeDB(); // 데이터베이스 초기화
    reloadData();
  }

  void _searchStores(String query) {
    setState(() {
      storesFuture = handler.searchStore(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Foodie List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffFBB816),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const AddList())!.then((value) => reloadData());
            },
            icon: const Icon(
              Icons.add,
              color: Color(0xffFF3D00),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/back.png'),
            fit: BoxFit.cover,
          )),
        ),
        automaticallyImplyLeading: false, // 뒤로가기 화살표 제거
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchStores,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(borderSide: BorderSide()),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color(0xffFBB816)), // 포커스 시 테두리 색깔 설정
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color(0xffFBB816)), // 활성화 시 테두리 색깔 설정
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Stack(
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
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    int? count = snapshot.data![index].seq;
                                    await handler.deleteStore(count!);
                                    reloadData();
                                  },
                                  backgroundColor: Colors.red,
                                  label: 'Delete',
                                  icon: Icons.delete_forever_outlined,
                                  spacing: 10,
                                ),
                              ],
                            ),
                            startActionPane: ActionPane(
                              extentRatio: 0.3,
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
                                  label: 'Edit',
                                  icon: Icons.edit_document,
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                        Detail(store: snapshot.data![index]))!
                                    .then((value) => reloadData());
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: Column(
                                  children: [
                                    Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            child: Image.memory(
                                              snapshot.data![index].image,
                                              width: 220,
                                              height: 160,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
              ],
            ),
          ),
        ],
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