import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

late final ValueNotifier<int> notifier;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  notifier = ValueNotifier(int.parse(localStorage.getItem('counter') ?? '0'));
  notifier.addListener(() {
    localStorage.setItem('counter', notifier.value.toString());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: notifier,
            builder: (context, value, child) {
              return Text('Pressed $value times');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            notifier.value++;
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
