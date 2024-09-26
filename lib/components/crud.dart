import 'dart:convert';

import 'package:http/http.dart' as http;

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("erro is $e");
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("erro is $e");
    }
  }
}

validfn(String val, int min, int max) {
  if (val.length < min) {
    return "The form field have to be more than $min";
  }
  if (val.isEmpty) {
    return "You have to enter some valid input!";
  }
  if (val.length > max) {
    return "The form field have to be less than $max";
  }
}
