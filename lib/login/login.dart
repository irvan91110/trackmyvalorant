// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:valoranttracker/custom_checkbox.dart';

import 'package:valoranttracker/home/main_fragment.dart';

import '../fungsiku.dart' as fungsi;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _login();
}

class _login extends State<login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _fetchData(BuildContext context) async {
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

      if (usernameController.text == "" || passwordController.text == "") {
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
        final idih = (await fungsi.login(
            usernameController.text, passwordController.text));

        // Close the dialog programmatically
        Navigator.of(context).pop();
        // ignore: non_constant_identifier_names

        final aduh = jsonDecode(idih);

        if (aduh['auth'] == "success") {
          final regions =
              (await fungsi.country(aduh['Authorization'], aduh['id_token']));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Main(
                    ppuid: aduh['ppuid'],
                    Authorization: aduh['Authorization'],
                    Entitlements: aduh['X-Riot-Entitlements-JWT'],
                    ClientVersion: aduh['ClientVersion'],
                    ClientPlatform: aduh['ClientPlatform'],
                    region: regions,
                    expired: aduh['expired'],
                  )));
        } else if (aduh['auth'] == "error") {
          message("Error_message", "Username/Password incorrect");
        } else if (aduh['auth'] == "error_connection") {
          message("Error_message", "please turn your internet on");
        }
      }
      // show the loading dialog
    }

    final keyboardtest = MediaQuery.of(context).viewInsets.bottom != 0;
    bool isChecked = false;
    double size = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF0F1722),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                if (!keyboardtest)
                  SizedBox(
                    height: size * 0.3,
                  ),
                SizedBox(
                  height: size * 0.2,
                ),
                Image.asset("assets/images/ic_login.png"),
                SizedBox(
                  height: size * 0.1,
                ),
                //emailform
                SizedBox(
                  width: size * 0.85,
                  height: height * 0.065,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1B2635),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: TextField(
                        controller: usernameController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Color(0xffFFFFFF),
                            fontSize: 23),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(fontSize: 23, color: Color(0xffFFFFFF)),
                        ),
                      ),
                    ),
                  ),
                ),
                // ignore: prefer__ructors
                SizedBox(
                  height: 15,
                ),
                //password
                SizedBox(
                  width: size * 0.85,
                  height: height * 0.065,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1B2635),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: TextField(
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Color(0xffFFFFFF),
                            fontSize: 23),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(fontSize: 23, color: Color(0xffFFFFFF)),
                        ),
                      ),
                    ),
                  ),
                ),
                //jarak
                SizedBox(
                  height: 15,
                ),
                //checkbox
                SizedBox(
                  width: size * 0.83,
                  height: height * 0.05,
                  child: Row(
                    children: [
                      Custom_Checkbox(
                        isChecked: isChecked,
                        onChange: (value) {
                          isChecked = value;
                        },
                        backgroundColor: Color(0xff1B2635),
                        borderColor: Color(0xff1B2635),
                        icon: Icons.check,
                        size: 30,
                      ),
                      Text(
                        '  Remember Me ',
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                //jarak
                SizedBox(
                  height: 15,
                ),
                //jarak
                SizedBox(
                  width: size * 0.85,
                  height: height * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffDC3D4B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Sign In'),
                    onPressed: () async {
                      _fetchData(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
