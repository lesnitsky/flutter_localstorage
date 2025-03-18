# 6.0.0

- WASM support by [@jezel](https://x.com/jezell)

# 5.0.0

- Migrate to synchronous API and make API consistent with web `window.localStorage`

# 4.0.1+2

- dispose open files on reload

## 3.0.6+9

- fix wrong truncate size (use utf8.encode)

## 3.0.5+8

- fix an issue with initial storage creation

## 3.0.4+7

- fix [#43 Error on init - Unexpected end of input (at character 1) ^](https://github.com/lesnitsky/flutter_localstorage/issues/43)

## 3.0.2+5

- fix `clear()` (drops data only from a storage instance, not all storages)

## 3.0.1+4

- fix `remove(key)` (drops value from in-memory cache)

## 3.0.0

### Breaking changes (desktop only)

Application document directory is no longer `Platform['HOME']/.config` as `path_provider` has desktop support with `path_provider_fde`.

In order to be able to use this package on desktop, add this to your `pubspec.yaml`

```pubspec.yaml
dependencies:
  localstorage: ^3.0.0
  path_provider_fde:
    git:
      url: https://github.com/google/flutter-desktop-embedding/
      path: plugins/flutter_plugins/path_provider_fde
```

See https://github.com/google/flutter-desktop-embedding/tree/master/plugins/flutter_plugins for more details

### Features

- support web (kudos to [@AppleEducate](https://github.com/AppleEducate))
- add [LocalStorage.stream] which receives new storage values after modifications

### Bug fixes

- flush writes to fs

### Misc

- use async read/writes instead of sync

## 2.0.0

- fix inconsistent return format of `getItem`. It now always returns `JsonEncodable` representation of an item
- add optional `toEncodable` arg to `setItem`

## 1.3.1

- update `README.md` documentation
- bump `package_provider` dependency to address `getApplicationSupportDirectory`
- fix `noSuchMethodError` in `_flush`

## 1.3.0

- add optional `path`argument to specify storage folder
- fixes for flutter-desktop-embedding

## 1.2.0

- add `clear` method

## 1.1.0

- add `onError` property (`ValueNotifier` which emits errors)

## 1.0.1

- Add example application

## 1.0.0

- Initial release
