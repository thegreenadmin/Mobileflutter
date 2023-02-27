import 'package:get_storage/get_storage.dart';

class SharedPreferenceStorage {
   
static final storage = GetStorage();

static void setData(String key, dynamic value) async {
  final GetStorage storage = GetStorage();
  storage.write(key, value);
}

static String? getString(String key) {
  final GetStorage storage = GetStorage();
  return storage.read(key);
}

static int? getInt(String key) {
  final GetStorage storage = GetStorage();
  return storage.read(key);
}

static bool? getBool(String key) {
  final GetStorage storage = GetStorage();
  return storage.read(key);
}

static dynamic getData(String key) {
  final GetStorage storage = GetStorage();
  return storage.read(key);
}

static void clearData() {
  final GetStorage storage = GetStorage();
  storage.erase();
}

static void removeData(String key) {
  final GetStorage storage = GetStorage();
  storage.remove(key);
}
}