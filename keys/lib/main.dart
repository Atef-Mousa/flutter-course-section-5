/*
 * Keys Demo
 *
 * This project is used to explain:
 *  1. The relationship between a Widget and its State:
 *     the Widget is only a configuration, while the State is a separate
 *     object that Flutter keeps alive and matches to widgets in the tree.
 *  2. The importance of Keys:
 *     without a key, Flutter matches State to widgets by their type and
 *     position only, so removing an item can leave the wrong State
 *     (checked value / typed text) attached to the wrong widget.
 *     With a key (ValueKey, ObjectKey, UniqueKey), Flutter matches each
 *     State to the correct widget.
 */
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Demo()));

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<String> items = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keys  demo')),
      body: Column(
        children: [
          for (final item in items) WriteComment(key: ValueKey(item), title: item),

          ElevatedButton(
            onPressed: () => setState(() => items.removeAt(0)),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

class CheckItem extends StatefulWidget {
  final String title;

  const CheckItem({required this.title});

  @override
  State<CheckItem> createState() => _CheckItemState();
}

class _CheckItemState extends State<CheckItem> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: checked,
      onChanged: (bool? v) => setState(() => checked = v!),
    );
  }
}

class WriteComment extends StatefulWidget {
  final String title;

  const WriteComment({super.key,required this.title});

  @override
  State<WriteComment> createState() {
    return _WriteCommentState();
  }
}

class _WriteCommentState extends State<WriteComment> {

  @override
  void dispose() {
    print("we are out  from ${widget.title}");
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "write comment to ${widget.title}",
      ),
    );
  }
}
