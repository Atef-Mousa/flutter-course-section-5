# 🛒 Flutter Course – Section 5: Shopping App (Navigation & Forms)

A small, beginner-friendly Flutter app built for **Section 5** of the Flutter course.
It shows how a real app moves between screens, protects pages behind a login, and validates user input with forms.

> **Repository:** https://github.com/Atef-Mousa/flutter-course-section-5

---

## 📑 Table of Contents

1. [What You Will Learn](#-what-you-will-learn)
2. [Getting Started](#-getting-started)
3. [Project Structure](#-project-structure)
4. [App Flow](#-app-flow)
5. [Core Concepts](#-core-concepts)
   - [StatefulWidget & Lifecycle](#1-statefulwidget--lifecycle)
   - [Forms & Validation](#2-forms--validation)
   - [TextEditingController & dispose()](#3-texteditingcontroller--dispose)
   - [Routing with go_router](#4-routing-with-go_router)
   - [go vs push vs pop](#5-go-vs-push-vs-pop)
   - [Route Guard with redirect](#6-route-guard-with-redirect)
   - [Fake Database with static](#7-fake-database-with-static)
   - [Keys & super.key](#8-keys--superkey)
   - [const Constructors](#9-const-constructors)
   - [Private Members with _](#10-private-members-with-_)
6. [Student Task](#-student-task)
7. [Common Errors](#-common-errors)
8. [Resources](#-resources)

---

## 🎯 What You Will Learn

- Building screens with `StatefulWidget` and understanding `initState()` / `dispose()`
- Creating forms with `Form`, `TextFormField`, `GlobalKey<FormState>` and `validator`
- Reading input with `TextEditingController` and cleaning it up correctly
- Declarative navigation with **go_router**: top-level and nested routes
- The difference between `context.go()`, `context.push()` and `context.pop()`
- Protecting pages with a `redirect` (route guard)
- Writing clean, efficient widgets using `const`, `super.key` and private members

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Dart `^3.13.1` or newer)
- An IDE: Android Studio or VS Code with the Flutter extension
- An emulator, a physical device, or Chrome

### Run the project
```bash
git clone https://github.com/Atef-Mousa/flutter-course-section-5.git
cd flutter-course-section-5/full_shopping_app
flutter pub get
flutter run
```

### Test account
| Username | Password    |
|----------|-------------|
| `Atef`   | `Atef12345` |

### Dependencies
| Package      | Purpose                         |
|--------------|---------------------------------|
| `go_router`  | Declarative routing/navigation  |

---

## 📁 Project Structure

```
lib/
├── main.dart            # App entry point – MaterialApp.router
├── router.dart          # All routes + login guard (redirect)
├── login_page.dart      # Login form with validation
├── home_page.dart       # Home screen (protected)
├── products_page.dart   # Products screen (nested under /home)
└── test.dart            # Fake "Database" class (static values)
```

| File                 | Responsibility |
|----------------------|----------------|
| `main.dart`          | Starts the app and connects the `router` to `MaterialApp.router`. |
| `router.dart`        | Defines `/login`, `/home`, `/home/products` and blocks `/home…` when not logged in. |
| `login_page.dart`    | Validates input, checks it against `Database`, then navigates to Home. |
| `home_page.dart`     | Simple protected page. |
| `products_page.dart` | Nested page that lives under `/home`. |
| `test.dart`          | Holds `username`, `password` and `isLoggedIn` as `static` fields. |

---

## 🔀 App Flow

```
        ┌─────────────┐   valid + correct    ┌─────────────┐   push    ┌──────────────────┐
 start →│   /login    │ ───── go ──────────► │    /home    │ ────────► │  /home/products  │
        └─────────────┘                      └─────────────┘ ◄──pop─── └──────────────────┘
               ▲                                    │
               └──── redirect (not logged in) ──────┘
```

1. The app opens on `/login` (`initialLocation`).
2. The user fills the form. If validation passes and the info matches `Database`, then `isLoggedIn = true` and the app goes to `/home`.
3. If someone tries to open `/home` (or anything under it) without logging in, the `redirect` sends them back to `/login`.

---

## 📚 Core Concepts

### 1. StatefulWidget & Lifecycle

A `StatefulWidget` is split into two classes: the **widget** (configuration) and the **State** (data that can change + `build`).

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();       // runs ONCE when the page is created
  }

  @override
  void dispose() {
    super.dispose();         // runs ONCE when the page is removed
  }

  @override
  Widget build(BuildContext context) => const Placeholder();
}
```

| Method        | When it runs                          | Use it for |
|---------------|---------------------------------------|------------|
| `initState()` | Once, when the State is created       | Initial setup |
| `build()`     | Every time the UI needs to redraw     | Returning the UI |
| `dispose()`   | Once, when the State is destroyed     | Releasing controllers, streams, timers |

💡 Every page in this project prints `start …` / `finish …`. Watch the console while navigating to **see** when pages are created and destroyed.

---

### 2. Forms & Validation

A `Form` groups many `TextFormField`s so they can be validated **together**.

```dart
final _keyForm = GlobalKey<FormState>();

Form(
  key: _keyForm,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "please enter valid username";   // ❌ error text
          }
          return null;                               // ✅ valid
        },
      ),
    ],
  ),
);

// On button press:
if (_keyForm.currentState!.validate()) {
  // all fields are valid
}
```

**Rules to remember**
- A `validator` returns a **String** → error shown under the field.
- A `validator` returns **null** → the field is valid.
- `validate()` runs **all** validators and returns `true` only if every one returns `null`.
- `obscureText: true` hides password characters.

---

### 3. TextEditingController & dispose()

A controller lets you **read**, **change**, and **clear** a field's text.

```dart
final _usernameController = TextEditingController();

TextFormField(controller: _usernameController);

_usernameController.text;     // read
_usernameController.clear();  // clear
```

⚠️ Controllers hold resources. **Always** dispose them, otherwise you get memory leaks:

```dart
@override
void dispose() {
  _usernameController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

---

### 4. Routing with go_router

All routes live in **one place** (`router.dart`) and are connected in `main.dart`:

```dart
MaterialApp.router(routerConfig: router);
```

```dart
final router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        // nested → full path is /home/products  (no leading "/")
        GoRoute(path: "products", builder: (context, state) => const ProductsPage()),
      ],
    ),
  ],
);
```

- **Top-level route:** starts with `/` (`/login`, `/home`).
- **Nested route:** written *without* `/`. Its full path is parent + child (`/home/products`).
- Opening a nested route with `go` automatically puts its parent underneath it in the stack.

---

### 5. go vs push vs pop

Think of navigation as a **stack of pages** (like a stack of plates).

| Method                  | What it does to the stack                              | Back button? |
|-------------------------|--------------------------------------------------------|--------------|
| `context.go("/path")`   | **Replaces** the stack to match the path               | Only to parents of the path |
| `context.push("/path")` | **Adds** a page on top of the current stack            | ✅ Yes, back to the previous page |
| `context.pop()`         | **Removes** the top page and returns to the one below  | — |

```
push("/signup"):   [Login]  →  [Login, Signup]     → pop() → [Login]
go("/home"):       [Login]  →  [Home]              → pop() → ❌ nothing to pop
```

**When to use which?**
- `go` → moving to a new "section" where going back makes no sense (e.g. after login, after logout).
- `push` → opening a page the user should come back from (e.g. Signup, details page).
- `pop` → closing the current page. You can also return data: `context.pop(value)`.

---

### 6. Route Guard with redirect

`redirect` runs **before every navigation**. Return a path to send the user somewhere else, or `null` to allow it.

```dart
redirect: (context, state) {
  final path = state.matchedLocation;
  if (path.startsWith("/home") && !Database.isLoggedIn) {
    return "/login";   // 🚫 blocked
  }
  return null;         // ✅ allowed
},
```

This means **any** route under `/home` is protected automatically.

---

### 7. Fake Database with static

There is no real backend yet. `Database` keeps values in `static` fields, so they are shared across the whole app **while it's running**:

```dart
class Database {
  static bool isLoggedIn = false;
  static String username = "Atef";
  static String password = "Atef12345";
}
```

- Access them without creating an object: `Database.username`.
- Values reset when the app restarts. That's expected, it's only for learning.

---

### 8. Keys & super.key

Every widget can receive an optional `Key`. Flutter uses keys to know **which widget is which** when the widget tree rebuilds.

```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});   // passes the key up to the parent class (Widget)
  ...
}
```

- `super.key` is shorthand for `HomePage({Key? key}) : super(key: key);`
- It lets anyone who uses your widget give it a key if needed.

**Two different kinds of keys in this project**

| Key                         | Purpose |
|-----------------------------|---------|
| `Key? key` via `super.key`  | Identifies the widget itself in the tree |
| `GlobalKey<FormState>`      | Gives you access to the Form's **State** from anywhere, to call `validate()` |

---

### 9. const Constructors

`const` creates a widget **once at compile time** and reuses it. Flutter can skip rebuilding it, which makes the app faster.

```dart
const Text("welcome to Home Page")          // ✅ fixed text
const SnackBar(content: Text("Wrong info")) // ✅ fixed content
Text("Welcome ${Database.username}")        // ❌ value changes at runtime → can't be const
```

To make a widget usable with `const`, its constructor must be `const`:

```dart
const LoginPage({super.key});
// then in router.dart:
builder: (context, state) => const LoginPage(),
```

💡 The analyzer shows **"Prefer const with constant constructors"** hints. Follow them!

---

### 10. Private Members with `_`

In Dart, a name that starts with `_` is **private to its file**.

```dart
class _LoginPageState extends State<LoginPage> {   // private State
  final _keyForm = GlobalKey<FormState>();         // private field
  void _inputCheck() { ... }                       // private method
}
```

**Why make State private?** No other file should create or touch a page's State directly. Only the widget's `createState()` should. This keeps your code safe and organized.

---

## 📝 Student Task

This repository is the **starting point**. Clone it and complete it:

1. **`super.key`**: add a `const` constructor with `{super.key}` to every widget.
2. **`const`**: use `const` wherever possible (and understand where it's *not* allowed).
3. **Private State**: rename every State class and its members with `_`.
4. **Signup Page**: a validated form (username, email, password, confirm password) that updates `Database.username` and `Database.password`.
5. **Navigation**: Login → Signup with `context.push`, back with `context.pop`, then experiment with `context.go` and explain the difference.

📌 Full instructions are shared by your instructor.

---

## 🐞 Common Errors

| Error / Symptom | Likely cause |
|-----------------|--------------|
| `There is nothing to pop` | You used `pop()` after `go()`, so there's no page below. |
| Can't open `/home` → back to login | The `redirect` guard: you're not logged in. |
| Form errors never appear | The `Form` has no `key`, or `validate()` wasn't called. |
| `A TextEditingController was used after being disposed` | You disposed it too early or used it after the page closed. |
| `Null check operator used on a null value` at `currentState!` | The `GlobalKey` isn't attached to a `Form` currently on screen. |

---

## 📖 Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [go_router package](https://pub.dev/packages/go_router)
- [Build a form with validation](https://docs.flutter.dev/cookbook/forms/validation)
- [Retrieve the value of a text field](https://docs.flutter.dev/cookbook/forms/retrieve-input)
- [StatefulWidget class](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [Keys in Flutter (video)](https://www.youtube.com/watch?v=kn0EOS-ZiIc)

---

<p align="center">Made with 💙 for the Flutter Course – Section 5</p>
