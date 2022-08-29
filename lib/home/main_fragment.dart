// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valoranttracker/fungsiku.dart' as fungsi;

class Main extends StatefulWidget {
  final String ppuid,
      Authorization,
      Entitlements,
      ClientVersion,
      ClientPlatform,
      region,
      expired;
  const Main({
    Key? key,
    required this.ppuid,
    required this.Authorization,
    required this.Entitlements,
    required this.ClientVersion,
    required this.ClientPlatform,
    required this.region,
    required this.expired,
  }) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height * 0.1;
    final tinggix = MediaQuery.of(context).size.height - tinggi - 3;
    store() async {
      final x = await fungsi.fetchStore(widget.ppuid, widget.Authorization,
          widget.Entitlements, widget.region);
      final xx = json.encode(x);
      return (jsonDecode(xx));
    }

    fragments(context) {
      if (_selectedIndex == 0) {
        return FutureBuilder(
          future: store(), // function where you call your api
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // AsyncSnapshot<Your object type>

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else
                return Container(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Daily Market : " + widget.region,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // daily market
                              Card(
                                color: Color(0xff1B2635),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Card_Gun(
                                              colors: Colors.red,
                                              title: (snapshot.data["List_Skin"]
                                                  [0])["displayName"],
                                              url: (snapshot.data["List_Skin"]
                                                  [0])["ImgUrl"],
                                            ),
                                          ),
                                          Expanded(
                                            child: Card_Gun(
                                              colors: Colors.lightBlueAccent,
                                              title: (snapshot.data["List_Skin"]
                                                  [1])["displayName"],
                                              url: (snapshot.data["List_Skin"]
                                                  [1])["ImgUrl"],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Card_Gun(
                                              colors: Colors.green,
                                              title: (snapshot.data["List_Skin"]
                                                  [2])["displayName"],
                                              url: (snapshot.data["List_Skin"]
                                                  [2])["ImgUrl"],
                                            ),
                                          ),
                                          Expanded(
                                            child: Card_Gun(
                                              colors: Colors.orange,
                                              title: (snapshot.data["List_Skin"]
                                                  [3])["displayName"],
                                              url: (snapshot.data["List_Skin"]
                                                  [3])["ImgUrl"],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 7.0),
                                child: Text(
                                  "Night Market : ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: Color(0xff1B2635),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "\n Night market is not available \n",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Active Agent : ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Card(
                                color: Color(0xff1B2635),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.black,
                                        backgroundImage: NetworkImage(
                                            'https://static.wikia.nocookie.net/valorant/images/b/b0/Reyna_icon.png/revision/latest?cb=20200607180311'),
                                        minRadius: 35,
                                        maxRadius: 45,
                                      ),
                                      Expanded(
                                        child: Wrap(
                                          children: [
                                            Stack(
                                              children: [
                                                Text(
                                                  "Reyna",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Duelist",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5, left: 5),
                                              child: Text(
                                                "Forged in the heart of Mexico, Reyna dominates single combat, popping off with each kill she scores. Her capability is only limited by her raw skill, making her highly dependent on performance.",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Wrap(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Text(
                                                        "150,000 / 975,000 XP",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, top: 5),
                                                    child:
                                                        LinearProgressIndicator(
                                                      minHeight: 5,
                                                      value: 7 / 10,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color(
                                                                  0xffFA4454)),
                                                      backgroundColor:
                                                          Colors.black,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0, left: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "level 3/10",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Card(
                                child: Text(
                                  "data\n\n\n\n\n" + "\n\n\n asdasd",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Card(
                                child: Text(
                                  "data\n\n\n\n\n" + "\n\n\n asdasd",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Card(
                                child: Text(
                                  "data\n\n\n\n\n" + "\n\n\n asdasd",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ); // snapshot.data  :- get your object which is pass from your downloadData() function
            }
          },
        );
      } else if (_selectedIndex == 1) {
        return NoResultFoundScreen();
      } else if (_selectedIndex == 2) {
        return Text("3");
      } else if (_selectedIndex == 3) {
        return Text("4");
      }
    }

    Future refresh() async {
      setState(() {
        fragments(context);
      });
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            )),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Container(
              decoration: BoxDecoration(
                color: Color(0xff0F1722),
              ),
              child: fragments(context)),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xff1B2635),
          ),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: SizedBox(
              height: tinggi,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
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
        ));
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
                color: (selected ? Color(0xFFFA4454) : Colors.white))),
        Container(
          // use aligment
          color: (selected ? Color(0xFFFA4454) : Colors.transparent),
          height: 2,
          width: 35,
        )
      ],
    );
  }
}

class Card_Gun extends StatelessWidget {
  final String url, title;
  final colors;

  const Card_Gun(
      {required this.url, required this.title, required this.colors, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      onTap: () {
        message(title, "Ini harusnya harga");
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Card(
          color: colors,
          child: Stack(
            children: [
              // Padding(  //get prices
              //   padding: const EdgeInsets.only(right: 15, top: 15),
              //   child: Align(
              //       alignment: Alignment.topRight,
              //       child: Text(
              //         "1730",
              //         style: TextStyle(fontSize: 18, color: Colors.white),
              //       )),
              // ),
              Transform.rotate(
                angle: -12,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoResultFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://raw.githubusercontent.com/abuanwar072/20-Error-States-Flutter/master/assets/images/2_404%20Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.14,
            left: MediaQuery.of(context).size.width * 0.065,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.17),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
