# 🔑 Keys Demo – Widget, State & Keys

A tiny Flutter app used to explain **the relationship between a Widget and its State** and **why Keys matter**.

## Run
```bash
cd flutter-course-section-5/keys
flutter pub get
flutter run
```

## What it shows
- A list of `WriteComment` fields (Apple, Banana, Cherry), each a `StatefulWidget`.
- A delete button removes the **first** item.

## Widget vs State
- A **Widget** is only a configuration. It's cheap and gets rebuilt often.
- A **State** is a separate object that Flutter keeps alive and attaches to a widget in the tree.
- When the tree rebuilds, Flutter decides which old State belongs to which new widget.

## Why Keys?
Without a key, Flutter matches State to widgets by **type and position only**.
Remove the first item, and the remaining widgets shift up, but their States don't. So the text you typed (or a checked box) ends up on the **wrong item**, and the **last** State is the one disposed.

With a key, Flutter matches each State to the **right** widget:

```dart
for (final item in items) WriteComment(key: ValueKey(item), title: item),
```

| Key type      | Identity based on              |
|---------------|--------------------------------|
| `ValueKey`    | A value (e.g. the item's text) |
| `ObjectKey`   | An object's identity           |
| `UniqueKey`   | A brand-new key every build (State is recreated each time) |

## Try it yourself
1. Type something in each field, then press delete. Watch the console for `we are out from ...`.
2. Remove `key: ValueKey(item)` and repeat. Which State was disposed now?
3. Swap `WriteComment` for `CheckItem` (add `super.key` to it first), then try `ObjectKey` and `UniqueKey`.
