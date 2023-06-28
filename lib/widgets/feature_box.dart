import 'package:flutter/material.dart';
import 'package:voice_assisant/constants/pallete.dart';


class FeatureBox extends StatelessWidget {
  FeatureBox({super.key, this.color, this.title, this.description});
  String? title;
  String? description;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color!,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title!,
              style: const TextStyle(
                color: Pallete.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description!,
              style: const TextStyle(
                color: Pallete.blackColor,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}