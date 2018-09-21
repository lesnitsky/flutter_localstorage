# Localstorage

Simple json file-based storage for flutter

## Installation

`pubspec.yaml`

```yaml
dependencies:
  ...
  localstorage:
    git: https://github.com/lesnitsky/flutter_localstorage.git
```

```sh
flutter packages get
```

## API

### `new LocalStorage(String: key)`

Creates instance of a local storage. Key is used as a filename

### `Future<void> setItem(String key, dynamic value)`

Saves item by key to a storage. Value should be json encodable (`json.encode()` is called under the hood).

### `getItem(String key)`

Returns a value from storage by key

### `Future<void> deleteItem(String key)`

Removes item from storage by key

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

## License

MIT
