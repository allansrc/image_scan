import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_scan/image_scan.dart';

void main() {
  const MethodChannel channel = MethodChannel('image_scan');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ImageScan.platformVersion, '42');
  });
}
