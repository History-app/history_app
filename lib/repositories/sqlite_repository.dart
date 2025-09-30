import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';

class SQLiteRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  static Database? _db;

  SQLiteRepository() {
    initState();
  }

  void initState() {}

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final prefs = await SharedPreferences.getInstance();
    final int savedDbVersion = prefs.getInt('db_version') ?? 0;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "jap_his.db");
    const int currentDbVersion = 7;
    // バージョンが違うなら既存DB削除
    if (savedDbVersion != currentDbVersion) {
      final exists = await databaseExists(path);
      if (exists) {
        await deleteDatabase(path);
      }
    }

    final existsAfter = await databaseExists(path);
    if (!existsAfter) {
      try {
        ByteData data = await rootBundle.load("assets/db/jap_his.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);

        // バージョン保存
        await prefs.setInt('db_version', currentDbVersion);
      } catch (e) {
        rethrow;
      }
    }

    _db = await openDatabase(path, readOnly: true);
    return _db!;
  }

  Future<List<Map<String, dynamic>>> getNotesByNoteRef(String noteRef) async {
    try {
      final db = await SQLiteRepository.database;

      final String ref = noteRef.trim();

      // 大文字小文字を区別したくない場合は COLLATE NOCASE を付ける
      final rows = await db.rawQuery(
        'SELECT * FROM notes WHERE id = ? COLLATE NOCASE',
        [ref],
      );

      if (rows.isEmpty) {
        print('ℹ️  該当 id $ref は存在しません');
        return [];
      }

      final notes = rows.map((row) {
        final note = Map<String, dynamic>.from(row);

        // ----- flds を JSON → List に ---------------------------------
        final fldsRaw = note['flds'];
        if (fldsRaw != null) {
          try {
            if (fldsRaw is String) {
              note['flds'] = jsonDecode(fldsRaw);
            } else if (fldsRaw is Uint8List) {
              note['flds'] = jsonDecode(utf8.decode(fldsRaw));
            }
          } catch (e) {
            print('⚠️  flds のデコード失敗: $e');
          }
        }
        return note;
      }).toList();

      return notes;
    } catch (e) {
      return [];
    }
  }
}

final sqliteRepositoryProvider = Provider<SQLiteRepository>((ref) {
  return SQLiteRepository();
});
