import 'package:flutter/services.dart';
import 'dart:io';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:trackmyvalorant/login/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../network/fungsiku.dart' as fungsi;
import 'package:trackmyvalorant/home/main_fragment.dart';

class MultipleLogin extends StatefulWidget {
  const MultipleLogin({Key? key}) : super(key: key);

  @override
  State<MultipleLogin> createState() => _multiple_login();
}

class _multiple_login extends State<MultipleLogin> {
  listaccount() async {
    final prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('accountlist');
    if (action != null) {
      return jsonDecode(action);
    }
    return [];
  }

  delete(uuid) async {
    return await showDialog(
          barrierColor: Color(0xff0F1722).withOpacity(0.8),
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 55.0, vertical: 35.0),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              title: const Text('Delete Account'),
              content: Wrap(
                children: [
                  Image.asset("assets/images/sadge.png"),
                  const Center(
                    child: Text(
                      'Do you want to delete this account?',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final prefs = await SharedPreferences.getInstance();
                          final String? action = prefs.getString('accountlist');
                          final List xxx = jsonDecode(action!);
                          xxx.removeWhere((item) => item['uuid'] == uuid);
                          await prefs.setString('accountlist', jsonEncode(xxx));
                          setState(() {});
                        },
                        //return false when click on "NO"
                        child: const Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        //return true when click on "Yes"
                        child: const Text('no'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void _fetchData(
      BuildContext context, String username, String password) async {
    void message(String Errtitle, String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(Errtitle),
          content: Text(message),
          actions: <Widget>[
            Container(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("okay"),
              ),
            ),
          ],
        ),
      );
    }

    if (username == "" || password == "") {
      message("error_message", "Empty field username/password");
    } else {
      showDialog(
          // The user CANNOT close this dialog  by pressing outsite it
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // The loading indicator
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    // Some text
                    Text('Loading...')
                  ],
                ),
              ),
            );
          });

      // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
      await Future.delayed(const Duration(seconds: 3));

      final idih = (await fungsi.login(username, password, false));

      Navigator.of(context).pop();

      final aduh = jsonDecode(idih);

      if (aduh['auth'] == "success") {
        final regions =
            (await fungsi.country(aduh['Authorization'], aduh['id_token']));
        Map<String, String> header = {
          'ppuid': aduh['ppuid'],
          'Authorization': aduh['Authorization'],
          'Entitlements': aduh['X-Riot-Entitlements-JWT'],
          'ClientVersion': aduh['X-Riot-ClientVersion'],
          'ClientPlatform': aduh['X-Riot-ClientPlatform'],
          'region': regions,
          'expired': aduh['expired'],
          'id_token': aduh['id_token']
        };
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Main(
                  header: header,
                  username: username,
                )));
      } else if (aduh['auth'] == "error") {
        message("Error_message", "Username/Password incorrect");
      } else if (aduh['auth'] == "error_connection") {
        message("Error_message", "please turn your internet on");
      } else {
        message("Error_message", "Fetch Data error! try again in 5 sec");
      }
    }
    // show the loading dialog
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listaccount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var accountlist = snapshot.data;

          int xx = 35;

          accountlist ??= [];

          if (accountlist.isEmpty) {
            if (accountlist.length > 1) {
              for (var i = 1; i <= accountlist.length; i++) {
                xx += 15;
              }
            }
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xFF0F1722),
            body: CustomScrollView(slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.2,
                            bottom: 5),
                        child: const Center(
                          child: Text("Choose your account ",
                              style: TextStyle(
                                  fontSize: 22, color: Color(0xFFFFFFFF)),
                              textDirection: TextDirection.ltr),
                        ),
                      ),
                      const Center(
                        child: Text("Your can easly change different account",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFFFFFF)),
                            textDirection: TextDirection.ltr),
                      ),
                      if (accountlist != null)
                        if (accountlist.length > 3)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          )
                        else
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.25 - xx,
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Color(0xff1B2635),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10),
                                child: Column(
                                  children: <Widget>[
                                    if (accountlist.isEmpty)
                                      const Text(
                                        "Empty List",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    else
                                      for (var i = 0;
                                          i < accountlist.length;
                                          i++)
                                        Column(
                                          /* crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start, */
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                _fetchData(
                                                    context,
                                                    accountlist[i]['username'],
                                                    accountlist[i]['password']);
                                              }, // Image tapped
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xff141C27),
                                                              width: 5),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: accountlist[
                                                                    i]
                                                                ['displayIcon'],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "@${accountlist[i]['username']}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                          Text(
                                                            "${accountlist[i]['nickname']}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        PopupMenuButton(
                                                          color: const Color(
                                                              0xff364254),
                                                          offset: const Offset(
                                                              5,
                                                              50), // SET THE (X,Y) POSITION
                                                          // iconSize: 30,
                                                          //icon: Icon(
                                                          // Icons
                                                          //   .filter_alt_rounded, // CHOOSE YOUR CUSTOM ICON
                                                          //color: Colors.white,
                                                          //),

                                                          itemBuilder:
                                                              (BuildContext
                                                                      context) =>
                                                                  [
                                                            const PopupMenuItem(
                                                                value: 1,
                                                                child: Text(
                                                                  "edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                            const PopupMenuItem(
                                                              value: 2,
                                                              child: Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                          onSelected:
                                                              (value) async {
                                                            if (value == 1) {
                                                            } else {
                                                              delete(i);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                            ),
                                            if ((i != accountlist.length - 1))
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                  height: 10,
                                                  thickness: 2,
                                                ),
                                              ),
                                          ],
                                        )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //pastehere
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => login()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        10.0) //                 <--- border radius here
                                    ),
                                border: Border.all(
                                  color: Color(0xff1B2635),
                                  width: 3,
                                )),
                            child: const Center(
                              child: Text(
                                'Add A New Account',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ]))
            ]),
          );
        });
  }
}
