import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';

class EstablishView extends StatefulWidget {
  const EstablishView({Key? key}) : super(key: key);

  @override
  State<EstablishView> createState() => _EstablishViewState();
}

class _EstablishViewState extends State<EstablishView> {
  double time = 25;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.BACKGROUND,
        title: Text("Thiết lập"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Container(
            width: double.maxFinite,
            child: CupertinoSlider(
                min: 10,
                max: 50,
                value: time,
                activeColor: AppColors.BACKGROUND,
                thumbColor: AppColors.BACKGROUND,
                divisions: 8,
                onChanged: (value) {
                  setState(() {
                    time = value;
                  });
                })),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
