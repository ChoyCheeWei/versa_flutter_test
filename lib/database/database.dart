import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:versa_flutter_test/models/brewery_model.dart';

class BreweryDatabase {
  final String tableName = 'FavoriteBrewery';

  static final BreweryDatabase instance = BreweryDatabase._init();

  BreweryDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const no = 'no';
    const id = 'id';
    const name = 'name';
    const type = 'brewery_type';
    const street = 'street';
    const address_2 = 'address_2';
    const address_3 = 'address_3';
    const city = 'city';
    const state = 'state';
    const county_province = 'county_province';
    const postal_code = 'postal_code';
    const country = 'country';
    const latitude = 'latitude';
    const longitude = 'longitude';
    const phone = 'phone';
    const website_url = 'website_url';
    const updated_at = 'updated_at';
    const created_at = 'created_at';

    try {
      await db.execute('''
CREATE TABLE $tableName ( 
  $no $idType,
  $id $textType,
  $name $textType,
  $type $textType,
  $street $textType,
  $address_2 $textType,
  $address_3 $textType,
  $city $textType,
  $state $textType,
  $county_province $textType,
  $postal_code $textType,
  $country $textType,
  $latitude $textType,
  $longitude $textType,
  $phone $textType,
  $website_url $textType,
  $updated_at $textType,
  $created_at $textType
  )''');
    } catch (e) {
      print('Create Table Error $e');
    }
  }

  Future<bool> createOrDelete(BreweryModel item, bool isFavorite) async {
    try {
      final db = await instance.database;
      if (isFavorite) {
        await db.delete(tableName, where: 'id = ?', whereArgs: [item.id!]);
      } else {
        await db.insert(tableName, item.toJson());
      }
      return true;
    } catch (e) {
      print('Insert or Delete Data Error $e');
      return false;
    }
  }

  Future<List<BreweryModel>> getAllBreweries() async {
    final db = await instance.database;
    final result = await db.query(tableName);

    return result.map((e) => BreweryModel.fromJson(e)).toList();
  }
}
