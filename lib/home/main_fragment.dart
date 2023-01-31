import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:trackmyvalorant/fungsiku.dart' as fungsi;
import 'package:trackmyvalorant/home/First_Fragment.dart';
import 'package:trackmyvalorant/home/Second_fragment.dart';
import 'package:trackmyvalorant/home/fourth_fragment.dart';

import 'package:trackmyvalorant/home/third_fragment.dart';

class Main extends StatefulWidget {
  final Map<String, String> header;
  final String username;
  const Main({
    Key? key,
    required this.header,
    required this.username,
  }) : super(key: key);
//pasang kondisi if remember me

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height * 0.1;

    fragments(context) {
      if (_selectedIndex == 0) {
        return FirstFragment(
          header: widget.header,
        );
      } else if (_selectedIndex == 1) {
        return second();
      } else if (_selectedIndex == 2) {
        return third();
      } else if (_selectedIndex == 3) {
        return fourth();
      }
    }

    Future refresh() async {
      setState(() {
        fragments(context);
      });
    }

    Future<bool> showExitPopup() async {
      return await showDialog(
            barrierColor: const Color(0xff0F1722).withOpacity(0.8),
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 55.0, vertical: 35.0),
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                title: const Text('Exit App'),
                content: Wrap(
                  children: [
                    Image.asset("assets/images/sadge.png"),
                    const Center(
                      child: Text(
                        'Do you want to exit an App?',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          //return false when click on "NO"
                          child: Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else if (Platform.isIOS) {
                              exit(0);
                            }
                          },
                          //return true when click on "Yes"
                          child: Text('Yes'),
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

    return WillPopScope(
      onWillPop: () {
        if (_selectedIndex == 0) {
          showExitPopup();
          return Future.value(false);
        } else {
          setState(() {
            _selectedIndex = 0;
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
          /* appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              )), */
          backgroundColor: Color(0xFF0F1722),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: Container(child: fragments(context)),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Color(0xff1B2635),
            ),
            child: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              child: SizedBox(
                height: tinggi,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconBottomBar(
                            icon: "assets/images/bottom_bar_icons/main.svg",
                            selected: _selectedIndex == 0,
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            }),
                        IconBottomBar(
                            icon: "assets/images/bottom_bar_icons/stats.svg",
                            selected: _selectedIndex == 1,
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            }),
                        IconBottomBar(
                            icon:
                                "assets/images/bottom_bar_icons/leaderboard.svg",
                            selected: _selectedIndex == 2,
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            }),
                        IconBottomBar(
                            icon: "assets/images/bottom_bar_icons/profile.svg",
                            selected: _selectedIndex == 3,
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            }),
                      ],
                    )),
              ),
            ),
          )),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final String icon;
  final bool selected;
  final Function() onPressed;

  const IconBottomBar(
      {required this.icon,
      required this.selected,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height * 0.1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: onPressed,
            icon: SvgPicture.asset(icon,
                height: tinggi * 0.33,
                width: 5,
                color: (selected ? const Color(0xFFFA4454) : Colors.white))),
        Container(
          // use aligment
          color: (selected ? const Color(0xFFFA4454) : Colors.transparent),
          height: 2,
          width: 35,
        )
      ],
    );
  }
}
