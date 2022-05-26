import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';

class WidgetInput extends StatelessWidget {
  const WidgetInput(
      {Key? key,
      required this.name,
      required this.icon,
      required this.controller})
      : super(key: key);
  final String name;
  final IconData icon;
  final dynamic controller;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        name.toUpperCase(),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.6)),
      ),
      SizedBox(
        height: 10,
      ),
      TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: name,
              border: InputBorder.none)),
      Container(height: 1, color: AppColors.BACKGROUND),
      SizedBox(height: 4)
    ]);
  }
}
