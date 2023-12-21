import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices extends GetxService {
  static StorageServices get to => Get.put(StorageServices());
  late final SharedPreferences sharedPref;
  Future<StorageServices> init() async {
    sharedPref = await SharedPreferences.getInstance();
    return this;
  }

  //setting shared preferences
  Future<bool> setString({required String key, required String value}) async {
    return await sharedPref.setString(key, value);
  }

  Future<bool> setBool({required String key, required bool value}) async {
    return await sharedPref.setBool(key, value);
  }

  Future<bool> setList(
      {required String key, required List<String> value}) async {
    return await sharedPref.setStringList(key, value);
  }

  //getting shared preferences
  String getString(String key) {
    return sharedPref.getString(key) ?? "";
  }

  bool getbool(String key) {
    return sharedPref.getBool(key) ?? false;
  }

  List<String> getStringList(String key) {
    return sharedPref.getStringList(key) ?? [];
  }
  Future<bool> remove(String key)async{
    return await sharedPref.remove(key);
  }
}
