import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider_example/src/shared/shared_preferences.dart';

class UserProvider {
  final String _firebaseToken = 'AIzaSyCYvRT0FDLvHozLOQf4uBni8JEEIYbOyyk';
  final _pref = UserPreferences();

  Future<Map<String, dynamic>> authUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);

    if (decodeResponse.containsKey('idToken')) {
      _pref.token = decodeResponse['idToken'];

      return {'ok': true, 'token': decodeResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodeResponse['error']['message']};
    }
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnScureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);

    if (decodeResponse.containsKey('idToken')) {
      _pref.token = decodeResponse['idToken'];

      return {'ok': true, 'token': decodeResponse['idToken'], 'email': email, 'password': password };
    } else {
      return {'ok': false, 'message': decodeResponse['error']['message']};
    }
  }
}
