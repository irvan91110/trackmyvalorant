import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class shimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.white70,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(
                // Set border color
                width: 3.0), // Set border width
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0)), // Set rounded corner radius
          ),
          child: Text("My demo styling"),
        ),
      ),
    );
  }
}
