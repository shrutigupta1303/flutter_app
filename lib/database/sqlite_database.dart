import 'package:flutter_test_app/model/customer_data.dart';
import 'package:sqflite/sqflite.dart';


class SqliteDatabase {

  Future<String> createDataBase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = databasesPath + '/flutterTestApp.db';
      print("dB path  ${path}");
      return path;
    } catch (e) {
      throw "Something went wrong while database creation";
    }
  }

  Future<Database> getDatabase() async {
    try {
      String path = await createDataBase();
      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute(
                'CREATE TABLE CustomerData (id INTEGER PRIMARY KEY AUTOINCREMENT, iMEI TEXT, uDID TEXT, firstname TEXT, lastname TEXT,dob TEXT,passport TEXT,email TEXT, profileImage TEXT, device TEXT, lat TEXT, long TEXT)');
          });
      return database;
    } catch (e) {
      throw "Table not created";
    }
  }

  Future<bool> insertCustomerData(CustomerDetails model) async {
    try {
      Database database = await getDatabase();
      await database.transaction((txn) async {
        int insertedData = await txn.rawInsert(
            'INSERT INTO CustomerData(iMEI, uDID, firstname, lastname, dob, passport, email, profileImage,device,lat,long) VALUES(?,?,?,?,?,?,?,?,?,?,?)',
            [
              model.iMEI ?? "",
              model.uDID ?? "",
              model.firstName ?? "",
              model.lastName ?? "",
              model.dob ?? "",
              model.passport ?? "",
              model.email ?? "",
              model.image ?? "",
              model.device ?? "",
              model.latitude ?? "",
              model.longitude ?? ""
            ]);
        print('inserted value is: $insertedData');
        return true;
      });
      return false;
    } catch (e) {
      throw "Insertion failed";
    }
  }
}
