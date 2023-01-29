import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trackmyvalorant/network/fungsiku.dart' as fungsi;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstFragment extends StatefulWidget {
  final Map<String, String> header;

  const FirstFragment({
    Key? key,
    required this.header,
  }) : super(key: key);

  @override
  State<FirstFragment> createState() => _FirstFragment();
}

class _FirstFragment extends State<FirstFragment> {
  @override
  Widget build(BuildContext context) {
    store() async {
      final x = await fungsi.fetchStore(widget.header);
      final contract = (await fungsi.contract(widget.header));
      final agentcontract = contract["Contracts"];

      List data = [];
      var getagent = await fungsi.agentcontract;
      for (var i = 0; i < getagent.length; i++) {
        if (getagent[i]['content']['relationType'] == "Agent") {
          var agents = {
            'uuid': getagent[i]['uuid'],
            'agentuuid': getagent[i]['content']['relationUuid'],
            'displayName': getagent[i]['displayName'],
            'ProgressionLevelReached': agentcontract[i]
                ['ProgressionLevelReached'],
            'ProgressionTowardsNextLevel': agentcontract[i]
                ['ProgressionTowardsNextLevel'],
            'level': getagent[i]['content']['chapters'][0]['levels'] +
                getagent[i]['content']['chapters'][1]['levels'],
          };

          data.add(agents);
        }
      }
      List dailymission = [];
      List weeklymission = [];
      for (int i = 0; i < contract['Missions'].length; i++) {
        var xam = await fungsi.getmission(contract['Missions'][i]['ID']);

        // "type": xam['type'],
        var missinya = {
          "ID": contract['Missions'][i]['id'],
          "Title": xam['title'],
          "xpGrant": xam['xpGrant'],
          "ongoing": contract['Missions'][i]['Objectives']
              [xam['objectives'][0]['objectiveUuid']],
          "progressToComplete": xam['progressToComplete'],
          "status": contract['Missions'][i]['Complete'],
        };
        if (xam['type'] == "EAresMissionType::Daily") {
          missinya['type'] = xam['type'];
          dailymission.add(missinya);
        } else if (xam['type'] == "EAresMissionType::Weekly") {
          missinya['type'] = xam['type'];
          weeklymission.add(missinya);
        }
      }
      var xa = (data.firstWhere((book) =>
          book['uuid'] == contract['ActiveSpecialContract'])['agentuuid']);

      var dataku = {
        "dailyskin": x,
        "contracts": data,
        "missions": dailymission,
        "weeklymissions": weeklymission,
        "ActiveSpecialContract": await fungsi.agent(xa),
        "activedcontract": (data.firstWhere(
            (book) => book['uuid'] == contract['ActiveSpecialContract']))
      };
      return (jsonDecode(jsonEncode(dataku)));
    }

    return FutureBuilder(
      future: store(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          //hapus ntar
                          "Daily Market : ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // daily market
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: const Color(0xff1B2635),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  for (var i = 0; i < 2; i++)
                                    Expanded(
                                      child: Shimmer.fromColors(
                                        baseColor: const Color(0xff141C27),
                                        highlightColor: const Color(0x33141C27),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            color: Color(0xff141C27),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  for (var i = 2; i < 4; i++)
                                    Expanded(
                                      child: Shimmer.fromColors(
                                        baseColor: const Color(0xff141C27),
                                        highlightColor: const Color(0x33141C27),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            color: Color(0xff141C27),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 7.0),
                        child: Text(
                          "Night Market ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color(0xff1B2635),
                        highlightColor: const Color(0x331B2635),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color(0xff1B2635),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 7.0),
                        child: Text(
                          "Active Agent ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color(0xff1B2635),
                        highlightColor: const Color(0x331B2635),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.135,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Color(0xff1B2635),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 7.0, bottom: 5.0),
                        child: Text(
                          "Missions ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: const Color(0xff1B2635),
                        highlightColor: const Color(0x331B2635),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color(0xff1B2635),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Color> colors = <Color>[
              const Color(0xff84D2C5),
              const Color(0xffE4C988),
              const Color(0xffC27664),
              const Color(0xffB05A7A)
            ];

            return CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            //hapus ntar
                            "Daily Market : ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // daily market
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: const Color(0xff1B2635),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    for (var i = 0; i < 2; i++)
                                      Expanded(
                                        child: CardGun(
                                          colors: Color(int.parse(
                                              "0x33${snapshot.data['dailyskin']['skins'][i]['Tier']['highlightColor']}")),
                                          title: snapshot.data['dailyskin']
                                              ['skins'][i]['displayName'],
                                          url: snapshot.data['dailyskin']
                                              ['skins'][i]['ImgUrl'],
                                          rarity: snapshot.data['dailyskin']
                                                  ['skins'][i]['Tier']
                                              ['displayIcon'],
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    for (var i = 2; i < 4; i++)
                                      Expanded(
                                        child: CardGun(
                                          colors: Color(int.parse(
                                              "0x33${snapshot.data['dailyskin']['skins'][i]['Tier']['highlightColor']}")),
                                          title: snapshot.data['dailyskin']
                                              ['skins'][i]['displayName'],
                                          url: snapshot.data['dailyskin']
                                              ['skins'][i]['ImgUrl'],
                                          rarity: snapshot.data['dailyskin']
                                                  ['skins'][i]['Tier']
                                              ['displayIcon'],
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Text(
                            "Night Market ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xff1B2635),
                          child: const Text(
                            textAlign: TextAlign.center,
                            "\n Night market is not available \n",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Text(
                            "Active Agent ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Card(
                          color: const Color(0xff1B2635),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(
                                        snapshot.data['ActiveSpecialContract']
                                            ['data']['displayIconSmall']),
                                    minRadius: 35,
                                    maxRadius: 45,
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      children: [
                                        Stack(
                                          children: [
                                            Text(
                                              snapshot.data[
                                                      'ActiveSpecialContract']
                                                  ['data']['displayName'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child: ImageIcon(
                                                      NetworkImage(snapshot
                                                                      .data[
                                                                  'ActiveSpecialContract']
                                                              ['data']['role']
                                                          ['displayIcon']),
                                                      color: const Color(
                                                          0xFFFFFFFF),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0),
                                                    child: Text(
                                                      snapshot.data[
                                                                  'ActiveSpecialContract']
                                                              ['data']['role']
                                                          ['displayName'],
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15, left: 5),
                                          child: Text(
                                            snapshot.data[
                                                    'ActiveSpecialContract']
                                                ['data']['description'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Wrap(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Text(
                                                    "${snapshot.data['activedcontract']['ProgressionTowardsNextLevel']} / ${snapshot.data['activedcontract']['level'][snapshot.data['activedcontract']['ProgressionLevelReached']]['xp']} XP",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: LinearProgressIndicator(
                                                  minHeight: 5,
                                                  value: snapshot.data[
                                                              'activedcontract'][
                                                          'ProgressionTowardsNextLevel'] /
                                                      snapshot.data[
                                                              'activedcontract']
                                                          ['level'][snapshot.data[
                                                              'activedcontract']
                                                          ['ProgressionLevelReached']]['xp'],
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(0xffFA4454)),
                                                  backgroundColor: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0, left: 5),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    "level ${snapshot.data['activedcontract']['ProgressionLevelReached']}/10",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
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
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 7.0, bottom: 5.0),
                          child: Text(
                            "Missions ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: const Color(0xFF1B2635),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                //daily
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Daily :",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),

                                for (var i = 0;
                                    i < snapshot.data['missions'].length;
                                    i++)
                                  Missions(
                                    type: snapshot.data['missions'][i]['type'],
                                    title: snapshot.data['missions'][i]
                                        ['Title'],
                                    progresstart: snapshot.data['missions'][i]
                                        ['ongoing'],
                                    progressend: snapshot.data['missions'][i]
                                        ['progressToComplete'],
                                    xpGrant: snapshot.data['missions'][i]
                                            ['xpGrant']
                                        .toString(),
                                  ),

                                //weekly
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Weekly :",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),

                                for (var i = 0;
                                    i < snapshot.data['weeklymissions'].length;
                                    i++)
                                  Missions(
                                    type: snapshot.data['weeklymissions'][i]
                                        ['type'],
                                    title: snapshot.data['weeklymissions'][i]
                                        ['Title'],
                                    progresstart: snapshot
                                        .data['weeklymissions'][i]['ongoing'],
                                    progressend: snapshot.data['weeklymissions']
                                        [i]['progressToComplete'],
                                    xpGrant: snapshot.data['weeklymissions'][i]
                                            ['xpGrant']
                                        .toString(),
                                  ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } // dataku  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
}

class CardGun extends StatelessWidget {
  final String url, title, rarity;
  final Color colors;

  const CardGun(
      {required this.url,
      required this.title,
      required this.colors,
      required this.rarity,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    void message(String errTitle, String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(errTitle),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("okay"),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        message(title, "Ini harusnya harga");
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
            side: BorderSide(
              color: colors,
              width: 3,
            ),
          ),
          color: colors,
          child: Stack(
            children: [
              /*    const Padding(
                //get prices
                padding: EdgeInsets.only(right: 10, top: 5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("asdasd"),
                ),
              ), */
              Center(
                child: Transform.rotate(
                  angle: -12.1,
                  child: Image.network(url, fit: BoxFit.cover),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      //get prices
                      padding: const EdgeInsets.only(right: 10, bottom: 5),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Image.network(rarity,
                            width: 35, height: 35, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Missions extends StatelessWidget {
  final String type, title, xpGrant;
  final int progresstart, progressend;

  const Missions(
      {required this.type,
      required this.title,
      required this.progresstart,
      required this.progressend,
      required this.xpGrant,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assets = type == "EAresMissionType::Daily"
        ? "assets/images/icons/daily.svg"
        : "assets/images/icons/weekly.svg";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
      child: Wrap(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            assets,
                            color: Colors.white,
                            height: 25,
                            width: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                title,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.end,
                              "$progresstart / $progressend",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              minHeight: 8,
                              value: progresstart / progressend,
                              color: const Color(0xffFA4454),
                              backgroundColor: const Color(0x33000000),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "+ $xpGrant",
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xff22FEC5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
