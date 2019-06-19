# Localstorage

Simple json file-based storage for flutter

> Support me

![GitHub stars](https://img.shields.io/github/stars/lesnitsky/flutter_localstorage.svg?style=social)
![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_a.svg?label=Follow%20me&style=social)

## Installation

Add dependency to `pubspec.yaml`

```yaml
dependencies:
  ...
  localstorage: ^2.0.0
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

## Integration tests

```sh
cd ~/flutter_localstorage/test
flutter packages get
flutter drive --target=lib/main.dart
```

## License

MIT

## Support me

![GitHub stars](https://img.shields.io/github/stars/lesnitsky/flutter_localstorage.svg?style=social)
![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_a.svg?label=Follow%20me&style=social)
