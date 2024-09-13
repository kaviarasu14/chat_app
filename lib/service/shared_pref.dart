import 'package:shared_preferences/shared_preferences.dart';

class sharedpreferenceHelper {
  static String userIdkey = "USERKEY";
  static String userNamekey = "USERNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";
  static String userPickey = "USERPICKEY";
  static String Displaynamekey = "USERDISPLAYNAMEKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdkey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNamekey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailkey, getUserEmail);
  }

  Future<bool> saveUserPic(String getUserPic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPickey, getUserPic);
  }

  Future<bool> saveUserDisplayname(String getUserDisplayname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Displaynamekey, getUserDisplayname);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdkey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNamekey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailkey);
  }

  Future<String?> getUserPic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPickey);
  }

  Future<String?> getDisplayname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Displaynamekey);
  }
}
