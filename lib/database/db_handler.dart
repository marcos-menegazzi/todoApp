import 'package:myapp/models/user_model.dart';
import 'package:myapp/models/todo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if(_db != null) {
      return _db;
    }

    _db = await initDatabase();

    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async{
    await db.execute(
        "CREATE TABLE "
            "todo("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title TEXT NOT NULL,"
              "description TEXT NOT NULL"
            ")"
    );

    await db.execute("CREATE TABLE "
        "user("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "email TEXT NOT NULL,"
        "auth_token TEXT NOT NULL,"
        "name TEXT NOT NULL"
        ")"
    );
  }

  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert('todo', todoModel.toMap());

    return todoModel;
  }

  Future<List<TodoModel>> getAll() async {
    await db;
    final List<Map<String, Object?>> queryResult = await _db!.query('todo');
    return queryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> update(TodoModel todoModel) async {
    var dbClient = await db;
    return await dbClient!.update('todo', todoModel.toMap(), where: 'id = ? ', whereArgs: [todoModel.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('todo', where: 'id = ?', whereArgs: [ id ]);
  }
  
  Future<UserModel> getUser() async {
    await db;

    final List<Map<String, Object?>> queryResult = await _db!.query('user');
    final List<UserModel> userList = queryResult.map((e) => UserModel.fromMap(e)).toList();

    print(queryResult);

    if(userList.isEmpty) {
      return UserModel();
    }

    return userList.first;
  }

  Future<UserModel> login(UserModel user) async {
    var dbClient = await db;
    await dbClient?.insert('user', user.toMap());

    return user;
  }
}