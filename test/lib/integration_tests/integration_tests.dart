// ignore_for_file: public_member_api_docs

/// @nodoc
library integration_tests;

import 'dart:math';

import 'package:localstorage/localstorage.dart';

class IntegrationTests {
  static Future<String> assertTest() async {
    final key = _randomTxt;

    // write a sample map
    await (() async {
      final storage = LocalStorage(key);

      await storage.ready;

      await storage.setItem(key, {'$key': key});
    })();

    // assert sample map can be read correctly
    await (() async {
      final storage = LocalStorage(key);

      await storage.ready;

      Map<String, dynamic> ref = {'$key': key};
      Map<String, dynamic> res = await storage.getItem(key);

      assert(res[key] == ref[key]);
    })();

    // delete sample map
    await (() async {
      final storage = LocalStorage(key);

      await storage.ready;

      await storage.deleteItem(key);
    })();

    // assert map cannot be read anymore
    await (() async {
      final storage = LocalStorage(key);

      await storage.ready;

      assert(await storage.getItem(key) == null);
    })();

    const msg = 'assert test completed successfully';

    print(msg);
    return msg;
  }

  static Future<String> tputTest() async {
    final t0 = DateTime.now();

    await Future.delayed(Duration(seconds: 5));

    final int eventCount = 1000;
    final t1 = DateTime.now();

    final eventTput = eventCount / t1.difference(t0).inSeconds;
    print('throughput: ${eventTput.toStringAsFixed(2)} eps');

    assert(eventTput >= 100);

    const msg = 'tput test completed successfully';

    print(msg);
    return msg;
  }

  static String get _randomTxt {
    final random = Random.secure();

    return random.nextInt(1000000000).toString();
  }
}
