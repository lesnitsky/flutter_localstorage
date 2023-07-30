# Localstorage

Simple json file-based storage for Flutter that works on all platforms.

[<img src="https://badges.globeapp.dev/twitter" height="40px" />](https://twitter.com/lesnitsky_dev)
[<img src="https://badges.globeapp.dev/github?owner=lesnitsky&repository=flutter_localstorage" height="40px" />](https://github.com/lesnitsky/flutter_localstorage)

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

## Basic features

- Add an item:

```dart
await storage.setItem("key", "dynamic value");
```

- Delete an item:

```dart
await storage.deleteItem("key");
```

- Get an item:

```dart
dynamic value = storage.getItem("key");
```

## Stream and helper features

- Get the size of the JSON file

```dart
int bytes = await storage.getStorageSize();
```

- Receive notifications

```dart
storage.stream.listen((e) {
  if (e.containsKey("itemWasSet")) {
    print("an item was set");
  } else if (e.containsKey("itemWasRemoved")) {
    print("an item was removed".);
  } else if (e.containsKey("size")) {
    print("The JSON file was re-written");
    int bytes = e['size'];
    print("And it contains $bytes bytes");
  }
});
```

## Control over performance

The way it works is that `LocalStorage` stores all the data in a single variable of type `Map<String, dynamic>`, and everytime you update this map, a JSON file, whose name is the key you give when creating an instance of `LocalStorage`, is re-written from zero.

Therefore, when storing a big amount of data progressively, you do not want to call `setItem()` or `deleteItem()` multiple times, because the action of re-writing an entire file may take some time.

There is now the possibility to control when the file should be re-written : 

```dart
// The key "some_data" will be accessible to you when using `getItem()`.
// However, it will not be saved on the JSON file,
// (not stored locally)
// making this action faster.
await storage.setItem("some_data", "E=mc2", write: false);
```

Obviously, you need to save that data on the JSON file at some point. Well, at the end of your big computations, you can just call this method:

```dart
await storage.writeData();
```

And now all the changes you made to `storage` will be saved locally.

To delete data, it's different. If you call `deleteItem(String key)` then the JSON file will be re-written automatically. To delete multiple items, you must use `deleteItems(List<String> keys)`, which is much more efficient than looping over the keys and calling `deleteItem()` multiple times.

> **NOTE**: to avoid the error: "an asynchronous task is already pending" it would be better to always await a call to `deleteItem()`, `deleteItems()` and `setItem()` when `write` is set to `true`.

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

[<img src="https://badges.globeapp.dev/twitter" height="40px" />](https://twitter.com/lesnitsky_dev)
[<img src="https://badges.globeapp.dev/github?owner=lesnitsky&repository=flutter_localstorage" height="40px" />](https://github.com/lesnitsky/flutter_localstorage)
