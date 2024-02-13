import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static  const  StringSharedPreference = "Type";
  static Future<String> getString(String Key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Key) ?? "";
  }

  static Future setString(String Key,String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(Key, value);
  }
  static getBoolean(String Key) async {
    final prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(Key) ?? false;
  }

  static Future setBoolean(String Key,bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(Key, value);
  }

  static savePrefString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static savePrefInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  static savePrefBoll(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  static savePrefDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble(key, value);
  }

  static savePrefStringList(String key, List<String> value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, value);
  }

  static Future<String> getPrefString(String key, String defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? defaultValue;
  }

  static Future<int> getPrefInt(String key, int defaultValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? defaultValue;
  }


}


class Prefs1
{
  static SharedPreferences?_Prefsinstance;
  static Future <SharedPreferences>init()async
  {
    _Prefsinstance=await SharedPreferences.getInstance();
    return _Prefsinstance!;
  }
  static Future SetString(String key , String value)
  async{
    var prefs= await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
  static Future GetString(String key )
  async{

    return _Prefsinstance!.getString(key)??"";
  }

}