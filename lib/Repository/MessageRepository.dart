import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Applicable for android only
class MessageRepository {
  String DatabasePath;
  MessageRepository._(this.DatabasePath);  

  static Future<MessageRepository> CreateInstance() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Textpop.db');
    return MessageRepository._(path);
  }


  ///Check if table exists, if not then create a table
  static Future<void> CreateTableWhenNotExist() async {
    MessageRepository repository = await MessageRepository.CreateInstance();
    bool exist = await databaseExists(repository.DatabasePath);

    Database db = await openDatabase(repository.DatabasePath, version: 1);
    final List<Map<String, dynamic>> tables = await db.query('sqlite_master', where: 'name = ?', whereArgs: ["Message"]);
    bool tableExist = tables.isNotEmpty;

    if (!exist || !tableExist) {
      await db.execute(
        '''
        CREATE TABLE "Message" (
          "Id"	INTEGER,
          "MessageId"	TEXT,
          "OtherUserId" TEXT,
          "OtherUserUsername" TEXT,
          "Text" TEXT,
          PRIMARY KEY("Id" AUTOINCREMENT)
        )
        '''
      );
    }
  }

  static Future<void> CreateUnseenMessage(
    String messageId, String otherUserId, String otherUserUsername, String text) async{
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      INSERT INTO 
        Message(MessageId, OtherUserId, OtherUserUsername, Text)
      VALUES
        (?, ?, ?, ?)
      ''';

    await db.execute(query, [messageId, otherUserId, otherUserUsername, text]);
    await db.close();
  }


  static Future<List<Map<String, dynamic>>> ReadLastFiveRecords(String otherUserId) async {
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      SELECT 
        * 
      FROM 
        Message
      WHERE 
        OtherUserId = ? 
      ORDER BY 
        MessageId DESC 
      LIMIT 5
      ''';

    List<Map<String, dynamic>> record = await db.rawQuery(query, [otherUserId]);
    await db.close();

    return record;
  }


  static Future<int> ReadUnseenMessageCount(String otherUserId) async {
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      SELECT 
        COUNT(*) as total 
      FROM 
        Message
      WHERE 
        OtherUserId = ?
      ''';

    List<Map<String, dynamic>> result = await db.rawQuery(query, [otherUserId]);
    await db.close();

    return result.first['total'];
  }



  static Future<void> DeleteUnseenMessage(String otherUserId) async{
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      DELETE FROM 
        Message 
      WHERE 
        OtherUserId = ?
      ''';

    await db.execute(query, [otherUserId]);
    await db.close();
  }

  static Future<void> DeleteMessageWithMessageId(String messageId) async{
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      DELETE FROM 
        Message 
      WHERE 
        MessageId = ?
      ''';

    await db.execute(query, [messageId]);
    await db.close();
  }

  static Future<void> DeleteAllUnseenMessage() async{
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      DELETE FROM 
        Message 
      ''';

    await db.execute(query);
    await db.close();
  }


  static Future<List<String>> ReadUniqueUserId() async{
    MessageRepository repository = await MessageRepository.CreateInstance();

    Database db = await openDatabase(repository.DatabasePath, version: 1);

    String query = '''
      SELECT DISTINCT
        OtherUserId 
      FROM 
        Message 
      ''';

    List<Map<String, dynamic>> record = await db.rawQuery(query);
    await db.close();

    return record.map((x) => x["OtherUserId"] as String).toList();
  }
}