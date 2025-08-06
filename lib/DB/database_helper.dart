import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/Books/books1.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // データベースインスタンスの取得
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // データベース初期化
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'history_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // テーブル作成 - notesフィールドを追加
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books1 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        theme TEXT NOT NULL,
        star INTEGER NOT NULL,
        hnref INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        notes TEXT NOT NULL
      )
    ''');
  }

  // Books1の追加 - notesフィールドを追加
  Future<int> insertBook(Books1 book) async {
    final Database db = await database;
    return await db.insert(
      'books1',
      {
        'theme': book.theme,
        'star': book.star,
        'hnref': book.hnref,
        'question': book.question,
        'answer': book.answer,
        'notes': book.notes, // notesフィールドを追加
      },
    );
  }

  // 全てのBooks1を取得 - notesフィールドを含める
  Future<List<Books1>> getBooks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books1');

    return List.generate(maps.length, (i) {
      return Books1(
        id: maps[i]['id'],

        theme: maps[i]['theme'],
        star: maps[i]['star'],
        hnref: maps[i]['hnref'],
        question: maps[i]['question'],
        answer: maps[i]['answer'],
        notes: maps[i]['notes'], // notesフィールドを取得
      );
    });
  }

  // IDによる単一のBooks1取得
  Future<Books1?> getBook(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books1',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Books1(
      id: maps.first['id'],
      theme: maps.first['theme'],
      star: maps.first['star'],
      hnref: maps.first['hnref'],
      question: maps.first['question'],
      answer: maps.first['answer'],
      notes: maps.first['notes'], // notesフィールドを取得
    );
  }

  // Books1を更新 - notesフィールドを含める
  Future<int> updateBook(Books1 book) async {
    final db = await database;
    return await db.update(
      'books1',
      {
        'theme': book.theme,
        'star': book.star,
        'hnref': book.hnref,
        'question': book.question,
        'answer': book.answer,
        'notes': book.notes, // notesフィールドを更新
      },
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // Books1を削除
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books1',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // テーマでBooks1を検索
  Future<List<Books1>> searchBooksByTheme(String theme) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books1',
      where: 'theme LIKE ?',
      whereArgs: ['%$theme%'],
    );

    return List.generate(maps.length, (i) {
      return Books1(
        id: maps[i]['id'],
        theme: maps[i]['theme'],
        star: maps[i]['star'],
        hnref: maps[i]['hnref'],
        question: maps[i]['question'],
        answer: maps[i]['answer'],
        notes: maps[i]['notes'],
      );
    });
  }
}
