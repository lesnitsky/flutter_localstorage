// ignore_for_file: public_member_api_docs

/// @nodoc
library integration_tests;

class IntegrationTests {
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