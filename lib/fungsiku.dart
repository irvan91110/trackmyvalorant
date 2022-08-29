// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'global.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';

country(access_token, id_token) async {
  return ((json.decode((await http.put(
          Uri.parse(
              'https://riot-geo.pas.si.riotgames.com/pas/v1/product/valorant'),
          headers: {
            'Authorization': access_token,
          },
          body: jsonEncode({
            "id_token": id_token,
          })))
      .body)["affinities"]["live"]));
}

parseURL(uris) {
  final uri = Uri.parse(uris.replaceAll("#", "?"));
  final parseData = json.encode(uri.queryParameters);
  final databaru = json.decode(parseData);
  final data = {
    "access_token": databaru['access_token'],
    "id_token": databaru['id_token'],
    "expired": databaru['expires_in']
  };
  return (json.encode(data));
}

getcookie(cookiementah, pattern) async {
  RegExp exp = RegExp(pattern);
  RegExpMatch? match = exp.firstMatch(cookiementah.toString());
  var cookie = match![0].toString();
  return (cookie);
}

makeHeaders() {
  globals.headers = {
    'Authorization': 'Bearer ${globals.tokens['access_token']}',
    'X-Riot-Entitlements-JWT': globals.tokens['entitlements_token'].toString(),
    'X-Riot-ClientVersion': globals.client_version.toString(),
    'X-Riot-ClientPlatform':
        (base64.encode(utf8.encode(jsonEncode(globals.client_platform))))
            .toString()
  };
}

fetchStore(ppuid, auth, jwt, region) async {
  try {
    final hasilx = (json.decode(((await http.get(
            Uri.parse(
                'https://pd.${region}.a.pvp.net/store/v2/storefront/' + ppuid),
            headers: <String, String>{
          'Authorization': auth,
          'X-Riot-Entitlements-JWT': jwt,
        }))
        .body)));
    final itemparse = hasilx['SkinsPanelLayout']['SingleItemOffers'];
    var list_name = [];
    for (var i = 0; i < itemparse.length; i++) {
      final hasilx = (json.decode(((await http.get(Uri.parse(
              'https://valorant-api.com/v1/weapons/skinlevels/' +
                  itemparse[i])))
          .body))['data']);
      var senjata = {
        'uuid': hasilx['uuid'],
        'displayName': hasilx['displayName'],
        'ImgUrl': hasilx['displayIcon'],
        'ImgUrl': hasilx['displayIcon'],
      };
      list_name.add(senjata);
    }
    var List_senjata = {
      "DailySkin": {
        "List_Skin": list_name,
        "Time": ((hasilx['SkinsPanelLayout'])[
            'SingleItemOffersRemainingDurationInSeconds'])
      }
    };
    return (List_senjata["DailySkin"]);
  } catch (e) {
    print(e);
  }
}

login(username, password) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String cookie = await getcookie(
        ((await http.post(
                Uri.parse('https://auth.riotgames.com/api/v1/authorization/'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'User-Agent':
                      'RiotClient/43.0.1.4195386.4190634 rso-auth Windows; 10;;Professional, x64',
                },
                body: jsonEncode({
                  "client_id": "play-valorant-web-prod",
                  "nonce": "1",
                  "redirect_uri": "https://playvalorant.com/opt_in",
                  "response_type": "token id_token",
                  "scope": "account openid"
                })))
            .headers['set-cookie']),
        r'asid=[A-Za-z0-9_](.+)Path=/; HttpOnly; Secure');

    var response = (await http.put(
        Uri.parse('https://auth.riotgames.com/api/v1/authorization/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'cookie': cookie,
          'User-Agent':
              'RiotClient/43.0.1.4195386.4190634 rso-auth Windows; 10;;Professional, x64',
        },
        body: jsonEncode({
          "type": "auth",
          "username": username,
          "password": password,
          "remember": "true",
          "language": "en_US"
        })));

    if (json.decode(response.body).containsKey('error')) {
      return (jsonEncode({
        "auth": "error",
        "type": "username/password error",
      }));
    } else {
      //ssid fetch
      globals.ssid_cookie = await getcookie((response.headers['set-cookie']),
          r'ssid=[A-Za-z0-9_](.+)GMT; HttpOnly; Secure; SameSite=None');
      //parse token
      globals.tokens = json.decode(parseURL(
          json.decode(response.body)['response']['parameters']['uri']));
      //entitlements_token
      globals.tokens['entitlements_token'] = json.decode((((await http.post(
              Uri.parse('https://entitlements.auth.riotgames.com/api/token/v1'),
              headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${globals.tokens['access_token']}',
          }))
          .body)))['entitlements_token'];
      //client_version
      globals.client_version = json.decode(
          (((await http.get(Uri.parse('https://valorant-api.com/v1/version')))
              .body)))['data']['riotClientVersion'];
      //ppuid
      final ppuid = json.decode(utf8
          .fuse(base64)
          .decode((globals.tokens['access_token'].split(".")[1] + "=")))["sub"];
      // print(globals.tokens["access_token"]);
      // print(globals.tokens["id_token"]);

      return (jsonEncode({
        "auth": "success",
        "ppuid": ppuid,
        "Authorization": 'Bearer ${globals.tokens['access_token']}',
        "X-Riot-Entitlements-JWT":
            globals.tokens['entitlements_token'].toString(),
        "X-Riot-ClientVersion": globals.client_version.toString(),
        "X-Riot-ClientPlatform":
            (base64.encode(utf8.encode(jsonEncode(globals.client_platform))))
                .toString(),
        "id_token": globals.tokens['id_token'],
        "expired": globals.tokens['expired']
      }));
    }
  } on SocketException catch (_) {
    print("no connection ");
    return (jsonEncode({
      "auth": "error_connection",
      "type": "no connection",
    }));
  }
}
