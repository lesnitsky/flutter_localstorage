# LocalStorage

[LocalStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) for Flutter.

> [!IMPORTANT]  
> LocalStorage is not intended to store large amounts or sensitive data.

[<img src="https://badges.globeapp.dev/twitter" height="40px" />](https://twitter.com/lesnitsky_dev)
[<img src="https://badges.globeapp.dev/github?owner=lesnitsky&repository=flutter_localstorage" height="40px" />](https://github.com/lesnitsky/flutter_localstorage)

## Installation

```sh
flutter pub add localstorage
```

or add dependency to `pubspec.yaml` manually

```yaml
dependencies:
  localstorage: ^5.0.0
```

## API docs

[LocalStorage API documentation](https://pub.dev/documentation/localstorage/latest/localstorage/LocalStorage-class.html)

## Usage

```dart
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
```

## License

MIT

[<img src="https://badges.globeapp.dev/twitter" height="40px" />](https://twitter.com/lesnitsky_dev)
[<img src="https://badges.globeapp.dev/github?owner=lesnitsky&repository=flutter_localstorage" height="40px" />](https://github.com/lesnitsky/flutter_localstorage)
