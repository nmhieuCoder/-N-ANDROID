import 'dart:convert';
import 'package:doandidong/backend/object/hotel_object.dart';
import 'package:doandidong/backend/object/post_object.dart';
import 'package:doandidong/backend/object/user_object.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  static List<UserObject> parseUsers(String reponseBody) {
    final pased = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return pased.map<UserObject>((e) => UserObject.fromJson(e)).toList();
  }
  static List<PostObject> parsePots(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PostObject>((e) => PostObject.fromJson(e)).toList();
  }

  static Future<dynamic> getToken() async {
    /* ==== Lấy token từ Storage ==== */
    SharedPreferences pres = await SharedPreferences.getInstance();
    var token = pres.getString('token');
    return token;
  }
  static Future<bool> login(String email, String password) async {
    // String url =  'http://dulich.local/api/sanctum/token';
    String url =  dotenv.env['API_URL_CUS']! +'/api/sanctum/token';
    final response = await http.post(Uri.parse(url),
        body:( {
          'email': email,
          'password': password,
        }));
    final jsonRespon = jsonDecode(response.body);
    if (jsonRespon["status"] == '200') {
      // /* ==== Lưu trữ token vào Storage ==== */
      SharedPreferences pres = await SharedPreferences.getInstance();
      pres.setString('token', jsonRespon["token"]);
      // /* ==== In ra token ==== */
      return true;
    } else {
      return false;
    }
  }

  /* ==== Start Register ==== */
  static Future<bool> register(String name, String email, String password) async {
    String url =  dotenv.env['API_URL_CUS']! +'/api/user';
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(
          {
            "name" :name,
            "user":name,
            "password1" :password,
            "image": "1.png",
            "birthday" : "28-09-2001",
            "position" :"4",
            "email": email,
            "phone" :"0799501324"
          }
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    final jsonRespon = jsonDecode(response.body);

    if (jsonRespon["status"] == '200') {
      return true;
    } else {
      return false;
    }
  }

  /* ==== Logout ==== */
  static Future<bool> logout() async {
    var token = await getToken();
     String url =  dotenv.env['API_URL_CUS']! +'/api/sanctum/user/deleteTokenUserCurrent';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final jsonRespon = jsonDecode(response.body);
    if (jsonRespon['status'] == '200') {
      return true;
    } else {
      return false;
    }
  }
   

  //=========== Ds bai viet User chia se
  //  static Future<List<PostObject>> getAllPost() async {
  //   String url = dotenv.env['API_URL_CUS']! + '/api/post';
  //   Map<String, String> userHeader = {
  //     "Content-type": "application/json",
  //     "Accept": "application/json"
  //   };
  //   final response = await http.get(Uri.parse(url), headers: userHeader);
  //   return parsePots(response.body);
  // }

  
 static Future<UserObject> getUser() async {
    //var token = await getToken();
    String url =  dotenv.env['API_URL_CUS']! +'/api/sanctum/user';
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer 74|BuEkN8NwFgQcsXVBF1qzgkh4escwpFQjAdhnbxV7',
    });
    SharedPreferences pres = await SharedPreferences.getInstance();
    String user = response.body;
    pres.setString('user', user);
    return UserObject.fromJson(jsonDecode(response.body));
  }
 

}



/* ==== Start Register ==== */
  // static Future<bool> updateInfor(
  //     String hoTen,
  //     String email,
  //     String soDienThoai,
  //     int trangThaiHoTen,
  //     int trangThaiSDT,
  //     int trangThaiEmail) async {
  //   var token = await getToken();
  //   final response = await http.post(Uri.parse(urlAPI + 'user/update-infor'),
  //       body: jsonEncode({
  //         'hoTen': hoTen,
  //         'email': email,
  //         'soDienThoai': soDienThoai,
  //         'trangThaiHoTen': trangThaiHoTen,
  //         'trangThaiSDT': trangThaiSDT,
  //         'trangThaiEmail': trangThaiEmail,
  //       }),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       });
  //   final jsonRespon = jsonDecode(response.body);
  //   if (jsonRespon["status_code"] == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }