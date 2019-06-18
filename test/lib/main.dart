// ignore_for_file: public_member_api_docs

/// @nodoc
library test_app;

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(TestApp());
}

class TestSuite {
  static Future<String> assertTest() async {
    await Future.delayed(Duration(seconds: 5));

    return 'assert test completed successfully';
  }

  static Future<String> tputTest() async {
    final t0 = DateTime.now();

    await Future.delayed(Duration(seconds: 5));

    final int eventCount = 1000;
    final t1 = DateTime.now();

    final eventTput = eventCount / t1.difference(t0).inSeconds;
    print('throughput: ${eventTput.toStringAsFixed(2)} eps');

    assert(eventTput >= 100);

    return 'tput test completed successfully';
  }
}

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestAppState();
  }
}

class TestAppState extends State<TestApp> {
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
    final icon = Icon(Icons.play_arrow);

    final handler = () {
      if (!assertEnabled) {
        return;
      }

      assertEnabled = false;

      TestSuite.assertTest()
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
    final icon = Icon(Icons.play_arrow);

    final handler = () {
      if (!tputEnabled) {
        return;
      }

      tputEnabled = false;

      TestSuite.tputTest()
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
