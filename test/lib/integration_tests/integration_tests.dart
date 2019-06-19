// ignore_for_file: public_member_api_docs

/// @nodoc
library integration_tests;

import 'dart:convert';
import 'dart:math';

import 'package:localstorage/localstorage.dart';

class IntegrationTests {
  IntegrationTests.private();

  static final _seed = Random.secure();

  static Future<String> assertTest() async {
    const filesAtOnce = 150;

    final keys = List.generate(filesAtOnce, (_) => _randomTxt);

    await Future.wait(keys.map((key) => _basicTest(key)));

    const msg = 'assert test completed successfully';

    print(msg);
    return msg;
  }

  static Future<String> tputTest() async {
    final mapsPerItem = 26666;
    final itemsPerFile = 1;
    final filesAtOnce = 20;

    final m = (_) => <String, dynamic>{'num': _randomNum, 'txt': _randomTxt};
    final item = (_) => <String, dynamic>{'map': List.generate(mapsPerItem, m)};
    final items = () => List.generate(itemsPerFile, item);
    final file = (_) => <String, dynamic>{'key': _randomTxt, 'items': items()};

    final buffer = List.generate(filesAtOnce, file);
    final totalBytes = utf8.encode(json.encode(buffer)).length * 1.0;

    final t0 = DateTime.now();
    await Future.wait(buffer.map((b) => _writeTest(b)));

    final writeSecs = DateTime.now().difference(t0).inMilliseconds * 0.001;

    final mbps = (totalBytes / writeSecs * 0.000001).toStringAsFixed(3);

    print(' \n \nWRITE THROUGHPUT: $mbps MB/s\n ');

    final keys = buffer.map((b) => b['key'] as String);

    final t1 = DateTime.now();
    final res = await Future.wait(keys.map((k) => _readTest(k, itemsPerFile)));

    final readSecs = DateTime.now().difference(t1).inMicroseconds * 0.000001;
    final readBytes = utf8.encode(json.encode(res)).length * 1.0;

    final gbps = (readBytes / readSecs * 0.000000001).toStringAsFixed(3);
    print(' \n \nREAD THROUGHPUT: $gbps GB/s\n ');

    final benchmark = '$mbps MB/s (w) - $gbps GB/s (r)';
    final msg = 'throughput test completed successfully\n$benchmark';

    print(readBytes/filesAtOnce);

    print(msg);
    return msg;
  }

  static Future<void> _basicTest(String key) async {
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
  }

  static Future<void> _writeTest(Map<String, dynamic> file) async {
    String key = file['key'];
    List<Map<String, dynamic>> items = file['items'];

    final storage = LocalStorage(key);

    await storage.ready;

    for (int i = 0; i < items.length; ++i) {
      await storage.setItem('$i', items[i]);
    }
  }

  static Future<List<dynamic>> _readTest(String key, int n) {
    return Future.wait(List<Future<dynamic>>.generate(n, (i) async {
      return (await LocalStorage(key).getItem('$i'));
    }));
  }

  static int get _randomNum => _seed.nextInt(1 << 32);
  static String get _randomTxt => _randomNum.toString();
}
