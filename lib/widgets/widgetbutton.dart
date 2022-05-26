import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton(
      {Key? key,
      required this.name,
      required this.size,
      required this.color,
      required this.function})
      : super(key: key);
  final String name;
  final Size size;
  final Color color;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
            color: Colors.transparent,
            elevation: 20,
            child: Container(
                width: size.width * 0.8,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), color: color),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ))),
        onTap: () {
          function();
        });
  }
}
