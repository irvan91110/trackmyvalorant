import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'global.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';

Future country(accessToken, idToken) async => ((json.decode((await http.put(
        Uri.parse(
            'https://riot-geo.pas.si.riotgames.com/pas/v1/product/valorant'),
        headers: {
          'Authorization': accessToken,
        },
        body: jsonEncode({
          "id_token": idToken,
        })))
    .body)["affinities"]["live"]));

String parseURL(uris) {
  dynamic uri = json.decode(
      json.encode(Uri.parse(uris.replaceAll("#", "?")).queryParameters));
  return (json.encode({
    "access_token": uri['access_token'],
    "id_token": uri['id_token'],
    "expired": uri['expires_in']
  }));
}

Future<String> getcookie(cookiementah, pattern) async {
  try {
    RegExp exp = RegExp(pattern);
    RegExpMatch? match = exp.firstMatch(cookiementah.toString());
    var cookie = match![0].toString();
    return (cookie);
  } catch (e) {
    return (jsonEncode({
      "auth": "Login error",
      "type": "Fetch data error",
    }));
  }
}

get makeHeaders {
  return globals.headers = {
    'Accept-Language': 'en-US,en;q=0.9',
    'Authorization': 'Bearer ${globals.tokens['access_token']}',
    'X-Riot-Entitlements-JWT': globals.tokens['entitlements_token'].toString(),
    'X-Riot-ClientVersion': globals.clientversion.toString(),
    'X-Riot-ClientPlatform':
        (base64.encode(utf8.encode(jsonEncode(globals.clientPlatform))))
            .toString()
  };
}

Future agent(agentid) async => (jsonDecode((await http.get(
      Uri.parse('${globals.apiUrl}/v1/agents/${agentid}'),
    ))
        .body));

Future contract(header) async => (jsonDecode((await http.get(
            Uri.parse(
                'https://pd.${header['region']}.a.pvp.net/contracts/v1/contracts/${header['ppuid']}'),
            headers: <String, String>{
          'Authorization': header['Authorization'],
          'X-Riot-Entitlements-JWT': header['Entitlements'],
          'X-Riot-ClientVersion': header['ClientVersion']
        }))
        .body));

get agentcontract async =>
    (jsonDecode((await http.get(Uri.parse('${globals.apiUrl}/v1/contracts/')))
        .body)['data']);

Future getmission(missionid) async => (jsonDecode(
    (await http.get(Uri.parse('${globals.apiUrl}/v1/missions/${missionid}')))
        .body)['data']);

Future<Object> fetchStore(header) async {
  try {
    final hasilx = (json.decode(((await http.get(
            Uri.parse(
                'https://pd.${header['region']}.a.pvp.net/store/v2/storefront/${header['ppuid']}'),
            headers: <String, String>{
          'Authorization': header['Authorization'],
          'X-Riot-Entitlements-JWT': header['Entitlements'],
        }))
        .body)));

    final itemparse = hasilx['SkinsPanelLayout']['SingleItemOffers'];
    var guns = [];
    for (var h = 0; h < itemparse.length; h++) {
      final hasilx = (json.decode(
          ((await http.get(Uri.parse('${globals.apiUrl}/v1/weapons')))
              .body))['data']);

      for (int i = 0; i < hasilx.length; i++) {
        for (int j = 0; j < hasilx[i]['skins'].length; j++) {
          for (int k = 0; k < hasilx[i]['skins'][j]['levels'].length; k++) {
            if (hasilx[i]['skins'][j]['levels'][k]['uuid'] == itemparse[h]) {
              final tierGet = (json.decode(((await http.get(Uri.parse(
                      '${globals.apiUrl}/v1/contenttiers/${hasilx[i]['skins'][j]['contentTierUuid']}')))
                  .body))['data']);

              tierGet['highlightColor'] =
                  tierGet['highlightColor'].substring(0, 6);
              var senjata = {
                'uuid': hasilx[i]['skins'][j]['levels'][k]['uuid'],
                'displayName': hasilx[i]['skins'][j]['levels'][k]
                    ['displayName'],
                'ImgUrl': hasilx[i]['skins'][j]['levels'][k]['displayIcon'],
                'Tier': tierGet,
              };

              guns.add(senjata);
            }
          }
        }
      }
    }
    var listsenjata = {
      "skins": guns,
      "Time": ((hasilx['SkinsPanelLayout'])[
          'SingleItemOffersRemainingDurationInSeconds'])
    };
    return (listsenjata);
  } catch (e) {
    return (e);
  }
}

dynamic getppuid(ppuid) {
  try {
    return (json
        .decode(utf8.fuse(base64).decode((ppuid.split(".")[1] + "=")))["sub"]);
  } catch (e) {
    return (json.decode(utf8.decode(
        base64Url.decode(base64.normalize(ppuid.split(".")[1]))))["sub"]);
  }
}

Future<String> login(username, password, remember) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String riotClientBuild = ((json.decode(
        (await http.get(Uri.parse('${globals.apiUrl}/v1/version')))
            .body)["data"]["riotClientBuild"]));

    Map<String, String> header = {
      'Accept-Language': 'en-US,en;q=0.9',
      'Content-Type': 'application/json',
      'User-Agent':
          'RiotClient/$riotClientBuild rso-auth (Windows;10;;Professional, x64)',
    };
    String cookie = await getcookie(
        ((await http.post(Uri.parse('${globals.baseUrl}/api/v1/authorization'),
                headers: header,
                body: jsonEncode({
                  "client_id": "play-valorant-web-prod",
                  "nonce": "1",
                  "redirect_uri": "https://playvalorant.com/opt_in",
                  "response_type": "token id_token",
                  "scope": "account openid"
                })))
            .headers['set-cookie']),
        r'asid=[A-Za-z0-9_](.+)Path=/; HttpOnly; Secure');

    header['cookie'] = cookie;
    var response =
        (await http.put(Uri.parse('${globals.baseUrl}/api/v1/authorization'),
            headers: header,
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
      globals.ssidcookie = await getcookie((response.headers['set-cookie']),
          r'ssid=[A-Za-z0-9_](.+)GMT; HttpOnly; Secure; SameSite=None');
      //parse token
      globals.tokens = json.decode(parseURL(
          json.decode(response.body)['response']['parameters']['uri']));
      //entitlements_token
      globals.tokens['entitlements_token'] = json.decode((((await http.post(
              Uri.parse('https://entitlements.auth.riotgames.com/api/token/v1'),
              headers: <String, String>{
            'Accept-Language': 'en-US,en;q=0.9',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${globals.tokens['access_token']}',
          }))
          .body)))['entitlements_token'];
      //client version
      globals.clientversion = json.decode(
          (((await http.get(Uri.parse('${globals.apiUrl}/v1/version')))
              .body)))['data']['riotClientVersion'];
      //region
      globals.region = await country("bearer " + globals.tokens['access_token'],
          globals.tokens['id_token']);
      //set Header
      makeHeaders;
      final ppuid = getppuid(globals.tokens['access_token']);

      String displayIcon = ((json.decode(((await http.get(Uri.parse(
              '${globals.apiUrl}/v1/playercards/${(json.decode((await http.get(
        Uri.parse(
            'https://pd.${globals.region}.a.pvp.net/personalization/v2/players/${ppuid}/playerloadout'),
        headers: globals.headers,
      )).body)["Identity"]["PlayerCardID"])}')))
          .body))['data']['displayIcon']));

      if (remember == true) {
        String? accountlist = prefs.getString('accountlist');

        accountlist ??= "[]";
        List parsedJson = jsonDecode(accountlist);
        final max = parsedJson.isEmpty ? 0 : parsedJson.last['uuid'] + 1;

        nickname() {
          try {
            final nickname = json.decode(utf8.fuse(base64).decode(
                (globals.tokens['id_token'].split(".")[1] + "=")))["acct"];
            return (nickname['game_name'] + "#" + nickname['tag_line']);
          } catch (e) {
            final nickname = (json.decode(utf8.decode(base64Url.decode(
                base64.normalize(
                    globals.tokens['id_token'].split(".")[1]))))["acct"]);

            return ((nickname['game_name'] + "#" + nickname['tag_line']));
          }
        }

        Map<String, dynamic> multiData = {
          "uuid": max,
          "displayIcon": displayIcon,
          "nickname": nickname(),
          "username": username,
          "password": password
        };

        if (parsedJson.isEmpty) {
          parsedJson.add(multiData);

          String encodedMap = json.encode(parsedJson);
          prefs.setString('accountlist', encodedMap);
        } else {
          final matchingBooks = parsedJson.firstWhere(
              (element) => element['username'] == username,
              orElse: () => null);
          if (matchingBooks == null) {
            parsedJson.add(multiData);
            String encodedMap = json.encode(parsedJson);

            prefs.setString('accountlist', encodedMap);
          }
        }
      }

      var successResponse = {
        "auth": "success",
        "ppuid": ppuid,
        "id_token": globals.tokens['id_token'],
        "expired": globals.tokens['expired']
      };

      successResponse.addAll(globals.headers!);

      return (jsonEncode(successResponse));
    }
  } on SocketException catch (_) {
    return (jsonEncode({
      "auth": "error_connection",
      "type": "no connection",
    }));
  }
}
