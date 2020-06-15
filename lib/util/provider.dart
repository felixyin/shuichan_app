import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//const createSql = {
//  'cat': """
//      CREATE TABLE "cat" (
//      `id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
//      `name`	TEXT NOT NULL UNIQUE,
//      `depth`	INTEGER NOT NULL DEFAULT 1,
//      `parentId`	INTEGER NOT NULL,
//      `desc`	TEXT
//    );
//  """,
//  'collectio': """
//    CREATE TABLE collection (id INTEGER PRIMARY KEY NOT NULL UNIQUE, name TEXT NOT NULL, router TEXT);
//  """,
//  'widget': """
//    CREATE TABLE widget (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, name TEXT NOT NULL, cnName TEXT NOT NULL, image TEXT NOT NULL, doc TEXT, demo TEXT, catId INTEGER NOT NULL REFERENCES cat (id), owner TEXT);
//  """;
//};

/// 必读和警告：
/// 严重提示，如果发现数据存储错误，请检查assets目录下的app.db
/// app会以此作为模板，请确认里面的表和数据类型是否正确。
///
class Provider {
  static Database db;

  // 请在用工具打开assets/app.db，确认如下表是否存在。
  // 如果需要新建表，请在数组添加后在app.db中新建表并设置好字段数据类型即可。
  List<String> expectTables = ['userInfo', 'setting'];

  // 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {
    List<String> tables = await getTables();

    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  //初始化数据库

  Future init(bool isCreate) async {
    //Get a location using getDatabasesPath
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'flutter.db');
    log('sqlite db path -------------------------> \n' + path);
    try {
      db = await openDatabase(path);
    } catch (e) {
      log("Error $e");
    }
    bool tableIsRight = await this.checkTableIsRight();

    if (!tableIsRight) {
      // 关闭上面打开的db，否则无法执行open
      db.close();
      // Delete the database
      await deleteDatabase(path);
      ByteData data = await rootBundle.load(join("assets", "app.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        log('db created version is $version');
      }, onOpen: (Database db) async {
        log('new db opened');
      });
    } else {
      log("Opening existing database");
    }
  }
}
