import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'global_share_data.dart';

class SharedPreferenceStorage {
  static final storage = GetStorage();

  static void setData(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
    // final GetStorage storage = GetStorage();
    // storage.write(key, value);
  }

  static String? getString(String key) {
    final GetStorage storage = GetStorage();
    return storage.read(key);
  }

  static Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
    // final GetStorage storage = GetStorage();
    // return storage.read(key);
  }

  static bool? getBool(String key) {
    final GetStorage storage = GetStorage();
    return storage.read(key);
  }

  static Future<dynamic> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
    // final GetStorage storage = GetStorage();
    // return storage.read(key);
  }

  static void clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    forFirstTimeCustomer.value = false;
    forFirstTimeOwner.value = false;
    SharedPreferenceStorage.removeData(StringConstants.firstNameSmallText);
    SharedPreferenceStorage.removeData(StringConstants.firstNameText);
    SharedPreferenceStorage.removeData(StringConstants.lastNameText);
    SharedPreferenceStorage.removeData(StringConstants.emailText);
    SharedPreferenceStorage.removeData(StringConstants.authenticatedText);
    SharedPreferenceStorage.removeData(StringConstants.currentUserIdText);
    SharedPreferenceStorage.removeData(Role.role);
    SharedPreferenceStorage.removeData(StringConstants.lastNameSmallText);
    SharedPreferenceStorage.removeData(StringConstants.emailText.toLowerCase());
    SharedPreferenceStorage.removeData(StringConstants.tokenText);
    SharedPreferenceStorage.removeData(StringConstants.contextText);
    SharedPreferenceStorage.removeData("wasKilled");
    await prefs.clear();
    // final GetStorage storage = GetStorage();
    // storage.erase();
  }

  static  removeData(String key) async {
    // final GetStorage storage = GetStorage();
    // storage.remove(key);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
