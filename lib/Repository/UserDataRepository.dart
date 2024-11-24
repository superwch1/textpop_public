import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDataRepository {

  String DatabasePath;
  UserDataRepository._(this.DatabasePath);  

  static Future<UserDataRepository> CreateInstance() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Textpop.db');
    return UserDataRepository._(path);
  }


  ///Check if table exists, if not then create a table
  static Future<void> CreateTableWhenNotExist() async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();
    bool databaseExist = await databaseExists(repository.DatabasePath);

    Database db = await openDatabase(repository.DatabasePath, version: 1);
    final List<Map<String, dynamic>> tables = await db.query('sqlite_master', where: 'name = ?', whereArgs: ["UserData"]);
    bool tableExist = tables.isNotEmpty;

    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    var locale = Platform.localeName;

    String mode = brightness == Brightness.dark ? "Dark" : "Light";
    String language = locale.contains("zh_Hant") ? "Chinese" : "English";

    if (!databaseExist || !tableExist) {
      await db.execute(
        '''
        CREATE TABLE "UserData" (
          "Id"	INTEGER,
          "AppToken"	TEXT,
          "Mode" TEXT,
          "Language" TEXT,
          PRIMARY KEY("Id" AUTOINCREMENT)
        )
        '''
      );

      String query = 
        '''
          INSERT INTO 
            UserData(AppToken, Mode, Language)
          VALUES
            (?, ?, ?)
        ''';

      await db.execute(query, ["", mode, language]);
    }
  }


  ///Update the record of apptoken
  static Future<void> UpdateAppToken(String appToken) async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      UPDATE
        UserData
      SET
        AppToken = ?
      WHERE
        Id = 1
      ''';

    await db.execute(query, [appToken]);
    await db.close();
  }

  ///Read the record of apptoken
  static Future<String?> ReadAppToken() async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();
    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      SELECT
        AppToken
      FROM
        UserData
      WHERE
        Id = 1
      ''';

    List<Map<String, dynamic>> record = await db.rawQuery(query);
    await db.close();

    if (record.isNotEmpty){
      return record.first["AppToken"];
    }
    return null;
  }


  ///Delete apptoken in database
  static Future<void> DeleteAppToken() async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();
    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      UPDATE
        UserData
      SET
        AppToken = ?
      WHERE
        Id = 1
      ''';

    await db.execute(query, [""]);
    await db.close();
  }


  ///Read the record of language
  static Future<String> ReadLanguage() async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();
    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      SELECT
        Language
      FROM
        UserData
      WHERE
        Id = 1
      ''';

    List<Map<String, dynamic>> record = await db.rawQuery(query);
    await db.close();

    return record.first["Language"];
  }


  ///Update the record of language
  static Future<void> UpdateLanguage(String language) async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      UPDATE
        UserData
      SET
        Language = ?
      WHERE
        Id = 1
      ''';

    await db.execute(query, [language]);
    await db.close();
  }


  ///Update the record of mode
  static Future<void> UpdateMode(String mode) async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      UPDATE
        UserData
      SET
        Mode = ?
      WHERE
        Id = 1
      ''';

    await db.execute(query, [mode]);
    await db.close();
  }

  ///Read the first record
  static Future<Map<String, dynamic>> ReadAppTokenModeLanguage() async {
    UserDataRepository repository = await UserDataRepository.CreateInstance();
    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      SELECT
        *
      FROM
        UserData
      WHERE
        Id = 1
      ''';

    List<Map<String, dynamic>> record = await db.rawQuery(query);
    await db.close();

    return record.first;
  }
}