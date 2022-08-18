import 'package:flutter/material.dart';

import 'navigation_drawer_widget.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationDrawerWidget(context),
      appBar: AppBar(
        title: Text('사장님'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('홈 입니다'),
        ],
      )
    );
  }
}
