// ignore_for_file: public_member_api_docs

/// @nodoc
library test_app;

import 'package:flutter/material.dart';

import '../integration_tests/integration_tests.dart';

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAppState();

  void run() => runApp(this);
}

class _TestAppState extends State<TestApp> {
  String assertTxt = '', tputTxt = '';

  bool assertEnabled = true, tputEnabled = true;

  @override
  Widget build(_) {
    return MaterialApp(home: home);
  }

  Widget get home {
    return Scaffold(appBar: appBar, body: body, bottomNavigationBar: bottomBar);
  }

  Widget get appBar {
    return AppBar(title: Text('Integration Test'));
  }

  Widget get bottomBar {
    return BottomAppBar(child: Row());
  }

  Widget get body {
    return Center(child: column);
  }

  Widget get column {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: []..addAll(assertTest)..addAll(tputTest),
    );
  }

  List<Widget> get assertTest {
    const icon = Icon(Icons.play_arrow);

    final handler = () {
      if (!assertEnabled) {
        return;
      }

      assertEnabled = false;

      IntegrationTests.assertTest()
          .then((res) => setState(() => assertTxt = res))
          .catchError((dynamic e) => setState(() => assertTxt = '$e'))
          .whenComplete(() => setState(() => assertEnabled = true));
    };

    return [
      Text('ASSERT TEST'),
      IconButton(key: Key('assertBtn'), icon: icon, onPressed: handler),
      Text(assertTxt, key: Key('assertTxt')),
      Divider()
    ];
  }

  List<Widget> get tputTest {
    const icon = Icon(Icons.play_arrow);

    final handler = () {
      if (!tputEnabled) {
        return;
      }

      tputEnabled = false;

      IntegrationTests.tputTest()
          .then((res) => setState(() => tputTxt = res))
          .catchError((dynamic e) => setState(() => tputTxt = '$e'))
          .whenComplete(() => setState(() => tputEnabled = true));
    };

    return [
      Text('THROUGHPUT TEST'),
      IconButton(key: Key('tputBtn'), icon: icon, onPressed: handler),
      Text(tputTxt, key: Key('tputTxt')),
    ];
  }
}
