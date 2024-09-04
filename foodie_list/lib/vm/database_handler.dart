// 2024_09_04 14:24 작업 시작
// Foodie List DB handler 작성
// ahthor : 하동훈

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:foodie_list/model/store.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'foodie.db'),
      onCreate: (db, version) async {
        await db.execute("""
            CREATE TABLE store (
              seq INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              phone TEXT,
              estimate TEXT,
              latitude REAL,
              longitude REAL,
              image BLOB
            );
          """);
      },
      version: 1,
    );
  }

// queryStore store list 불러오기
  Future<List<Store>> queryStore() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM store');
    return queryResult.map((e) => Store.fromMap(e)).toList();
  }

// insertStore store list 작성
  Future<int> insertStore(Store store) async {
    final Database db = await initializeDB();
    return await db.rawInsert("""
INSERT INTO store (seq, name, phone, estimate, latitude, longitude, image)
VALUES (?, ?, ?, ?, ?, ?, ?)
""", [
      store.seq,
      store.name,
      store.phone,
      store.estimate,
      store.latitude,
      store.longitude,
      store.image,
    ]);
  }

  // updateStore store list 수정
  Future<int> updateStore(Store store) async {
    final Database db = await initializeDB();

    final int result = await db.rawUpdate(
      """
        update store set name = ?, phone = ?, estimate = ?, image =? where seq = ?
      """,
      [store.seq, store.name, store.phone, store.estimate, store.image],
    );
    return result;
  }

  // deleteStore: Slidable을 이용한 리스트 삭제
  Future<int> deleteStore(int seq) async {
    final Database db = await initializeDB();
    return await db.rawDelete("""
        DELETE FROM store WHERE seq = ?
      """, [seq]);
  }
}// Done
