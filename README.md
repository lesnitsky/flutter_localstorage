# Localstorage

Simple json file-based storage for flutter

[![GitHub stars](https://img.shields.io/github/stars/lesnitsky/flutter_localstorage.svg?style=social)](https://github.com/lesnitsky/flutter_localstorage)
[![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_a.svg?label=Follow%20me&style=social)](https://twitter.com/lesnitsky_a)
[![lesnitsky.dev](https://lesnitsky.dev/icons/shield.svg?hash=42)](https://lesnitsky.dev?utm_source=flutter_localstroage)

## Installation

Add dependency to `pubspec.yaml`

```yaml
dependencies:
  ...
  localstorage: ^3.0.0
```

Run in your terminal

```sh
flutter packages get
```

## Example

```dart
class SomeWidget extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('some_key');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == true) {
          Map<String, dynamic> data = storage.getItem('key');

          return SomeDataView(data: data);
        } else {
          return SomeLoadingStateWidget();
        }
      },
    );
  }
}
```

## V2 -> v3 migration

V3 doesn't add `.json` extension to a storage filename, so you need to do this on your own if you need a "migration".
If you were using v2 with code like below:

```dart
final storage = new LocalStorage('my_data');
```

v3 equivalent:

```dart
final storage = new LocalStorage('my_data.json')
```

## Integration tests

```sh
cd ~/flutter_localstorage/test
flutter packages get
flutter drive --target=lib/main.dart
```

## License

MIT

[![GitHub stars](https://img.shields.io/github/stars/lesnitsky/flutter_localstorage.svg?style=social)](https://github.com/lesnitsky/flutter_localstorage)
[![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_a.svg?label=Follow%20me&style=social)](https://twitter.com/lesnitsky_a)
[![lesnitsky.dev](https://lesnitsky.dev/icons/shield.svg?hash=42)](https://lesnitsky.dev?utm_source=flutter_localstroage)
