// ignore_for_file: public_member_api_docs

/// @nodoc
library test_driver;

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(MyApp());
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

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String assertTxt = '', tputTxt = '';

  bool assertEnabled = true, tputEnabled = true;

  @override
  Widget build(_) => MaterialApp(home: home);

  Widget get home => Scaffold(appBar: appBar, body: body, bottomNavigationBar: bottomBar);

  Widget get appBar => AppBar(title: Text('Integration Test'));

  Widget get body {
    return Center(
        child: Column(children: [...assertTest, Divider(), ...tputTest ],
      ),
    );
  }

  Widget get bottomBar => BottomAppBar(child: Row());

  List<Widget> get assertTest {
    return [
      Text('ASSERT TEST'),
      IconButton(
          key: Key('assertBtn'),
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            if (!assertEnabled) {
              return;
            }
            assertEnabled = false;

            TestSuite.assertTest()
                .then((res) => setState(() => assertTxt = res))
                .catchError((dynamic e) => setState(() => assertTxt = '$e'))
                .whenComplete(() => setState(() => assertEnabled = true));
          }),
      Text(assertTxt, key: Key('assertTxt')),
    ];
  }

  List<Widget> get tputTest {
    return [
      Text('THROUGHPUT TEST'),
      IconButton(
          key: Key('tputBtn'),
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            if (!tputEnabled) {
              return;
            }
            tputEnabled = false;

            TestSuite.tputTest()
                .then((res) => setState(() => tputTxt = res))
                .catchError((dynamic e) => setState(() => tputTxt = '$e'))
                .whenComplete(() => setState(() => tputEnabled = true));
          }),
      Text(tputTxt, key: Key('tputTxt')),
    ];
  }
}
