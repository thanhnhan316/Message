import 'package:flutter/material.dart';

class AllReviewView extends StatefulWidget {
  const AllReviewView({Key? key}) : super(key: key);

  @override
  State<AllReviewView> createState() => _AllReviewViewState();
}

class _AllReviewViewState extends State<AllReviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: buildBody());
  }

  Widget buildBody() {
    return Container();
  }
}
