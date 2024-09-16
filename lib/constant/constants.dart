import '../main.dart';

class Constants {
  static String? userToken = sharedPref.getString("token");
  static String? userName = sharedPref.getString("name");
  static String? baseUrl =
      "https://flutter.prominaagency.com/api"; // base url has all endpoints
}
