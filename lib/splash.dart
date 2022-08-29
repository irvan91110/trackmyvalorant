import 'package:flutter/material.dart';

class splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F1722),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/logo_loginbg.png"),
                fit: BoxFit.fill),
          ),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset("assets/images/ic_valogo.png"),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "powered by iirvanard",
                    style: TextStyle(
                        color: Color(0xffFA4454),
                        fontStyle: FontStyle.italic,
                        fontSize: 17.5,
                        height: 5),
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
